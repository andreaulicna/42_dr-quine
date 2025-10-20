# 42_dr-quine

A collection of self-replicating programs (quines) written in C and x86-64 assembly. Each program demonstrates different techniques for self-reproduction:

- **Colleen**: Basic quine that prints its own source code to stdout
- **Grace**: Quine that writes its source code to a file
- **Sully**: Recursive quine that generates, compiles, and executes decreasing copies of itself

All programs use positional printf format specifiers to embed their source code within themselves, creating perfect self-replicas.

---

<details>
<summary><strong>Colleen (C quine)</strong></summary>

Colleen prints its own source code (a "quine") while satisfying the subject rules:
- A main function.
- Two different comments (one inside main, one outside).
- Another function that is called.

### How it works

- The entire source is stored in a string variable `s`.
- That string is used as a printf format string with positional specifiers so we can:
  - Insert newlines, tabs, and quotes without escaping them in the big string.
  - Insert the string `s` itself (self-reproduction).
```c
printf(s, 10, 9, 34, s);
```
Mapping of positional specifiers:
- `%1$c` → 10 → newline (`'\n'`)
- `%2$c` → 9 → tab (`'\t'`)
- `%3$c` → 34 → double quote (`'"'`)
- `%4$s` → `s` → the full format string (source)

### File structure and requirements

- Outside comment:
  ```
  /*
      Don't panic!
  */
  ```
- Inside comment:
  ```c
  // 42 is the answer to life, the universe, and everything.
  ```
- Extra function - a tiny printf wrapper:
  ```c
  void print_quine(char *s)
  {
      printf(s, 10, 9, 34, s);
  }
  ```

### Build and verify

```bash
make Colleen
./Colleen > tmp_Colleen
diff -q Colleen.c tmp_Colleen && echo $?    # quiet mode: only reports if files differ
diff -u Colleen.c tmp_Colleen               # unified format: shows line-by-line differences with context
```

`cat -A Colleen.c && cat -A tmp_Colleen` shows all characters including non-printables:
- `$` at line ends (shows LF)
- `^I` for tabs
- `^M` for carriage return (CRLF)

</details>

<br>

<details>
<summary><strong>Grace (C quine)</strong></summary>

Grace writes its own source code to a file `Grace_kid.c` while satisfying the subject rules:
- No functions declared (main is generated via macro expansion).
- Exactly three `#define` directives.
- One comment.

### How it works

Grace uses C preprocessor macros to:
1. Define the output filename
2. Define a macro that expands into the entire `main()` function
3. Define the source code as a format string
4. Invoke the macro to generate and execute `main()`

```c
#define OUTPUT_FILE "Grace_kid.c"
#define QUINE(src) int main(void) {FILE *f = fopen(OUTPUT_FILE, "w"); if(f) {fprintf(f, src, 10, 34, 9, src); fclose(f);} return (0);}
#define SOURCE "...entire source as format string..."
QUINE(SOURCE)  // expands to main() and executes
```

The `fprintf` call inside the macro:
```c
fprintf(f, src, 10, 34, 9, src);
```

Mapping of positional specifiers:
- `%1$c` → 10 → newline (`'\n'`)
- `%2$c` → 34 → double quote (`'"'`)
- `%3$c` → 9 → tab (`'\t'`)
- `%4$s` → `src` → the full format string (source)

### File structure and requirements

- Three defines:
  1. `OUTPUT_FILE` - the target filename
  2. `QUINE(src)` - macro that expands to `main()` function
  3. `SOURCE` - the entire source code as a format string

- One comment:
  ```c
  /*
      Don't panic!
  */
  ```

- No declared functions (main is created via macro expansion)

### Build and verify

```bash
make Grace
./Grace
diff -q Grace.c Grace_kid.c && echo $?  # quiet mode: only reports if files differ
diff -u Grace.c Grace_kid.c             # unified format: shows line-by-line differences with context
```

`cat -A Colleen.c && cat -A tmp_Colleen` shows all characters including non-printables:
- `$` at line ends (shows LF)
- `^I` for tabs
- `^M` for carriage return (CRLF)

</details>

<br>

