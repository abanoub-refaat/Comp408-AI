# Chapter 6: Exercises - Loops

These exercises focus on implementing looping behavior in Prolog using recursion and the `repeat` predicate.

**Solutions File:** [labs/lab06/ex06.pl](../labs/lab06/ex06.pl)

---

## Exercise 6.1: Countdown

Define a predicate `countdown(N)` that prints the numbers from `N` down to `0`.

---

## Exercise 6.2: Countup

Define a predicate `countup(Low, High)` that prints the numbers from `Low` up to `High` inclusive.

---

## Exercise 6.3: Factorial

Define a recursive predicate `factorial(N, F)` that calculates the factorial of `N` and unifies it with `F`.
*Recall: $0! = 1$ and $N! = N \times (N-1)!$*

---

## Exercise 6.4: Interactive Reader

Write a predicate `read_until_stop` that repeatedly prompts the user to enter a term using `read(Term)`. The loop should print "You entered: [Term]" and only stop when the user enters the atom `stop`. Use the `repeat` predicate for this exercise.

---

## Exercise 6.5: Simple Calculator Loop

Create a predicate `calc` that repeatedly asks the user for two numbers and prints their sum. The loop should terminate if the user enters `0` for the first number.

- **Hint:** Use `repeat` and a condition to exit.

---

## Exercise 6.6: Multiplication Table (Intermediate)

Define a predicate `multi_table(N)` that prints the multiplication table for `N` from 1 to 10.
*Example output for `multi_table(5)`:*
```text
5 x 1 = 5
5 x 2 = 10
...
5 x 10 = 50
```

---

## Exercise 6.7: Interactive Average (Advanced)

Write a predicate `average_loop` that:
1. Prompts the user to enter numbers one by one.
2. Stops when the user enters the atom `end`.
3. Calculates and prints the average of all entered numbers.
4. Handles empty lists gracefully (if the user enters `end` immediately).

- **Topics covered:** Recursion, I/O, Arithmetic, Lists.
