; Don't panic!
%define NEWLINE 10
%define QUOTE 34
%define TAB 9

global main
extern fopen
extern fprintf
extern fclose

section .data
filename db "Grace_kid.s", 0
mode db "w", 0
fmt db "; Don't panic!%1$c%%define NEWLINE %2$d%1$c%%define QUOTE %3$d%1$c%%define TAB %4$d%1$c%1$cglobal main%1$cextern fopen%1$cextern fprintf%1$cextern fclose%1$c%1$csection .data%1$cfilename db %5$cGrace_kid.s%5$c, 0%1$cmode db %5$cw%5$c, 0%1$cfmt db %5$c%6$s%5$c, 0%1$c%1$csection .text%1$cmain:%1$c%7$cxor rax, rax%1$c%7$center 0, 0%1$c%7$clea rdi, [rel filename]%1$c%7$clea rsi, [rel mode]%1$c%7$ccall fopen%1$c%7$ctest rax, rax%1$c%7$cjz .end%1$c%7$cmov r12, rax%1$c%7$cmov rdi, r12%1$c%7$clea rsi, [rel fmt]%1$c%7$cmov rdx, NEWLINE%1$c%7$cmov rcx, NEWLINE%1$c%7$cmov r8,  QUOTE%1$c%7$cmov r9,  TAB%1$c%7$cmov rax, TAB%1$c%7$cpush rax%1$c%7$clea rax, [rel fmt]%1$c%7$cpush rax%1$c%7$cmov rax, QUOTE%1$c%7$cpush rax%1$c%7$cxor rax, rax%1$c%7$ccall fprintf%1$c%7$cadd rsp, 24%1$c%7$cmov rdi, r12%1$c%7$ccall fclose%1$c.end:%1$c%7$cxor rax, rax%1$c%7$cleave%1$c%7$cret%1$c%1$csection .note.GNU-stack noalloc noexec nowrite progbits%1$c", 0

section .text
main:
	xor rax, rax
	enter 0, 0
	lea rdi, [rel filename]
	lea rsi, [rel mode]
	call fopen
	test rax, rax
	jz .end
	mov r12, rax
	mov rdi, r12
	lea rsi, [rel fmt]
	mov rdx, NEWLINE
	mov rcx, NEWLINE
	mov r8,  QUOTE
	mov r9,  TAB
	mov rax, TAB
	push rax
	lea rax, [rel fmt]
	push rax
	mov rax, QUOTE
	push rax
	xor rax, rax
	call fprintf
	add rsp, 24
	mov rdi, r12
	call fclose
.end:
	xor rax, rax
	leave
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
