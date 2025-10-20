; Don't panic!

global main
extern printf

section .data
code_str db "; Don't panic!%1$c%1$cglobal main%1$cextern printf%1$c%1$csection .data%1$ccode_str db %2$c%3$s%2$c, 0%1$c%1$csection .text%1$c; 42 is the answer to life, the universe, and everything.%1$cprint_quine:%1$c%4$cxor rax, rax%1$c%4$center 0, 0%1$c%4$clea rdi, [rel code_str]%1$c%4$cmov rsi, 10%1$c%4$cmov rdx, 34%1$c%4$clea rcx, [rel code_str]%1$c%4$cmov r8, 9%1$c%4$ccall printf%1$c%4$cleave%1$c%4$cret%1$c%1$cmain:%1$c%4$center 0, 0%1$c%4$ccall print_quine%1$c%4$cxor rax, rax%1$c%4$cleave%1$c%4$cret%1$c%1$csection .note.GNU-stack noalloc noexec nowrite progbits%1$c", 0

section .text
; 42 is the answer to life, the universe, and everything.
print_quine:
	xor rax, rax
	enter 0, 0
	lea rdi, [rel code_str]
	mov rsi, 10
	mov rdx, 34
	lea rcx, [rel code_str]
	mov r8, 9
	call printf
	leave
	ret

main:
	enter 0, 0
	call print_quine
	xor rax, rax
	leave
	ret

section .note.GNU-stack noalloc noexec nowrite progbits
