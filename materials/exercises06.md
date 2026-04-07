# Chapter 6: Exercises

This file contains exercises related to built-in predicates for term type testing, database manipulation, and collection of solutions.

---

## Exercise 6.1: Guarding Arithmetic

Write a procedure `simplify(Expression, Simplified)` to symbolically simplify summation expressions with numbers and symbols (lower-case letters).

**Solution (Conceptual):**

```prolog
simplify(X + Y, E) :-
    number(X), number(Y), !,
    E is X + Y.
simplify(X + Y, EX + EY) :-
    simplify(X, EX),
    simplify(Y, EY).
simplify(X, X).
```

---

## Exercise 6.2: Growing Lists (Add to Tail)

Define the procedure `add_to_tail(Item, List)` to store a new element into a list. Assume the list ends with an uninstantiated tail.

**Solution:**

```prolog
add_to_tail(Item, [X | Tail]) :-
    nonvar(X), !,
    add_to_tail(Item, Tail).
add_to_tail(Item, [Item | _]).
```

---

## Exercise 6.3: Database Manipulation

(a) Write a Prolog question to remove the whole `product` table from the database.
(b) Modify the question so that it only removes those entries where the product is 0.

**Solutions:**
(a) `?- retract(product(_, _, _)), fail.`
(b) `?- retract(product(_, _, 0)), fail.`

---

## Exercise 6.4: Copying Terms

Define the relation `copy_term(Term, Copy)` which produces a copy of `Term` with all variables renamed, using `assert` and `retract`.

**Solution:**

```prolog
copy_term(Term, Copy) :-
    asserta(temp_term(Term)),
    retract(temp_term(Copy)), !.
```

---

## Exercise 6.5: Powerset with bagof

Use `bagof` to define the relation `powerset(Set, Subsets)` to compute the set of all subsets of a given set.

**Solution:**

```prolog
% subset/2 generates subsets through backtracking
subset([], []).
subset([X | Tail], [X | Sub]) :- subset(Tail, Sub).
subset([_ | Tail], Sub) :- subset(Tail, Sub).

powerset(Set, Subsets) :-
    bagof(Sub, subset(Set, Sub), Subsets).
```

---

## Exercise 6.6: Processing Files of Terms

Let `f` be a file of terms. Define `findterm(Term)` that displays the first term in `f` that matches `Term`.

**Solution:**

```prolog
findterm(Term) :-
    see(f),
    read_and_match(Term),
    seen.

read_and_match(Term) :-
    read(X),
    (X == end_of_file -> fail
    ; X = Term -> write(X), nl
    ; read_and_match(Term)).
```

---

## Extra Questions

---

### Exercise 6.7: Predicting Type Predicate Behaviour

State whether each of the following queries succeeds or fails, and explain why.

(a) `?- var(X).`
(b) `?- var(hello).`
(c) `?- atom(3.14).`
(d) `?- number(42).`
(e) `?- atomic(foo(a)).`
(f) `?- compound(foo(a)).`

**Solution:**

(a) **succeeds** — `X` is uninstantiated, so `var/1` holds.
(b) **fails** — `hello` is an atom, not a variable.
(c) **fails** — `3.14` is a float; `atom/1` requires an atom, not a number.
(d) **succeeds** — `42` is an integer, and `number/1` is true for both integers and floats.
(e) **fails** — `foo(a)` is a compound term; `atomic/1` only holds for atoms and numbers.
(f) **succeeds** — `foo(a)` is a structure, so `compound/1` holds.

---

### Exercise 6.8: Counting Atomic Elements

Write a procedure `count_atoms(List, N)` that counts only the atomic elements (atoms or numbers) in a list, ignoring compound terms and uninstantiated variables. For example:

```prolog
?- count_atoms([a, 3, foo(x), b, 2.5], N).
N = 4.
```

**Solution:**

```prolog
count_atoms([], 0).
count_atoms([H | T], N) :-
    atomic(H), !,
    count_atoms(T, N1),
    N is N1 + 1.
count_atoms([_ | T], N) :-
    count_atoms(T, N).
```

---

### Exercise 6.9: Safe Arithmetic Guard

The following predicate is intended to compute the square of a term, but crashes when `X` is uninstantiated or non-numeric. Identify the bug and fix it.

```prolog
safe_square(X, S) :-
    S is X * X.
```

**Solution:**

The bug is that `is/2` throws an instantiation or type error if `X` is not a number. Fix by guarding with `number/1`:

```prolog
safe_square(X, S) :-
    number(X),
    S is X * X.
```

---

### Exercise 6.10: Tracing assert and retract

