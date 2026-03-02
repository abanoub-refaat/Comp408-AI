% for chapter explaination check /materials/chapter03.md

% the old way of defining a list
% .(a, .(b, .(c, []))). % = [a, b, c]

% defining a list in prolog
example_list([ann, tennis, tom, skiing]).      % the head is `ann` and the tail is `[tennis, tom, skiing]`

hobbies1([tennis, music]).
hobbies2([skiing, food]).
% its a good practice to treat the whole tail as a single object.

%L = [a, b, c]
get_tail([_|Tail], Tail).

% implement the membership relation:
% returns true if an object `X` is in the list `L`.
member(X, [X | Tail]).
member(X, [Head | Tail]):-
    member(X, Tail).

% defining the concatination relation for lists:
% case 01 - first list is empty.
conc([], L, L).

% case 02 - if its not empty then it must have a Head and Tail. [X | L1]
conc([X | L1], L2, [X | L3]):-
    conc(L1, L2, L3). % don't forgot the period like me :'('

% reimplementing the member relation using conc
member1(X, L):-
    conc(L1, [X | L2], L).

% we can rewrite `member1` as
member2(X,L):-
    conc(_,[X | _], L).

% adding an item to the list
add(X, L, [X | L]).

% deleting an item form a list
% if X is the head:
del(X, [X| Tail], Tail).

% if X is in the tail:
del(X, [Y | Tail], [Y | Tail1]):-
    del(X, Tail, Tail1).

% inserting an element `X` in a list using del
insert(X, List, BiggerList):-
    del(X, BiggerList, List).


% using del in the member relation:
member3(X, List):-
    del(X,List, _).

% implementing sublist
sublist(S, L):-
    conc(L1, L2, L),
    conc(S, L3, L2).