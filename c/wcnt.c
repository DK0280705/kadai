#include <stdio.h>
#include <stdint.h>

void print_count(FILE* file_input)
{   
    uint64_t line_count = 0;
    uint64_t word_count = 0;
    uint64_t char_count = 0;

    char buffer[1024];

    char last_is_word = 0;
    while (fgets(buffer, sizeof(buffer), file_input)) {
        for (int i = 0; i < sizeof(buffer); ++i) {
            char c = buffer[i];
            if (c == ' ' || c == '\t' || c == '\n' || c == '\0') {
                if (last_is_word) {
                    last_is_word = 0;
                    ++word_count;
                }
                if (c == '\0') break;
                if (c == '\n') ++line_count;
            } else last_is_word = 1;
            ++char_count;
        }
    }
    printf("l=%ld w=%ld c=%ld\n", line_count, word_count, char_count);

}

int main(int argc, const char** argv)
{
    if (argc == 1) {
        // use stdin file stream
        print_count(stdin);
    } else {
        for (int i = 1; i < argc; ++i) {
            const char* filename = argv[i];
            FILE* fp; 
            if (fp = fopen(filename, "r")) {
                printf("%s: ", filename);
                print_count(fp);
                fclose(fp);
            } else {
                fprintf(stderr, "Err: %s: No such file or directory\n", filename);
            }
        }
    }
}


