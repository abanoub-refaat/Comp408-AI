% finding the max and minimum without the cut
max_bad(X,Y,X):-
    X >= Y.

max_bad(X,Y,Y):-
    X < Y.

% using cut operator (otherwise)
max(X,Y,X):-
    X >= Y, !.
max(X, Y, Y).

% single-solution membership
member_once(X, [X | _]):- !.
member_once(X, [_ | Tail]) :-
    member_once(X, Tail).

% Adding an element wihout duplicates
add(X, L, L):-
    memeber_once(X, L), !.
add(X, L, [X | L]).

% Negation: (not or \+)
likes(mary, X):-
    snake(x), !, fail.
likes(mary, X):-
    animal(X).