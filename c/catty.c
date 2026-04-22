#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

int catty(
    FILE* input_file,
    bool show_ends,
    bool show_tabs,
    bool number
)
{
    // Input and Output in bulks to save IO performance.
    char inbuf[4096];
    char outbuf[sizeof(inbuf)*2];
    
    int lineno = 1;
    bool newline = true;
    size_t nread;
    // use syscall read instead of fread. fread is buffered, we need immediate data.
    // Not C standard but POSIX standard. So it should broke on Windows.
    while ((nread = read(fileno(input_file), inbuf, sizeof(inbuf))) > 0) {
        size_t outpos = 0;
        for (size_t i = 0; i < nread; ++i) {
            char c = inbuf[i];
            if (number && newline) {
                //Must be a gigantic file to have more than 16 digit long amount of lines.
                char linebuf[16];
                int linebuflen = snprintf(linebuf, sizeof(linebuf), "%6d\t", lineno);
                // Check for overflows
                if (outpos + linebuflen >= sizeof(outbuf)) {
                    fwrite(outbuf, 1, outpos, stdout);
                    outpos = 0;
                }
                memcpy(outbuf + outpos, linebuf, linebuflen);
                outpos += linebuflen;
                newline = false;
            }
            if (number && c == '\n') {
                ++lineno;
                newline = true;
            }
            if (show_ends && c == '\n') {
                // Check for overflows
                if (outpos + 2 >= sizeof(outbuf)) {
                    fwrite(outbuf, 1, outpos, stdout);
                    outpos = 0;
                }
                outbuf[outpos++] = '$';
                outbuf[outpos++] = '\n';
            } else if (show_tabs && c == '\t') {
                // Check for overflows
                if (outpos + 2 >= sizeof(outbuf)) {
                    fwrite(outbuf, 1, outpos, stdout);
                    outpos = 0;
                }
                outbuf[outpos++] = '^';
                outbuf[outpos++] = 'I';
            } else {
                // Check for overflows
                if (outpos + 1 >= sizeof(outbuf)) {
                    fwrite(outbuf, 1, outpos, stdout);
                    outpos = 0;
                }
                outbuf[outpos++] = c;
            }
        }
        
        if (outpos > 0) {
            fwrite(outbuf, 1, outpos, stdout);
        }
    }
}

void usage(int ret_code)
{
    fputs("\
Usage: catty [OPTION]... [FILE]...\n\
Options:\n\
        -E, --show-ends     display $ at end of each line\n\
        -n, --number        number all output lines\n\
        -T, --show-tabs     display TAB characters as ^I\n\
        --help              print this help section\n\
"
    , (ret_code == -1) ? stderr : stdout);
    exit(ret_code);
}

int main(int argc, char** argv)
{
    bool show_ends = false;
    bool show_tabs = false;
    bool number = false;

    int option_index = 0;
    static struct option options[] = {
        {"help", no_argument, 0, 0},
        {"show-ends", no_argument, 0, 'E'},
        {"show-tabs", no_argument, 0, 'T'},
        {"number", no_argument, 0, 'n'},
    };
    int current_option;
    while((current_option = getopt_long(argc, argv, "nTE", options, &option_index)) != -1) {
        switch (current_option) {
            case 0:
                if (strcmp(options[option_index].name, "help") == 0)
                    usage(0);
                break;
            case 'E':
                show_ends = true;
                break;
            case 'T':
                show_tabs = true;
                break;
            case 'n':
                number = true;
                break;
            default: usage(-1);
        }
    }
    if (optind == argc) {
        catty(stdin, show_ends, show_tabs, number);
    } else {
        for (int i = optind; i < argc; ++i) {
            const char* filename = argv[i];
            FILE* fp;
            if (fp = fopen(filename, "r")) {
                catty(fp, show_ends, show_tabs, number);
            } else {
                fprintf(stderr, "Err: %s: No such file or directory\n", filename);
            }
        }
    } 
}
