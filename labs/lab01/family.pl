parent(pam, bob).
parent(tom, bob).
parent(tom, liz).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

female(pam).
female(liz).
female(pat).
femail(ann).

male(bob).
male(tom).
male(jim).

grandparent(X,Y) :- parent(X,Z), parent(Z, Y).

mother(X,Y) :-
    parent(X,Y),
    female(X).

father(x,Y) :-
    parent(X,Y),
    male(X).

sister(X, Y) :-
    parent(Z,X),
    parent(Z,Y),
    female(X),
    X \= Y.

ancestor(X,Y) :-
    parent(X,Y).
ancestor(X,Y) :-
    parent(X,Z),
    ancestor(Z, Y).

% same as the previous but from bottom to top.
% ancestor(x,Y) :-
%     parent(Z,Y),
%     ancestor(X,Z).