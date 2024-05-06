#include <stdlib.h>
#include <unistd.h>

#define lengthof(sstr) (sizeof (sstr) / sizeof *(sstr))
#define sstr_len(sstr) (lengthof(sstr) - 1)
#define sstr_unpack(sstr) (sstr), (sstr_len(sstr))

static const char GREETING[] = "hello, world!\n";

int main(void)
{
    return (
        write(STDOUT_FILENO, sstr_unpack(GREETING))
        == sstr_len(GREETING)
    ) ? EXIT_SUCCESS : EXIT_FAILURE;
}
