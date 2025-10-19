#include <stdio.h>
#define OUTPUT_FILE "Grace_kid.c"
#define QUINE(src) int main(void) {FILE *f = fopen(OUTPUT_FILE, "w"); if(f) {fprintf(f, src, 10, 34, 9, src); fclose(f);} return (0);}
#define SOURCE "#include <stdio.h>%1$c#define OUTPUT_FILE %2$cGrace_kid.c%2$c%1$c#define QUINE(src) int main(void) {FILE *f = fopen(OUTPUT_FILE, %2$cw%2$c); if(f) {fprintf(f, src, 10, 34, 9, src); fclose(f);} return (0);}%1$c#define SOURCE %2$c%4$s%2$c%1$c/*%1$c%3$cDon't panic!%1$c*/%1$cQUINE(SOURCE)%1$c"
/*
	Don't panic!
*/
QUINE(SOURCE)
