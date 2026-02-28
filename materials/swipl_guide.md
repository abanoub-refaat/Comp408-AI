# SWI-Prolog Installation and Usage Guide

This guide provides instructions on how to install SWI-Prolog and run Prolog applications, along with some common commands.

---

## 1. Installation

### Windows (WTH uses windows in 2026? switch to linux bro)

1. Visit the official [SWI-Prolog website](https://www.swi-prolog.org/).
2. Navigate to the download section and select the stable release for Microsoft Windows (64-bit is generally recommended).
3. Download the executable file (e.g., `swipl-8.4.0-1.x64.exe`).
4. Run the installer. During the installation, ensure you check the option to "Add swipl to the system path for all users" to enable command-line access.
5. Complete the installation.

### Linux (Debian/Ubuntu based systems)

1. Add the SWI-Prolog stable PPA to your system's software sources by opening a terminal and running:

   ```bash
   sudo add-apt-repository ppa:swi-prolog/stable
   sudo apt-get update
   ```

2. Install SWI-Prolog using your package manager:

   ```bash
   sudo apt-get install swi-prolog
   ```

### Verifying Installation

After installation, open a new terminal or command prompt and type `swipl`. You should see the SWI-Prolog interpreter prompt `?-`.

```prolog
?-
```

---

## 2. Running Prolog Applications

Once SWI-Prolog is installed, you can run Prolog applications in several ways.

### a. Starting the Interpreter and Loading a File

1. Save your Prolog code in a file with a `.pl` extension (e.g., `my_program.pl`).
2. Open your terminal or command prompt and navigate to the directory where you saved your Prolog file.
3. Start the SWI-Prolog interpreter by typing `swipl`.
4. At the `?-` prompt, load your program by typing `[my_program].` (including the period) and pressing Enter. The `.pl` extension is usually optional.

   ```prolog
   ?- [my_program].
   ```

5. You can then query predicates defined in your loaded program. For example, if you have a predicate `my_predicate(X).`, you can type `?- my_predicate(X).` to run it.
6. To exit the interpreter, type `halt.` and press Enter.

### b. Running a Prolog File Directly from the Command Line

You can load and execute a Prolog file directly when starting SWI-Prolog using the `-s` (script) option:

```bash
swipl -s my_program.pl
```

This will load `my_program.pl` and then present the `?-` prompt.

---

## 3. Common SWI-Prolog Commands

Here are some common commands you can use within the SWI-Prolog interpreter:

- `[filename].`: Consults (loads) a Prolog file.
- `halt.`: Exits the SWI-Prolog interpreter.
- `?- predicate(Args).`: A query to execute a predicate.
- `;`: After a query returns a result, type `;` and press Enter to find the next solution.
- `a.`: Aborts the current query and returns to the prompt.
- `listing.`: Lists all clauses in the current program.
- `listing(predicate_name).`: Lists clauses for a specific predicate.
- `trace.`: Turns on the debugger.
- `notrace.`: Turns off the debugger.
- `help(predicate_name).`: Provides help on a specific built-in predicate.
- `edit(file).`: Opens `file` in the default editor (if configured).
- `make.`: Reloads all modified source files.

---
