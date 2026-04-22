#include <stdio.h>

int main(void)
{
    int c;
    int line_count = 0;
    int word_count = 0;
    int last_char = 0;
    while((c = getchar()) != EOF) {
        if (last_char != c) {
            if (last_char != 0) {
                printf("%c(%d)", last_char, word_count);
            }
            last_char = c;
            word_count = 0;
        }
        ++word_count;
    }
    if (last_char) printf("%c(%d)\n", last_char, word_count);
}
