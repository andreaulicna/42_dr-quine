# 42_dr-quine

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