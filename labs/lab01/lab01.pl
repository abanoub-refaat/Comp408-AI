% NOTE: check materials/chapter01.md for explainations and examples.
% For diagrams check /diagrms.

% figure (1.1)

% defining the parent relation
parent(tom, bob).
parent(tom, liz).
parent(pam, bob).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

% adding info about the gender of each person in the figure (ladies first)
female(pam).
female(liz).
female(pat).
female(ann).

male(tom).
male(bob).
male(jim).

% introducting the mother relation
% mother(pam,bob).
% mother(pat,jim).

% defining the GENERAL mother using the if clause
mother(X,Y) :- 
    parent(X,Y),
    female(X).

% defining the grandparent relation
grandparent(X,Z) :- 
    parent(X,Y), 
    parent(Y,Z).

% defining the sister and brother relations
sister(Y,Z) :-
    parent(X,Y), 
    parent(X, Z),
    female(Y),
    Y \= Z.

brother(Y,Z) :-
    parent(X, Y),
    parent(X, Z),
    male(Y).
    Y \= Z.

% unary relation `haschild()`
haschild(X) :-
    parent(X, Y).

% defining the ancestor relation
% we have a direct ancestor relation
ancestor(X, Z) :-
    parent(X, Z).
% and the inderct ancestro rlation using recursive relations
ancestor(X, Z) :-
    parent(X, Y),
    ancestor(Y, Z).