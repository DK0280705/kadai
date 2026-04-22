#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


bool is_alphabet(char c)
{
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

char shift_char(char c, int shift)
{
    int start = 0;
    if (c >= 'a' && c <= 'z')
        start = 'a';
    else if (c >= 'A' && c <= 'Z')
        start = 'A';

    int res = c + shift;

    if (res - start < 0) res += 26;
    else if (res - start > 25) res -= 26;
    
    return (char)res;
}

int main(int argc, const char** argv)
{
    if (argc < 4) return -1;

    FILE* input_file;
    FILE* output_file;
    int shift = atoi(argv[3]) % 26;

    printf("shift: %d\n", shift);

    if (!(input_file = fopen(argv[1], "r"))) {
        perror("fopen");
        return -1;
    }

    if (!(output_file = fopen(argv[2], "w"))) {
        perror("fopen");
        return -1;
    }

    char buffer[1024];
    size_t nread;
    while(nread = fread(buffer, sizeof(char), 1024, input_file)) {
        for (int i = 0; i < nread; ++i) {
            char c = buffer[i];
            if (is_alphabet(c) && shift) {
                c = shift_char(c, shift);
            }
            // Ignoring performance (though, gnuc implementation cover this problem)
            fputc(c, output_file);
        }
    }

    fclose(input_file);
    fclose(output_file);

    return 0;
}
