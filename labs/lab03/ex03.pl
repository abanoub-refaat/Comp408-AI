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
translate([N, RestN], [W | RestW]):-
    mean(N, W),
    translate(RestN, RestW).




% EXTRA Examples:
% 1.a) add_last relation using conc:
add_last(X, List, NewList):-
    conc(List, [X], NewList).

% 1.b) without using the conc - using recursion:
% base case: the list is empty.
add_last(X, [], [X]).

% the list is not empty:
add_last(X, [H | T], [H, NewTail]):-
    add_last(X, T, NewTail).

% 2.a) reversing a list without an accumulator.
% base case: the list is empty.
reverse([], []).

% recursive step:
reverse([X | Tail], Reversed):-
    reverse(Tail, RevTail),
    conc(RevTail, [X], Reversed).

% 2.b) reversing a list using accumulator:
reverse_fast(List, Reversed):-
    reverse_acc(List, [], Reversed).

% base case: staring with an empty list
reverse_acc([], Acc, Acc).

% recursive step:
reverse_acc([X | Tail], Acc, Reversed):-
    reverse_acc(Tail, [x | Acc], Reversed).

% ex3.5 palindrome check - using the reverse_fast relation
palindrome(L):-
    reverse_fast(L, L).

% 3. defining evenlength and oddlength in terms of each other:
% base case: A list is even if it's empty.
evenlength([]).

% A list is even if it has one element followed by an ODD tail.
evenlength([_, Tail]):-
    oddlength(Tail).

% A list is odd if it has one element followed by an EVEN tail.
oddlength([_, Tail]):-
    evenlength(Tail).