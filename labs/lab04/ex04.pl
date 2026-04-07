p(1).
p(2):- !.
p(3).

class(0, zero) :- !.
class(Number, positive) :- Number > 0, !.
class(_, negative).

% defining the split procedure

% base case:
split([],[],[]).
split([X | Tail],[X | P],N):-
    X >= 0, !,
    split(Tail, P, N).
split([X | Tail], P, [X | N]):-
    split(Tail, P, N).

% set subtraction procedure
set_difference([], _, []).
set_difference([X | Tail], Set2, Diff):-
    member_once(X, Set2), !,
    set_difference(Tail, Set2, Diff).
set_difference([X|Tail], Set2, [X | Diff]):-
    set_difference(Tail, Set2, Diff).