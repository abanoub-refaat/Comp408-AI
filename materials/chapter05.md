# Chapter 5: Controlling Backtracking

This chapter introduces the **cut** facility (`!`), a powerful mechanism to prevent automatic backtracking. We will explore how it improves efficiency and enables the definition of negation in Prolog.

**Associated Lab File:** [labs/lab04/lab04.pl](../labs/lab04/lab04.pl) (Assuming standard structure)

---

## 5.1 Preventing Backtracking (The Cut)

Prolog's automatic backtracking is useful but can be inefficient if it explores alternatives that are guaranteed to fail. The **cut** (`!`) is a pseudo-goal that tells Prolog: "Do not backtrack beyond this point."

### 5.1.1 How the Cut Works

When a cut is encountered in a clause:

1. It succeeds immediately.
2. It **commits** the system to all choices made since the **parent goal** (the goal that matched the head of the current clause) was called.
3. All remaining alternative clauses for the parent goal and alternative solutions for goals preceding the cut are discarded.

**Syntax:**

```prolog
H :- B1, B2, ..., Bm, !, ..., Bn.
```

If `H` matches a goal `G`, then `G` is the parent goal. Once `!` is reached, Prolog is committed to this specific clause for `G` and the current solutions of `B1...Bm`.

### 5.1.2 Green vs. Red Cuts

- **Green Cuts:** Only improve efficiency. Removing them does not change the declarative meaning (the results) of the program, only how long it takes to run.
- **Red Cuts:** Affect the declarative meaning. Removing them changes the results of the program. These should be used with extreme care.

---

## 5.2 Examples of Using Cut

### 5.2.1 Computing Maximum (Mutually Exclusive Rules)

Without cut, both rules might be checked even if the first succeeds:

```prolog
max(X, Y, X) :- X >= Y.
max(X, Y, Y) :- X < Y.
```

With cut (more efficient):

```prolog
max(X, Y, X) :- X >= Y, !.
max(X, Y, Y).
```

### 5.2.2 Single-Solution Membership

A deterministic version of `member/2` that stops after the first match:

```prolog
member_once(X, [X | _]) :- !.
member_once(X, [_ | Tail]) :- member_once(X, Tail).
```

### 5.2.3 Adding without Duplicates

Add `X` to list `L` only if `X` is not already a member:

```prolog
add(X, L, L) :- member(X, L), !.
add(X, L, [X | L]).
```

---

## 5.3 Negation as Failure

Prolog uses **Negation as Failure** (`not` or `\+`). A goal `not(P)` succeeds if the goal `P` fails.

### 5.3.1 Defining Negation with Cut and Fail

We can define "Mary likes all animals but snakes":

```prolog
likes(mary, X) :-
    snake(X), !, fail. % If it's a snake, stop and fail
likes(mary, X) :-
    animal(X).         % Otherwise, check if it's an animal
```

### 5.3.2 The `not` Predicate

The general definition of `not(P)` is:

```prolog
not(P) :-
    P, !, fail.
not(P) :-
    true.
```

---

## 5.4 Closed World Assumption (CWA)

Prolog's negation is based on the **Closed World Assumption**:

> Everything that is not stated in the program (or cannot be proven from it) is assumed to be false.

### 5.4.1 Problems with Negation

1. **Not True Logic:** `not round(earth)` returning `yes` doesn't mean it's proven false; it means it's not provable from the current facts.
2. **Variable Quantification:** `not Goal` works safely only if variables are **instantiated** when called.
   - `?- good_standard(X), reasonable(X).` -> Finds Francesco.
   - `?- reasonable(X), good_standard(X).` -> Might fail because `not expensive(X)` is interpreted as "Is it true that _no_ restaurant is expensive?" (Universal quantification).

---

## Summary of Key Concepts

- **`!` (Cut):** Prevents backtracking.
- **`fail`:** A goal that always fails, forcing backtracking.
- **`true`:** A goal that always succeeds.
- **`\+` (Negation):** Succeeds if its argument fails.
- **Parent Goal:** The goal that invoked the clause containing the cut.
- **CWA:** The assumption that the program contains all true facts about its world.
