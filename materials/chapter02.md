# Chapter 2: Syntax and Meaning of Prolog Programs

This chapter introduces the syntax of Prolog programs and the declarative and procedural meanings of programs.

**Associated Lab:** [Lab 2 Code](../labs/lab02/lab02.pl)
**Associated Exercises:** [Exercises 2](./exercises02.md)

---

## 2.1 Data Objects

Prolog's data objects are divided into **simple objects** (constants and variables) and **structures**.

### 2.1.1 Constants

Constants represent fixed values.

- **Atoms:**
  - Strings of letters, digits, and `_` starting with a lowercase letter (e.g., `anna`, `x25`).
  - Strings of special characters (e.g., `:-`, `*->`).
  - Strings enclosed in single quotes (e.g., `'Tom'`, `'New_York'`).
- **Numbers:**
  - **Integers:** `1`, `0`, `-5`.
  - **Real Numbers:** `3.14`, `-0.005`, `1.2E6`.

### 2.1.2 Variables

Variables are placeholders for values that are not yet known.

- Represented by strings starting with an uppercase letter or `_` (e.g., `X`, `Result`, `_person`).
- **Anonymous Variable (`_`):** Used when a variable's value is not important. Each `_` is a distinct variable.
  ```prolog
  % Is there a parent?
  ?- parent(_, _).
  ```

### 2.1.3 Structures

Structures are objects with several components, defined by a **functor** and its **arguments**.

- **Syntax:** `functor(argument1, argument2, ...)`
- **Example:** `date(2024, 7, 26)` has the functor `date` and arity 3.
- Structures can be nested to represent complex data:
  ```prolog
  seg(point(1,1), point(2,3))
  ```

---

## 2.2 Matching

Matching is Prolog's way of comparing and unifying terms. It is triggered by the `=` operator.

**Rules for Matching:**

1.  **Constants:** Two constants match only if they are identical.

    ```prolog
    ?- anna = anna.
    true.

    ?- anna = 'anna'.
    true.

    ?- anna = louis.
    false.
    ```

2.  **Variables:** An uninstantiated variable matches any term and becomes instantiated to that term.
    ```prolog
    ?- X = anna.
    X = anna.
    ```
3.  **Structures:** Two structures match if they have the same functor and arity, and all their corresponding arguments match.
    ```prolog
    ?- date(D, M, 2001) = date(D1, may, Y1).
    D = D1,
    M = may,
    Y1 = 2001.
    ```

---

## 2.3 Declarative vs. Procedural Meaning

- **Declarative Meaning:** Describes _what_ the program computes. It defines relationships and facts.
- **Procedural Meaning:** Describes _how_ the program computes its results, including the order of execution.

---

## 2.4 Procedural Meaning of Programs

Prolog executes a query by searching for clauses that match the goals in the query.

### Example Execution

Consider the following program from `lab02.pl`:

```prolog
big(bear).
big(elephant).
small(cat).
brown(bear).
black(cat).
gray(elephant).

dark(Z) :-
    black(Z).

dark(Z) :-
    brown(Z).
```

Let's trace the execution of the query `?- dark(X), big(X)`.

1. **Initial Goal:** `dark(X), big(X)`.
2. **Match `dark(X)`:** Prolog finds `dark(Z) :- black(Z).`.
   - `X` is unified with `Z`.
   - The goal becomes `black(X), big(X)`.
3. **Match `black(X)`:** Prolog finds the fact `black(cat).`.
   - `X` is instantiated to `cat`.
   - The goal becomes `big(cat)`.
4. **Match `big(cat)`:** Prolog searches for `big(cat)` but finds no matching fact or rule. The goal fails.
5. **Backtrack:** Prolog returns to the last choice point (step 2) and looks for another match for `dark(X)`.
6. **Second Match for `dark(X)`:** Prolog finds `dark(Z) :- brown(Z).`.
   - `X` is unified with `Z`.
   - The goal becomes `brown(X), big(X)`.
7. **Match `brown(X)`:** Prolog finds the fact `brown(bear).`.
   - `X` is instantiated to `bear`.
   - The goal becomes `big(bear)`.
8. **Match `big(bear)`:** Prolog finds the fact `big(bear).`. The goal succeeds.
9. **Success:** The query is satisfied, and Prolog returns the instantiation `X = bear.`.

---

## 2.5 Order of Clauses and Goals

The order of clauses and goals in a Prolog program does not affect its declarative meaning but can have a significant impact on its procedural behavior and efficiency.

### Example: `ancestor` relation

Consider the `ancestor` predicate:

**Version 1:**

```prolog
ancestor(Parent, Child) :-
    parent(Parent, Child).
ancestor(Ancestor, Successor) :-
    parent(Ancestor, Child),
    ancestor(Child, Successor).
```

**Version 2 (swapped goals):**

```prolog
ancestor(Parent, Child) :-
    parent(Parent, Child).
ancestor(Ancestor, Successor) :-
    ancestor(Child, Successor),
    parent(Ancestor, Child).
```

While both versions are declaratively correct, Version 2 can lead to infinite recursion if not handled carefully, as the recursive call `ancestor(Child, Successor)` is the first goal in the body.

---

## Summary of Key Concepts

- **Data Objects:** Atoms, numbers, variables, and structures.
- **Term:** A constant, variable, or structure.
- **Functor & Arity:** The name and number of arguments of a structure.
- **Matching:** The process of unifying two terms.
- **Declarative Semantics:** What the program declares to be true.
- **Procedural Semantics:** How the program arrives at an answer.
- **Backtracking:** Prolog's mechanism for exploring alternative solutions.
- **Order of Clauses/Goals:** Affects efficiency and can lead to infinite loops if not ordered correctly.