<details>
<summary><strong>Sully (C quine)</strong></summary>

Sully repeatedly writes, compiles, and optionally runs copies of itself with a decreasing counter. It starts at 5 and stops after producing Sully_0 (13 files total: 1 original binary + 5 sources + 5 binaries + the original source).

### What the program does

- Initializes a counter `i = 5`.
- Immediately decrements: `i--` so the first child is `Sully_4`.
- Stops if `i < 0` (prevents generating `Sully_-1`).
- Writes a new C file named `Sully_<i>.c` containing:
  - The full program as a single printf-format string.
  - The current value of `i` embedded inside that string.
  - The same logic (decrement, stop checks, compile, optional run).
- Compiles that file to an executable named `Sully_<i>`.
- Runs the new executable only if `i > 0` (so `Sully_0` is compiled but not executed).

Execution chain:
```
./Sully  →  Sully_4.c → ./Sully_4 → Sully_3.c → ./Sully_3 → … → Sully_0.c (stop)
```

#### Why 13 files (and no Sully_5)?
This matches the subject’s example: running `ls -al | grep Sully | wc -l` after execution outputs `13`.

- We decrement before writing the first clone, so the highest child index is 4.
- The code never reaches the execution of `Sully_0` thanks to the early guard of `if (i < 0) return (0);`
- Files created:
  - Source: Sully_4.c, Sully_3.c, Sully_2.c, Sully_1.c, Sully_0.c
  - Binaries: Sully_4, Sully_3, Sully_2, Sully_1, Sully_0
  - Originals: Sully.c and Sully (the first binary)

### Core of the implementation

- The entire program is stored in a single format string `s`. We print that string into a new file with positional format specifiers.
- The write step:
  ```c
  fprintf(f, s, 10, 34, s, i, 9);
  ```
  Mapping of positional placeholders inside `s`:
  - `%1$c` → 10 → newline `'\n'`
  - `%2$c` → 34 → double quote `'"'`
  - `%3$s` → `s` → the full format string (source)
  - `%4$d` → `i` → the current counter
  - `%5$c` → 9 → tab `'\t'`

- The stop and run checks:
  ```c
  i--;
  if (i < 0) return (0);     // do not generate/compile when i == -1
  ...
  if (i > 0) {               // do not run Sully_0
      system(run_cmd);
  }
  ```

- The compile and run steps:
  ```c
  // Compile with strict warnings
  sprintf(compile_cmd, "cc -Wall -Wextra -Werror -o %s %s", new_exec, new_src_file);
  system(compile_cmd);

  // Execute only when i > 0
  sprintf(run_cmd, "./%s", new_exec);
  system(run_cmd);
  ```

- A comment “Don’t panic!” is included both in the original file and reproduced in all generated files.

### Build and verify

- Build and run:
  ```bash
  make Sully
  ./Sully
  ```

- Count outputs (expect 13):
  ```bash
  ls -1 | grep Sully | wc -l
  ```

- Minimal difference check (counter only):
  ```bash
  diff Sully.c Sully_0.c
  # Expected first change: "int i = 5;"  →  "int i = 0;"
  ```

- Detailed context diff:
  ```bash
  diff -u Sully.c Sully_0.c
  ```
</details>

<br>

<details>
<summary><strong>Colleen (ASM quine)</strong></summary>

This Colleen is a quine written in x86-64 assembly for Linux.

### What is assembly?

Assembly language is the lowest-level programming language (above raw machine code). Instead of high-level constructs like functions and loops, one works directly with:
- **Registers**: CPU storage locations, e.g. rax, rdi, rsi
- **Instructions**: Basic operations, e.g. mov, lea, call, ret
- **Sections**: Memory regions, e.g. .data for variables, .text for code

### Architecture overview

**x86-64 Linux calling convention:**
When calling a function like `printf`, arguments are passed in specific registers:
1. `rdi` = 1st argument
2. `rsi` = 2nd argument
3. `rdx` = 3rd argument
4. `rcx` = 4th argument
5. `r8` = 5th argument
6. `r9` = 6th argument
7. Stack for 7+ arguments

