% ex3.2  and for more explaination check /materials/exercises03.md
% (a) last relation using conc
last(Item, List):-
    conc(_, [Item], List).


% (b) last relation withour using conc
% using recursion, the base case is the list having one element.
last(Item, [Item]).

% recursive step
last(Item, [_ | Tail]):-
    last(Item, Tail).

% ex3.3 evenlength() and oddlength():
% base case:
evenlength([]).
oddlength([_]).

% recursive step: skip two elements and check the list.
evenlength([_, _ | Tail]):-
    evenlength(Tail).

oddlength([_, _ | Tail]):-
    oddlength(Tail).

% ex3.4 reversing a list without using the conc - using recursion:
% base case: the list is empty.
add_last(X, [], [X]).

% the list is not empty:
add_last(X, [H | T], [H, NewTail]):-
    add_last(X, T, NewTail).

% ex3.5 palindrome check:
% base case: empty list, and one-element list are palindrome:
palindrome([]).
palindrome([_]).

% recursive step:
palindrome([X | Tail]):-
    conc(Middle, [X], Tail),
    palindrome(Middle).

% ex3.6 rotational shift
shift([Head | Tail], List2):-
    conc(Tail, [Head], List2).

% ex3.7 number of word translation
mean(0, zero).
mean(1, one).
mean(2, two).
mean(3, three).
mean(4, four).
mean(5, five).
mean(6, six).
mean(7, seven).
mean(8, eight).
mean(9, nine).

% base case:
translate([], []).
translate([N | RestN], [W | RestW]):-
    mean(N, W),
    translate(RestN, RestW).

% ex3.12 Understanding Operator Terms
:- op(300, xfx, plays).
:- op(200, xfy, and).

% ex3.13 Suggest an appropriate definition of operators ('was', 'of', 'the')
:- op(600, xfx, was).
:- op(500, xfy, of).
:- op(400, fx, the).

% ex3.14 Tracing infix operators
t(0+1, 1+0).
t(X+0+1, X+1+0).
t(X+1+1, Z) :-
    t(X+1, X1),
    t(X1+1, Z).

% ex3.15 Define 'in', 'concatenating', 'and', etc. as operators
:- op(600, xfx, in).
:- op(600, xfx, gives).
:- op(500, xfy, concatenating).
:- op(500, xfy, and).
:- op(500, xfx, from).
:- op(400, fx, deleting).

% Redefined procedures for ex 3.15
Item in List :- member(Item, List).

concatenating L1 and L2 gives L3 :-
    conc(L1, L2, L3).

deleting X from L gives L1 :-
    del(X, L, L1).

% ex3.16 Maximum of two numbers
max(X, Y, X) :- X >= Y.
max(X, Y, Y) :- X < Y.

% ex3.17 Maximum of a list
maxlist([X], X).
maxlist([X | Tail], Max) :-
    maxlist(Tail, MaxTail),
    max(X, MaxTail, Max).

% ex3.18 Sum of a list
sumlist([], 0).
sumlist([X | Tail], Sum) :-
    sumlist(Tail, SumTail),
    Sum is X + SumTail.

% ex3.19 Ordered list
ordered([]).
ordered([_]).
ordered([X, Y | Tail]) :-
    X =< Y,
    ordered([Y | Tail]).

% ex3.20 Subset sum
subsum([], 0, []).
subsum([X | Tail], Sum, [X | SubTail]) :-
    Sum1 is Sum - X,
    subsum(Tail, Sum1, SubTail).
subsum([_ | Tail], Sum, SubSet) :-
    subsum(Tail, Sum, SubSet).

% ex3.21 Range generation
between(N, N, N).
between(N1, N2, N1) :- N1 < N2.
between(N1, N2, X) :-
    N1 < N2,
    Next is N1 + 1,
    between(Next, N2, X).

% ex3.22 If-then-else interpreter
:- op(900, fx, if).
:- op(800, xfx, then).
:- op(700, xfx, else).
:- op(600, xfx, :=).

if Val1 > Val2 then Var := Val3 else _Var := Val4 :-
    Val1 > Val2, !, Var is Val3.
if _Val1 > _Val2 then _Var := _Val3 else Var := Val4 :-
    Var is Val4.


% EXTRA Examples:
% 1.a) add_last relation using conc:
add_last_conc(X, List, NewList):-
    conc(List, [X], NewList).

% 1.b) without using the conc - using recursion:
% (This was already defined above as add_last, but renamed for clarity in extra section)
add_last_rec(X, [], [X]).
add_last_rec(X, [H | T], [H | NewTail]):-
    add_last_rec(X, T, NewTail).

% 2.a) reversing a list without an accumulator.
% base case: the list is empty.
reverse_simple([], []).

% recursive step:
reverse_simple([X | Tail], Reversed):-
    reverse_simple(Tail, RevTail),
    conc(RevTail, [X], Reversed).

% 2.b) reversing a list using accumulator:
reverse_fast(List, Reversed):-
    reverse_acc(List, [], Reversed).

% base case: staring with an empty list
reverse_acc([], Acc, Acc).

% recursive step:
reverse_acc([X | Tail], Acc, Reversed):-
    reverse_acc(Tail, [X | Acc], Reversed).

% ex3.5 palindrome check - using the reverse_fast relation
palindrome_fast(L):-
    reverse_fast(L, L).

% 3. defining evenlength and oddlength in terms of each other:
% base case: A list is even if it's empty.
evenlength_mutual([]).

% A list is even if it has one element followed by an ODD tail.
evenlength_mutual([_|Tail]):-
    oddlength_mutual(Tail).

% A list is odd if it has one element followed by an EVEN tail.
oddlength_mutual([_|Tail]):-
    evenlength_mutual(Tail).
