#include <stdio.h>

/*
    Don't panic!
*/

void print_quine(char *s)
{
    printf(s, s);
}

int main(void)
{
    /*
        42 is the answer to life, the universe, and everything.
    */
    char *s = "TBA";
    print_quine(s);
    return (0);
}
