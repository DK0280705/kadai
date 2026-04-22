#include <stdio.h>

void printBin(int n);

int main()
{
    char buffer[256];
    int decimal;
    printf("10進数の整数を入力してください: ");
    fgets(buffer, 256, stdin);
    sscanf(buffer, "%d", &decimal);
    if (decimal < 0) {
        puts("正の整数を入力してください");
        return 1;
    }
    
    printf("2進数表現: ");
    printBin(decimal);
    putchar('\n');
}

void printBin(int n)
{
    if (n/2 != 0) printBin(n/2);
    putchar((n % 2) + '0');
}


