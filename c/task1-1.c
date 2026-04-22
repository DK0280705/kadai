#include <stdio.h>
#include <stdlib.h>

static inline void panic(char const* message)
{
    fprintf(stderr, "panic: %s\n", message);
    exit(-1);
}

int combination(int n, int r)
{
    if (r > n) panic("r could not be bigger than n");
    else if (r == n || r == 0) return 1;
    else return combination(n - 1, r - 1) + combination(n - 1, r);
}

static int input(register int* n, register int* r) {
    char buffer[64]; // Stack memory allocation is O(1)
    return (fgets(buffer, sizeof(buffer), stdin) != NULL
        && sscanf(buffer, "%dC%d\n", n, r) == 2) ? 1 : 0;
}

int main()
{
    int n, r;
    do {
        printf("Input in format nCr (e.g., 5C2): ");
    } while (!input(&n, &r));
    printf("result: %d\n", combination(n, r));
}