Also:
- `rax` = return value (and must be 0 for variadic functions like printf to indicate no floating-point args)
- Stack must be 16-byte aligned before `call`:
  - The stack pointer (`rsp`) must point to a memory address divisible by 16 - required by the x86-64 ABI for performance and compatibility
  - Some CPU instructions (SSE/AVX) crash if the stack isn't aligned
  - When the `call` function is called, the return address (8 bytes) is pushed, so if `rsp` was aligned before `call`, it becomes misaligned inside the function
  - The `enter` instruction accounts for this automatically

### How Colleen works

#### 1. Data section - the format string
```asm
section .data
code_str db "...", 0
```
- `db` "define bytes", i.e. stores a string, which contains the entire program as a printf format string, in memory
- `, 0` null terminator  as C strings must end with 0

#### 2. Code structure
```asm
section .text

print_quine:
    
main:
    call print_quine  ; main just calls print_quine
    ret
```
- Two functions: `main` (entry point) and `print_quine` (does the work)
- Separating them satisfies the "must have a function" requirement from the subject

#### 3. The print_quine function breakdown

**Setup:**
```asm
xor rax, rax        ; Set rax = 0 (tells printf: 0 floating-point args)
enter 0, 0          ; Create stack frame (like function prologue)
```

**Load arguments for printf:**
```asm
lea rdi, [rel code_str]    ; rdi = address of format string (1st arg)
mov rsi, 10                ; rsi = 10 = newline '\n' (2nd arg, %1$c)
mov rdx, 34                ; rdx = 34 = quote '"' (3rd arg, %2$c)
lea rcx, [rel code_str]    ; rcx = format string again (4th arg, %3$s)
mov r8, 9                  ; r8 = 9 = tab '\t' (5th arg, %4$c)
```

**Call printf and return:**
```asm
call printf        ; Execute printf(code_str, 10, 34, code_str, 9)
leave              ; Destroy stack frame
ret                ; Return to caller
```

#### 4. Understanding the format string

The format string uses **positional parameters**:
- `%1$c` = print argument 1 as a character (newline)
- `%2$c` = print argument 2 as a character (quote)
- `%3$s` = print argument 3 as a string (the format string itself)
- `%4$c` = print argument 4 as a character (tab)

Example snippet from the format string:
```
"; Don't panic!%1$c%1$c"
```
Becomes:
```
; Don't panic!
↵  (two newlines)
```

**Why `lea` and not `mov`?**
- `mov rdi, code_str` would try to load the **value** at code_str
- `lea rdi, [rel code_str]` loads the **address** (what printf needs)
- `[rel ...]` makes it position-independent (works regardless of where the binary is loaded in memory)

#### 5. The GNU-stack section
```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```
- Tells the linker: "this program doesn't need an executable stack"
- Modern security feature  which prevents stack-based exploits
- Must be included in both the source AND the format string (for quine reproduction)
- `noexec` = stack is not executable

### Comments in assembly

```asm
; This is a comment
```
- Assembly comments start with `;`
- The subject requires one comment outside a function - before `section .text`
- And one comment inside a function - inside `print_quine`

### Build and verify

**Assemble:**
```bash
nasm -f elf64 Colleen.s -o Colleen.o
```
- `nasm` is the Netwide Assembler
- `-f elf64` specifies the output format, i.e. Linux 64-bit ELF
- Produces an object file - not yet executable

**Link:**
```bash
gcc -no-pie Colleen.o -o Colleen
```
- `gcc` links the object file with the C standard library (for printf)
- `-no-pie` = disable Position Independent Executable (required for our code style)

**Run and verify:**
```bash
./Colleen > tmp_Colleen
diff Colleen.s tmp_Colleen
```

### Other notes

- `printf` can modify certain registers - always set `rax = 0` before calling printf
- The `enter`/`leave` pair manages the stack frame
- In assembly, entry points  must be explicitly declares with `global`

</details>

<br>

<details>
<summary><strong>Grace (ASM quine)</strong></summary>

### How it works

Grace uses assembly macros and file operations to:
1. Define constants (NEWLINE, QUOTE, TAB) as macros
2. Open a file for writing
3. Use `fprintf` to write the entire source code with positional format specifiers
4. Close the file

