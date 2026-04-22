#include <stdio.h>
#include <stdlib.h>

int gcd(int x, int y)
{
    return (y == 0) ? x : gcd(y, x % y);
}

static int input(register int* n, register int* r) {
    char buffer[64]; // Stack memory allocation is O(1)
    return (fgets(buffer, sizeof(buffer), stdin) != NULL
        && sscanf(buffer, "%d %d\n", n, r) == 2) ? 1 : 0;
}

int main()
{
    int n, r;
    do {
        printf("Input in format x y (e.g., 5 2): ");
    } while (!input(&n, &r));
    printf("result: %d\n", (n, r));
}
