# Chapter 6: Built-in Predicates

This chapter explores a variety of built-in predicates that extend Prolog's capabilities beyond pure logic programming, including term type testing, database manipulation, and input/output operations.

**Associated Lab File:** [labs/lab05/lab05.pl](../labs/lab05/lab05.pl)

---

## 6.1 Testing the Type of Terms

It is often necessary to check the type of a term before performing operations on it, such as guarding arithmetic expressions from uninstantiated variables.

### 6.1.1 Type Predicates

| Predicate     | Description                                                    |
| :------------ | :------------------------------------------------------------- |
| `var(X)`      | Succeeds if `X` is currently an uninstantiated variable.       |
| `nonvar(X)`   | Succeeds if `X` is not a variable, or is already instantiated. |
| `atom(X)`     | True if `X` stands for an atom.                                |
| `integer(X)`  | True if `X` stands for an integer.                             |
| `float(X)`    | True if `X` stands for a real number.                          |
| `number(X)`   | True if `X` is a number (integer or float).                    |
| `atomic(X)`   | True if `X` is an atom or a number.                            |
| `compound(X)` | True if `X` is a compound term (structure).                    |

### Example: Counting Occurrences

To count the number of "real" occurrences of an atom in a list (without instantiating variables that match the atom), use `atom/1`:

```prolog
count(_, [], 0).
count(A, [B | L], N) :-
    atom(B), A = B, !, % Only count if B is an atom and matches A
    count(A, L, N1),
    N is N1 + 1.
count(A, [_ | L], N) :-
    count(A, L, N).
```

### Application: Cryptarithmetic Puzzles

The `nonvar/1` predicate is useful in solving puzzles like `DONALD + GERALD = ROBERT`. It allows for an efficient digit-by-digit summation by checking if a digit is already instantiated before trying to assign a new one.

```prolog
% Using nonvar to avoid redundant instantiations
del_var(A, L, L) :-
    nonvar(A), !. % A is already instantiated
del_var(A, [A | L], L).
del_var(A, [B | L], [B | L1]) :-
    del_var(A, L, L1).
```

---

## 6.4 Database Manipulation

Prolog allows programs to modify themselves during execution by adding or removing clauses from the database.

### 6.4.1 Assert and Retract

- **`assert(C)`**: Adds clause `C` to the database (usually equivalent to `assertz`).
- **`asserta(C)`**: Adds clause `C` at the **beginning** of the database.
- **`assertz(C)`**: Adds clause `C` at the **end** of the database.
- **`retract(C)`**: Deletes a clause that matches `C`.

### Example: Simulating Robot Movement

```prolog
:- dynamic on/2.

move(X, Y, Z) :-
    retract(on(X, Y)), % Remove old state
    assert(on(X, Z)).  % Add new state
```

### Caching (Memoization)

Storing computed answers can speed up future queries:

```prolog
solve_and_cache(Problem, Solution) :-
    solve(Problem, Solution),
    asserta(solve(Problem, Solution)).
```

---

## 6.6 bagof, setof and findall

These predicates are used to collect all objects that satisfy a certain goal into a single list.

- **`bagof(X, P, L)`**: Collects all solutions `X` of goal `P` into list `L`. If `P` has variables not in `X`, it backtracks over them.
- **`setof(X, P, L)`**: Similar to `bagof`, but the list `L` is **sorted** and **duplicates are removed**.
- **`findall(X, P, L)`**: Collects all solutions `X` regardless of other variables in `P`. It is simpler and faster than `bagof`.

**Example Usage:**

```prolog
% Find all children in one list regardless of age
?- bagof(Child, Age ^ age(Child, Age), List).

% Find unique, sorted list of children
?- setof(Child, Age ^ age(Child, Age), ChildList).
```

---

## 6.7 Input and Output

### 6.7.1 Communication with Files

Prolog uses **input/output streams**. The default stream is `user` (keyboard and display).

- **`see(Filename)`**: Switches current input stream to `Filename`.
- **`tell(Filename)`**: Switches current output stream to `Filename`.
- **`seen`**: Closes the current input file and switches back to `user`.
- **`told`**: Closes the current output file and switches back to `user`.

### 6.7.2 Processing Files of Terms

Terms in a file must be followed by a **full stop** (`.`) and a space/newline.

- **`read(X)`**: Reads the next term from the input stream. Returns `end_of_file` at the end.
- **`write(X)`**: Outputs term `X` to the current output stream.
- **`tab(N)`**: Outputs `N` spaces.
- **`nl`**: Outputs a newline.

### 6.7.3 Processing Files of Characters

Files can also be treated as sequences of characters (ASCII codes).

- **`get0(C)`**: Reads the next character (including blanks).
- **`get(C)`**: Reads the next **non-blank** printable character.
- **`put(C)`**: Outputs the character with ASCII code `C`.

**Example: ASCII codes**

- `46` = `.`
- `32` = Space
- `65` = `A`