```asm
%define NEWLINE 10
%define QUOTE 34
%define TAB 9
```

The `fprintf` call:
```asm
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
```

### Detailed Code Breakdown

#### Macros and Declarations
```asm
; Don't panic!
%define NEWLINE 10
%define QUOTE 34
%define TAB 9
```
- The single comment required by the subject.
- Three macros defining ASCII values for special characters.

```asm
global main
extern fopen
extern fprintf
extern fclose
```
- `global main`: Declares the entry point of the program.
- `extern` declarations: Links to C standard library functions for file operations.

#### Data Section
```asm
section .data
filename db "Grace_kid.s", 0
mode db "w", 0
```
- `filename`: String containing the output file name, null-terminated.
- `mode`: String specifying write mode for `fopen`, null-terminated.

```asm
fmt db "; ...", 0
```
- `fmt`: Format string containing the entire source code with positional specifiers.

Mapping of positional specifiers:
- `%1$c` → NEWLINE (10) → newline character
- `%2$d` → NEWLINE (10) → decimal value for macro definition
- `%3$d` → QUOTE (34) → decimal value for macro definition
- `%4$d` → TAB (9) → decimal value for macro definition
- `%5$c` → QUOTE (34) → quote character for strings
- `%6$s` → fmt itself → the full format string (quine reproduction)
- `%7$c` → TAB (9) → tab character for indentation

#### Text Section - Main Function

```asm
section .text
main:
    xor rax, rax
    enter 0, 0
```
- `xor rax, rax`: Clears `rax` to 0 (required for variadic functions like `fprintf`).
- `enter 0, 0`: Creates a stack frame (function prologue).


```asm
    lea rdi, [rel filename]
    lea rsi, [rel mode]
    call fopen
```
- `lea rdi, [rel filename]`: Loads address of filename into `rdi` (1st argument).
- `lea rsi, [rel mode]`: Loads address of mode into `rsi` (2nd argument).
- `call fopen`: Opens the file, returns file pointer in `rax`.


```asm
    test rax, rax
    jz .end
```
- `test rax, rax`: Checks if file pointer is NULL (file open failed).
- `jz .end`: Jump to end if file opening failed.


```asm
    mov r12, rax
```
- Saves the file pointer in `r12` (callee-saved register).


```asm
    mov rdi, r12
    lea rsi, [rel fmt]
```
- `mov rdi, r12`: File pointer as 1st argument for `fprintf`.
- `lea rsi, [rel fmt]`: Format string address as 2nd argument.


```asm
    mov rdx, NEWLINE
    mov rcx, NEWLINE
    mov r8,  QUOTE
    mov r9,  TAB
```
- Loads arguments 3-6 into registers according to x86-64 calling convention:
  - `rdx` = 3rd arg = NEWLINE (for %1$c)
  - `rcx` = 4th arg = NEWLINE (for %2$d)
  - `r8` = 5th arg = QUOTE (for %3$d and %5$c)
  - `r9` = 6th arg = TAB (for %4$d)


```asm
    mov rax, TAB
    push rax
    lea rax, [rel fmt]
    push rax
    mov rax, QUOTE
    push rax
```
- Arguments 7+ go on the stack (in reverse order):
  - Push TAB (for %7$c)
  - Push address of fmt (for %6$s - the quine part)
  - Push QUOTE (additional for %5$c)


```asm
    xor rax, rax
    call fprintf
```
- `xor rax, rax`: Set `rax` to 0 (no floating-point arguments).
- `call fprintf`: Write the formatted string to the file.


```asm
    add rsp, 24
```
- Clean up the stack: 3 pushes × 8 bytes = 24 bytes.


```asm
    mov rdi, r12
    call fclose
```
- `mov rdi, r12`: File pointer as argument.
- `call fclose`: Close the file.


```asm
.end:
    xor rax, rax
    leave
    ret
```
- `.end`: Label for error exit or normal completion.
- `xor rax, rax`: Set return value to 0 (success).
- `leave`: Tear down stack frame.
- `ret`: Return from main.