Given the following session, what does the final query return?

```prolog
:- dynamic fact/1.

?- assertz(fact(1)).
?- assertz(fact(2)).
?- asserta(fact(0)).
?- retract(fact(2)).
?- findall(X, fact(X), L).
```

**Solution:**

`L = [0, 1]`

After `assertz(fact(1))` and `assertz(fact(2))` the database contains: `fact(1), fact(2)`. After `asserta(fact(0))`: `fact(0), fact(1), fact(2)`. After `retract(fact(2))`: `fact(0), fact(1)`. `findall` collects them in database order.

---

### Exercise 6.11: Memoisation with assert

Write a predicate `memo_fib(N, F)` that computes the Nth Fibonacci number and caches each result using `asserta` so that repeated calls do not recompute it. Assume `:- dynamic cached_fib/2.` is declared.

**Solution:**

```prolog
:- dynamic cached_fib/2.

memo_fib(0, 0) :- !.
memo_fib(1, 1) :- !.
memo_fib(N, F) :-
    cached_fib(N, F), !.         % return cached result if available
memo_fib(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    memo_fib(N1, F1),
    memo_fib(N2, F2),
    F is F1 + F2,
    asserta(cached_fib(N, F)).   % store before returning
```

---

### Exercise 6.12: bagof vs setof vs findall

Given the following facts:

```prolog
score(alice, 85).
score(bob, 72).
score(alice, 90).
score(carol, 72).
```

State what each query returns:

(a) `?- findall(S, score(alice, S), L).`
(b) `?- setof(S, P^score(P, S), L).`
(c) `?- bagof(P, S^score(P, S), L).`

**Solution:**

(a) `L = [85, 90]` — all scores for `alice` in database order.

(b) `L = [72, 85, 90]` — all scores across all persons, sorted and deduplicated. `P^` existentially quantifies `P` so `setof` does not group by person.

(c) `L = [alice, bob, alice, carol]` — all persons in database order, with duplicates, since `S^` existentially quantifies `S`.

---

### Exercise 6.13: Finding the Best Score

Using the same `score/2` facts from Exercise 6.12, write a predicate `best_score(Person, Best)` that finds the highest score achieved by a given person.

**Solution:**

```prolog
best_score(Person, Best) :-
    findall(S, score(Person, S), Scores),
    max_list(Scores, Best).
```

`findall` collects all scores for the given person into a list, then the standard `max_list/2` predicate returns the largest value.

---

### Exercise 6.14: get0 vs get

What is the difference between `get0(C)` and `get(C)`? Give an example of a situation where you would prefer each one.

**Solution:**

- `get0(C)` reads the **next character** from the input stream, including spaces, tabs, and newlines (returns its ASCII code).
- `get(C)` skips all whitespace and reads the next **printable non-blank** character.

Use `get0` when whitespace is meaningful — for example, parsing a CSV or fixed-width file where spaces are part of the data. Use `get` when you want to skip whitespace between tokens, such as reading a sequence of words or identifiers separated by spaces.

---

### Exercise 6.15: Reading All Terms from a File

Write a predicate `read_all_terms(File, Terms)` that opens a file, reads all Prolog terms from it into a list, and then closes the file. Assume the file contains valid Prolog terms each followed by a full stop.

**Solution:**

```prolog
read_all_terms(File, Terms) :-
    see(File),
    read_terms_loop(Terms),
    seen.

read_terms_loop([]) :-
    read(T),
    T = end_of_file, !.
read_terms_loop([T | Rest]) :-
    read(T),
    T \= end_of_file,
    read_terms_loop(Rest).
```

`see/1` switches the input stream to the file. `read/1` reads one term at a time and unifies it with `end_of_file` when the file is exhausted. `seen` closes the stream and restores input to `user`.

---

### Exercise 6.16: Saving Facts to a File

Write a predicate `save_facts(File, Predicate)` that retrieves all clauses matching `Predicate` from the database using `findall`, then writes each one to a file (one per line with a full stop) so the file can be reloaded later.

**Solution:**

```prolog
save_facts(File, Predicate) :-
    functor(Predicate, Name, Arity),
    functor(Template, Name, Arity),
    findall(Template, call(Template), Facts),
    tell(File),
    write_facts(Facts),
    told.

write_facts([]).
write_facts([F | Rest]) :-
    write(F), write('.'), nl,
    write_facts(Rest).
```

`functor/3` is used to build a fresh template with the same name and arity as the given predicate. `findall` combined with `call` collects all matching facts. `tell/1` redirects output to the file, and `told` closes it and restores output to `user`.
