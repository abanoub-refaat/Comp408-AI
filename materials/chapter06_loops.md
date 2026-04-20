# Chapter 6: Loops

This chapter summary is based on "Logic Programming With Prolog". It explores how to simulate looping structures in Prolog using recursion and the built-in `repeat` predicate.

**Associated Lab File:** [labs/lab06/lab06.pl](../labs/lab06/lab06.pl)

---

## 6.1 Looping a Fixed Number of Times

Prolog does not have a native `for` loop, but similar effects are achieved using **recursion**.

### Basic Recursive Loop
To execute a task $N$ times, we define a predicate that calls itself with a decremented value until a base case (terminating condition) is reached.

```prolog
loop(0).
loop(N) :-
    N > 0,
    write('The value is: '), write(N), nl,
    M is N - 1,
    loop(M).
```

**Key Points:**
- **Terminating Condition:** `loop(0).` ensures the recursion stops.
- **Decrementing:** Use `M is N - 1` before the recursive call. `loop(N-1)` will NOT work because `N-1` is treated as a term, not a calculation.

### Summation and Accumulation
Recursion can be used to calculate sums or other cumulative values by breaking the problem into a base case and a general recursive step.

```prolog
/* Sum of integers from 1 to N */
sumto(1, 1).
sumto(N, S) :-
    N > 1,
    N1 is N - 1,
    sumto(N1, S1),
    S is S1 + N.
```

---

## 6.2 Looping Until a Condition Is Satisfied

### 6.2.1 Using Recursion
You can loop until a specific input or state is reached by passing the current state as a variable to the recursive call.

```prolog
loop(end).
loop(X) :-
    X \= end,
    read(Word),
    loop(Word).
```

### 6.2.2 Using the `repeat` Predicate
The `repeat` predicate is a built-in tool that always succeeds. Its primary power comes from the fact that it **always succeeds on backtracking**, creating an infinite source of choice points.

**How it works:**
1. Evaluation proceeds left-to-right.
2. If a goal to the right of `repeat` fails, Prolog backtracks to `repeat`.
3. `repeat` succeeds again, and execution moves forward again.
4. This continues until the final condition in the sequence succeeds.

```prolog
get_answer(Ans) :-
    repeat,
    write('Enter yes or no: '),
    read(Ans),
    valid(Ans). % The loop "ends" when valid(Ans) succeeds.
```

---

## 6.3 Menu Structures

Loops are commonly used to create interactive menus. The structure usually involves a `menu` predicate that displays options, reads a choice, and then calls a `choice` predicate which may recursively call `menu` again.

```prolog
menu :-
    display_options,
    read(Choice),
    process(Choice).

process(exit) :- write('Goodbye'), nl.
process(C) :- do_task(C), menu. % Recursive call to restart the menu
```

---

### Important Terminology

- **Recursion:** A process where a predicate is defined in terms of itself.
- **Base Case:** The terminating condition for recursion that prevents infinite loops.
- **repeat/0:** A built-in predicate that provides an infinite number of choice points for backtracking.
- **Disjunction (;):** Can be used to create simple "if-else" or "loop-if-fail" logic within a single clause.
- **Backtracking Loop:** A technique using `repeat` and `fail` (or a condition that fails until satisfied) to re-execute a sequence of goals.