```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```
- Security feature indicating the stack should not be executable.


### Build and verify

**Assemble:**
```bash
nasm -f elf64 Grace.s -o Grace.o
```
- `nasm`: Netwide Assembler
- `-f elf64`: Linux 64-bit ELF output format
- Produces an object file

**Link:**
```bash
gcc -no-pie Grace.o -o Grace
```
- Links with C standard library (for fopen, fprintf, fclose)
- `-no-pie`: Disable Position Independent Executable

**Run and verify:**
```bash
./Grace
diff -q Grace.s Grace_kid.s && echo $?
diff -u Grace.s Grace_kid.s
```

</details>

<br>

<details>
<summary><strong>Sully (ASM quine)</strong></summary>

Sully repeatedly writes, compiles, and runs copies of itself with a decreasing counter. It starts at 5 and stops after producing Sully_0 (13 files total: 1 original binary + 5 sources + 5 binaries + the original source).

### What the program does

- Initializes a counter `i = 5` in the data section.
- Immediately decrements: `i--` so the first child is `Sully_4`.
- Stops if `i < 0` (prevents generating `Sully_-1`).
- Writes a new assembly file named `Sully_<i>.s` containing:
  - The full program as a single fprintf-format string.
  - The current value of `i` embedded inside that string.
  - The same logic (decrement, stop checks, compile, run).
- Compiles that file to an executable named `Sully_<i>`.
- Runs the new executable (which continues the chain).

Execution chain:
```
./Sully  →  Sully_4.s → ./Sully_4 → Sully_3.s → ./Sully_3 → … → Sully_0.s (stop)
```

### Architecture Overview

**Memory sections:**
- `.data`: Initialized data (counter `i`, format strings)
- `.bss`: Uninitialized buffers (filename buffers, command buffers)
- `.text`: Executable code (main function)
- `.rodata`: Read-only data (the template string `tpl`)

**Registers used:**
- `r12d`: Holds the decremented counter value
- `r13`: Holds the file pointer from fopen
- `rbp`: Base pointer (stack frame)
- `rsp`: Stack pointer

### Detailed Code Breakdown

#### Macros and Declarations
```asm
; Don't panic!
%define NEWLINE 10
%define QUOTE 34
%define TAB 9
```
- Macros for ASCII values of special characters.

```asm
global main
extern fopen
extern fprintf
extern fclose
extern sprintf
extern system
```
- `global main`: Entry point.
- `extern` declarations: Links to C standard library functions.

#### Data Section
```asm
section .data
i dd 5
src_format db "Sully_%d.s",0
exec_format db "Sully_%d",0
mode db "w",0
compile_format db "nasm -f elf64 %1$s -o %2$s.o && gcc -no-pie %2$s.o -o %2$s && rm %2$s.o",0
run_format db "./%s",0
```
- `i dd 5`: Counter initialized to 5 (dword = 32-bit integer).
- Format strings for filenames and shell commands.
- `%1$s`, `%2$s`: Positional parameters for sprintf (avoids needing more arguments).

#### BSS Section (Uninitialized Buffers)
```asm
section .bss
new_src_file resb 100
new_exec resb 100
compile_cmd resb 400
run_cmd resb 200
```
- `resb`: Reserve bytes (uninitialized).
- Buffers to hold generated filenames and shell commands.

#### Main Function - Setup
```asm
main:
    push rbp
    mov rbp,rsp
    push r12
    push r13
```
- Standard function prologue: save base pointer and callee-saved registers.

#### Decrement and Stop Check
```asm
    mov r12d,dword [rel i]
    dec r12d
    cmp r12d,0
    jl .end
```
- Load counter into `r12d` (32-bit portion of r12).
- Decrement immediately (first child will be Sully_4).
- Compare with 0.
- Jump to end if less than 0 (stops at Sully_0, prevents Sully_-1).

#### Generate Source Filename
```asm
    lea rdi,[rel new_src_file]
    lea rsi,[rel src_format]
    mov edx,r12d
    xor eax,eax
    call sprintf
```
- `sprintf(new_src_file, "Sully_%d.s", r12d)`
- Result: `new_src_file` = "Sully_4.s" (for first iteration)

