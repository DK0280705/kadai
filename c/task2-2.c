#include <stdio.h>
#include <string.h>

int m_strcmp(const char* lhs, const char* rhs);


int main(int argc, const char** argv) {
    char str1[] = "aB";
    char str2[] = "ab";
    printf("文字比較(abc:abc): %d\n", strcmp("abc", "abc"));
    printf("文字比較(aB:ab): %d\n", strcmp(str1, str2));
    printf("文字比較(ab:aB): %d\n", strcmp("ab", "aB"));
    printf("文字比較(abc:ab): %d\n", strcmp("abc", "ab"));
    printf("文字比較(ab:abc): %d\n", strcmp("ab", "abc"));

    printf("文字比較(abc:abc): %d\n", m_strcmp("abc", "abc"));
    printf("文字比較(aB:ab): %d\n", m_strcmp("aB", "ab"));
    printf("文字比較(ab:aB): %d\n", m_strcmp("ab", "aB"));
    printf("文字比較(abc:ab): %d\n", m_strcmp("abc", "ab"));
    printf("文字比較(ab:abc): %d\n", m_strcmp("ab", "abc"));
    return 0;
}

int m_strcmp(const char* lhs, const char* rhs) {
    while(*lhs && *lhs == *rhs) {
        ++lhs;
        ++rhs;
    }
    return *rhs - *lhs;
}
