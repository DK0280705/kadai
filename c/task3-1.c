#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
    char* data;
    size_t len;
} buffer_t;

static inline bool is_digit(char c)
{
    return (c >= '0' && c <= '9');
}

uint32_t m_atoi(const char* str);

void dtob(buffer_t binary, uint32_t decimal);

int main(int argc, const char** argv)
{
    if (argc == 1) {
        printf("dtob is a program that converts base 10 input into base 2 decimal.\nOnly supports unsigned integer input.\nUsage: $ ./dtob {Number Array}\n");
        return -1;
    }

    for (int i = 1; i < argc; ++i) {
        uint32_t decimal = m_atoi(argv[i]);

        char data[33] = {0}; // Initialize data, use stack instead of heap; + 1 for \0
        buffer_t binary = { data, 32 }; // Make a reference to initialized data before.

        dtob(binary, decimal);
        data[32] = '\0';

        printf("%10d => %s\n", decimal, data);
    }
    return 0;
}

void dtob(buffer_t binary, uint32_t decimal)
{
    size_t rcount = binary.len;
    while(rcount) {
        // Use reversed assignment method.
        binary.data[--rcount] = (decimal % 2) + '0';
        if (decimal) decimal /= 2;
    }
}

uint32_t m_atoi(const char* str)
{
    const char* temp = str;
    uint32_t result = 0;
    char c = 0;
    while((c = *str++)) {
        if (!is_digit(c)) {
            fprintf(stderr, "Err: %s is not a valid number\n", temp);
            exit(-1);
        }
        result *= 10;
        result += c - '0';
    }
    return result;
}