#### Generate Executable Filename
```asm
    lea rdi,[rel new_exec]
    lea rsi,[rel exec_format]
    mov edx,r12d
    xor eax,eax
    call sprintf
```
- `sprintf(new_exec, "Sully_%d", r12d)`
- Result: `new_exec` = "Sully_4"

#### Open File for Writing
```asm
    lea rdi,[rel new_src_file]
    lea rsi,[rel mode]
    call fopen
    test rax,rax
    jz .end
    mov r13,rax
```
- `fopen(new_src_file, "w")`
- Returns file pointer in `rax`.
- Check if NULL (file open failed), jump to end if so.
- Save file pointer in `r13`.

#### Write Source Code to File
```asm
    mov rdi,r13
    lea rsi,[rel tpl]
    mov edx,NEWLINE
    mov ecx,QUOTE
    mov r8d,r12d
    lea r9,[rel tpl]
    xor eax,eax
    call fprintf
```
- `fprintf(file, tpl, NEWLINE, QUOTE, r12d, tpl)`
- Arguments:
  - `rdi` = file pointer
  - `rsi` = format string (tpl)
  - `edx` = NEWLINE (for %1$c)
  - `ecx` = QUOTE (for %2$c)
  - `r8d` = counter value (for %3$d)
  - `r9` = address of tpl (for %4$s - the quine part)

Mapping inside `tpl`:
- `%1$c` → 10 → newline
- `%2$c` → 34 → quote
- `%3$d` → r12d → current counter value
- `%4$s` → tpl → the full format string (self-reproduction)

#### Close File
```asm
    mov rdi,r13
    call fclose
```

#### Compile the New Source
```asm
    lea rdi,[rel compile_cmd]
    lea rsi,[rel compile_format]
    lea rdx,[rel new_src_file]
    lea rcx,[rel new_exec]
    xor eax,eax
    call sprintf
    lea rdi,[rel compile_cmd]
    call system
```
- Build shell command: `nasm -f elf64 Sully_4.s -o Sully_4.o && gcc -no-pie Sully_4.o -o Sully_4 && rm Sully_4.o`
- Execute via `system()`

#### Run the New Executable
```asm
    lea rdi,[rel run_cmd]
    lea rsi,[rel run_format]
    lea rdx,[rel new_exec]
    xor eax,eax
    call sprintf
    lea rdi,[rel run_cmd]
    call system
```
- Build shell command: `./Sully_4`
- Execute via `system()` (which triggers the next iteration)

#### Cleanup and Return
```asm
.end:
    pop r13
    pop r12
    pop rbp
    xor rax,rax
    ret
```
- Restore saved registers.
- Set return value to 0.
- Return from main.

#### The Template String
```asm
section .rodata
tpl db "; ...",0
```
- Contains the entire program as a single format string.
- Uses `%%` to escape `%` in the output (so `%%define` becomes `%define`).
- `%1$c`, `%2$c`, `%3$d`, `%4$s`: Positional parameters for fprintf.
- The string reproduces itself via `%4$s` → `tpl`.

#### Security Section
```asm
section .note.GNU-stack noalloc noexec nowrite progbits
```
- Marks the stack as non-executable (security feature).

### Build and verify

**Assemble and link:**
```bash
nasm -f elf64 Sully.s -o Sully.o
gcc -no-pie Sully.o -o Sully
```

**Run:**
```bash
./Sully
```

**Count files (expect 13):**
```bash
ls -1 | grep Sully | wc -l
```

**Verify only counter changes:**
```bash
diff Sully.s Sully_0.s
# Expected: line 14 changes from "i dd 5" to "i dd 0"
```

**Detailed diff:**
```bash
diff -u Sully.s Sully_0.s
```

</details>

<br>

<details>
<summary><strong>Sources</strong></summary>

- [NASM Documentation](https://nasm.us/doc/)
- [x86-64 System V ABI](https://refspecs.linuxfoundation.org/elf/x86_64-abi-0.99.pdf)
- [Intel x86-64 Instruction Set Reference](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)

```bash
man nasm
```
