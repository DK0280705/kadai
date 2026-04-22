#include <stdio.h>
#include <string.h>
#define N 20

size_t m_strlen(const char* str); 
size_t strlen_a(const char s[]);
size_t strlen_p1(const char* s);
size_t strlen_p2(const char* s);

int main(int argc, const char** argv) {
    const char str1[N] = "Hello World!!";

    printf("strlen: %ld\n", strlen(str1));
    printf("m_strlen: %ld\n", m_strlen(str1));
    printf("strlen_a: %ld\n", strlen_a(str1));
    printf("strlen_p1: %ld\n", strlen_p1(str1));
    printf("strlen_p2: %ld\n", strlen_p2(str1));

    const char str2[N];
    fgets(str2, sizeof(str2), stdin);

    printf("strlen: %ld\n", strlen(str2));
    printf("m_strlen: %ld\n", m_strlen(str2));
    printf("strlen_a: %ld\n", strlen_a(str2));
    printf("strlen_p1: %ld\n", strlen_p1(str2));
    printf("strlen_p2: %ld\n", strlen_p2(str2));

    return 0;
}

size_t m_strlen(const char* str) {
    const char* tmp = str;
    while(*tmp)
        ++tmp;
    return tmp - str;
}

size_t strlen_a(const char s[]) {
    size_t len = 0;
    for (; s[len] != '\0'; len++); // s[len]という表現は*(s+len)と等しい
    return len;
}

size_t strlen_p1(const char* s) {
    size_t len = 0;
    for (; *s != '\0'; s++) len++;
    return len;
}

size_t strlen_p2(const char* s) {
    size_t len = 0;
    for (; *(s+len) != '\0'; len++);
    return len;
}
