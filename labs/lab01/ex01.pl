% ex1.3 (a)
happy(X) :- 
    haschild(X).

% ex1.3 (b)
hastwochildren(X) :-
    parent(X, Y),
    sister(Y, Z).

% ex1.4
grandchild(Z, X) :-
    parent(Y, Z),
    parent(X, Y).

% ex1.5
aunt(X, Y) :-
    parent(Z, Y),
    sister(X, Z).