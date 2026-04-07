% ex6.1
simplify(X + Y, E):-
    number(X),number(Y), !,
    E is X + Y.
simplify(X + Y, EX + EY):-
    simplify(X, EX),
    simplify(Y, EY).
simplify(X, X).

% ex6.2
add_to_tail(Item, [X | Tail]):-
    nonvar(X), !,
    add_to_tail(Item, Tail).
add_to_tail(Item, [Item | _]).

% ex6.4
copy_term(Term, Copy):-
    assert(temp_term(Term)),
    retract(temp_term(Copy)), !.

% ex6.5
subset([], []).
subset([X | Tail], [X | Sub]):-
    subset(Tail, Sub).
subset([_ | Tail], Sub):-
    subset(Tail, Sub).

powerset(Set, Subset):-
    bagof(Sub, subset(Set, Sub), Subsets).

% ex6.6
findterm(Term):-
    see(f),
    read_and_match(Term),
    seen.

read_and_match(Term):-
    read(X),
    (X == end_of_file -> fail;
    X = Term -> write(X), nl;
    read_and_match(Term)).

% Extra Questions on Chapter 6:

% 1) Write a Prolog predicate count_atoms(List, N) that counts only the atomic elements (atoms or numbers) in a list. For example:
%?- count_atoms([a, 3, foo(x), b, 2.5], N). % N = 4

count_atoms([], 0)
count_atoms([X | Tail], N):-
    atomic(X), !,
    count_atoms(Tail, N1),
    N is N1 + 1.
count([_ | Tail], N):-
    count_atoms(Tail, N).

% 2) Write a safe square predicate ot compute the square of a term only if its a numbr:

safe_square(X, S):-
    number(X), !,
    S is X * X.

% 3) Write a predicate memo_fib(N, F) that computes the Nth Fibonacci number and caches the result using asserta so repeated calls don't recompute. Assume :- dynamic cached_fib/2. is declared.

:- dynamic cached_fib/2.

memo_fib(0, 0):- !.
memo_fib(1, 1):- !.
memo_fib(N, F):-
    cached_fib(N, F), !.
memo_fib(N, F):-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    memo_fib(N1, F1),
    memo_fib(N2, F2),
    F is F1 + F2.
    asserta(cached_fib(N, F)).

% 4) Using the same score/2 facts above, write a predicate best_score(Person, Best) that finds the highest score achieved by a given person.

% given
score(alice, 85).
score(bob, 72).
score(alice, 90).
score(carol, 72).

best_score(Person, Best):-
    findall(S, socre(Person, S), Scores),
    max_list(Scores, Best). % standared library.
