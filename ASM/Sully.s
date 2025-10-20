; Don't panic!
%define NEWLINE 10
%define QUOTE 34
%define TAB 9

global main
extern fopen
extern fprintf
extern fclose
extern sprintf
extern system
extern dprintf

section .data
i dd 5
src_format db "Sully_%d.s",0
exec_format db "Sully_%d",0
mode db "w",0
compile_format db "nasm -f elf64 %1$s -o %2$s.o && gcc -no-pie %2$s.o -o %2$s && rm %2$s.o",0
run_format db "./%s",0

section .bss
new_src_file resb 100
new_exec resb 100
compile_cmd resb 400
run_cmd resb 200

section .text
main:
	push rbp
	mov rbp,rsp
	push r12
	push r13

	mov r12d,dword [rel i]
	dec r12d
	cmp r12d,0
	jl .end

	lea rdi,[rel new_src_file]
	lea rsi,[rel src_format]
	mov edx,r12d
	xor eax,eax
	call sprintf

	lea rdi,[rel new_exec]
	lea rsi,[rel exec_format]
	mov edx,r12d
	xor eax,eax
	call sprintf

	lea rdi,[rel new_src_file]
	lea rsi,[rel mode]
	call fopen
	test rax,rax
	jz .end
	mov r13,rax

	mov rdi,r13
	lea rsi,[rel tpl]
	mov edx,NEWLINE
	mov ecx,QUOTE
	mov r8d,r12d
	lea r9,[rel tpl]
	xor eax,eax
	call fprintf

	mov rdi,r13
	call fclose

	lea rdi,[rel compile_cmd]
	lea rsi,[rel compile_format]
	lea rdx,[rel new_src_file]
	lea rcx,[rel new_exec]
	xor eax,eax
	call sprintf
	lea rdi,[rel compile_cmd]
	call system

	lea rdi,[rel run_cmd]
	lea rsi,[rel run_format]
	lea rdx,[rel new_exec]
	xor eax,eax
	call sprintf
	lea rdi,[rel run_cmd]
	call system

.end:
	pop r13
	pop r12
	pop rbp
	xor rax,rax
	ret

section .rodata
tpl db "; Don't panic!%1$c%%define NEWLINE 10%1$c%%define QUOTE 34%1$c%%define TAB 9%1$c%1$cglobal main%1$cextern fopen%1$cextern fprintf%1$cextern fclose%1$cextern sprintf%1$cextern system%1$cextern dprintf%1$c%1$csection .data%1$ci dd %3$d%1$csrc_format db %2$cSully_%%d.s%2$c,0%1$cexec_format db %2$cSully_%%d%2$c,0%1$cmode db %2$cw%2$c,0%1$ccompile_format db %2$cnasm -f elf64 %%1$s -o %%2$s.o && gcc -no-pie %%2$s.o -o %%2$s && rm %%2$s.o%2$c,0%1$crun_format db %2$c./%%s%2$c,0%1$c%1$csection .bss%1$cnew_src_file resb 100%1$cnew_exec resb 100%1$ccompile_cmd resb 400%1$crun_cmd resb 200%1$c%1$csection .text%1$cmain:%1$c	push rbp%1$c	mov rbp,rsp%1$c	push r12%1$c	push r13%1$c%1$c	mov r12d,dword [rel i]%1$c	dec r12d%1$c	cmp r12d,0%1$c	jl .end%1$c%1$c	lea rdi,[rel new_src_file]%1$c	lea rsi,[rel src_format]%1$c	mov edx,r12d%1$c	xor eax,eax%1$c	call sprintf%1$c%1$c	lea rdi,[rel new_exec]%1$c	lea rsi,[rel exec_format]%1$c	mov edx,r12d%1$c	xor eax,eax%1$c	call sprintf%1$c%1$c	lea rdi,[rel new_src_file]%1$c	lea rsi,[rel mode]%1$c	call fopen%1$c	test rax,rax%1$c	jz .end%1$c	mov r13,rax%1$c%1$c	mov rdi,r13%1$c	lea rsi,[rel tpl]%1$c	mov edx,NEWLINE%1$c	mov ecx,QUOTE%1$c	mov r8d,r12d%1$c	lea r9,[rel tpl]%1$c	xor eax,eax%1$c	call fprintf%1$c%1$c	mov rdi,r13%1$c	call fclose%1$c%1$c	lea rdi,[rel compile_cmd]%1$c	lea rsi,[rel compile_format]%1$c	lea rdx,[rel new_src_file]%1$c	lea rcx,[rel new_exec]%1$c	xor eax,eax%1$c	call sprintf%1$c	lea rdi,[rel compile_cmd]%1$c	call system%1$c%1$c	lea rdi,[rel run_cmd]%1$c	lea rsi,[rel run_format]%1$c	lea rdx,[rel new_exec]%1$c	xor eax,eax%1$c	call sprintf%1$c	lea rdi,[rel run_cmd]%1$c	call system%1$c%1$c.end:%1$c	pop r13%1$c	pop r12%1$c	pop rbp%1$c	xor rax,rax%1$c	ret%1$c%1$csection .rodata%1$ctpl db %2$c%4$s%2$c,0%1$c%1$csection .note.GNU-stack noalloc noexec nowrite progbits%1$c",0

section .note.GNU-stack noalloc noexec nowrite progbits
