# Chapter 5: Exercises

This file contains exercises related to controlling backtracking using cuts and negation in Prolog.

---

## Exercise 5.1: Tracing the Cut

Consider the following program:

```prolog
p(1).
p(2) :- !.
p(3).
```

What will be Prolog's answers to the following questions?

(a) `?- p(X).`
(b) `?- p(X), p(Y).`
(c) `?- p(X), !, p(Y).`

**Solutions:**
(a) `X = 1 ; X = 2.` (Prolog stops after the cut in the second clause and never reaches `p(3)`).
(b) `X = 1, Y = 1 ; X = 1, Y = 2 ; X = 2, Y = 1 ; X = 2, Y = 2.`
(c) `X = 1, Y = 1 ; X = 1, Y = 2.` (The cut between `p(X)` and `p(Y)` freezes `X=1` and prevents backtracking to `X=2`).

---

## Exercise 5.2: Efficient Classification

The following relation classifies numbers into three classes: positive, zero, and negative:

```prolog
class(Number, positive) :- Number > 0.
class(0, zero).
class(Number, negative) :- Number < 0.
```

Define this procedure in a more efficient way using cuts.

**Solution:**

```prolog
class(0, zero) :- !.
class(Number, positive) :- Number > 0, !.
class(_, negative).
```

---

## Exercise 5.3: Splitting a List

Define the procedure `split(Numbers, Positives, Negatives)` which splits a list of numbers into two lists: positive ones (including zero) and negative ones.

**Example:**
`?- split([3, -1, 0, 5, -2], P, N).`
`P = [3, 0, 5], N = [-1, -2]`

**Solution (with cut):**

```prolog
split([], [], []).
split([X | Tail], [X | Pos], Neg) :-
    X >= 0, !,
    split(Tail, Pos, Neg).
split([X | Tail], Pos, [X | Neg]) :-
    split(Tail, Pos, Neg).
```

---

## Exercise 5.4: Items in Candidates not in RuledOut

Given two lists, `Candidates` and `RuledOut`, write a sequence of goals (using `member` and `not`) that will through backtracking find all the items in `Candidates` that are not in `RuledOut`.

**Solution:**

```prolog
?- member(X, Candidates), not(member(X, RuledOut)).
```

---

## Exercise 5.5: Set Subtraction

Define the set subtraction relation `set_difference(Set1, Set2, SetDifference)` where all three sets are represented as lists.

**Example:**
`?- set_difference([a,b,c,d], [b,d,e,f], [a,c]).`

**Solution:**

```prolog
set_difference([], _, []).
set_difference([X | Tail], Set2, Diff) :-
    member(X, Set2), !,
    set_difference(Tail, Set2, Diff).
set_difference([X | Tail], Set2, [X | Diff]) :-
    set_difference(Tail, Set2, Diff).
```

---

## Exercise 5.6: Unifiable Items

Define the predicate `unifiable(List1, Term, List2)` where `List2` is the list of all the members of `List1` that match `Term`, but are not instantiated by this matching.

**Hint:** Use `not(Term1 = Term2)`. If `Term1 = Term2` succeeds, then `not(Term1 = Term2)` fails and the resulting instantiation is undone.

**Solution:**

```prolog
unifiable([], _, []).
unifiable([X | Tail], Term, [X | List]) :-
    not(not(X = Term)), !, % Double negation checks if they match without binding
    unifiable(Tail, Term, List).
unifiable([_ | Tail], Term, List) :-
    unifiable(Tail, Term, List).
```
