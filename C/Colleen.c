#include <stdio.h>

/*
	Don't panic!
*/

void print_quine(char *s)
{
	printf(s, 10, 9, 34, s);
}

int main(void)
{
	// 42 is the answer to life, the universe, and everything.
	char *s = "#include <stdio.h>%1$c%1$c/*%1$c%2$cDon't panic!%1$c*/%1$c%1$cvoid print_quine(char *s)%1$c{%1$c%2$cprintf(s, 10, 9, 34, s);%1$c}%1$c%1$cint main(void)%1$c{%1$c%2$c// 42 is the answer to life, the universe, and everything.%1$c%2$cchar *s = %3$c%4$s%3$c;%1$c%2$cprint_quine(s);%1$c%2$creturn (0);%1$c}%1$c";
	print_quine(s);
	return (0);
}
