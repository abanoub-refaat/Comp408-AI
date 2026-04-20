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
