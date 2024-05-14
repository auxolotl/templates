#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    char greet[] = "hello, world!\n";
    int written = printf("%s", greet);

    return written == (sizeof(greet) - 1)
        ? EXIT_SUCCESS : EXIT_FAILURE;
}
