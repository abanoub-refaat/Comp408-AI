% count real occurrences of an atom in a list
count(_,[],0).
count(A, [B | L], N):-
    atom(B), A = B, !,
    count(A,L,N1),
    N is N1 + 1.
count(A, [_ | L], N):-
    count(A, L, N).

% using nonvar() to avoid redundent instantiated
del_var(A, L, L):-
    nonvar(A), !.
del_var(A, [A | L], L).
del_var(A, [B | L], [B | L1]):-
    del_var(A, L, L1).

% robot movement A -> B -> C equivelant to A -> C
move(X, Y, Z):-
    retract(on(X, Y)),
    assert(on(X, Z)).

% simple memoization (caching) in prolog.
solve_and_cache(Problem, Solution):-
    solve(Problem, Solution),
    asserta(solve(Problem, Solution)).

% input and output Section content:

create_input:-
    tell('input1.txt'),
    write(person(alice,30)),write('.'),nl,
    write(person(bob,25)),write('.'),nl,
    write(person(carol,35)),write('.'),nl,
    write('end'),write('. \n'),told.

run:- 
    tell('names1.txt'),
    write(alice),write('.'),nl,
    write(bob),write('.'),nl,
    write(ranya),write('.'),nl,
    write('end'),write('.'),nl,told,
    % write in the terminal log
    write('Reading names1.txt'),nl,
    % open a input stream
    see('names1.txt'),
    read_loop,
    seen.

read_loop:- 
    read(Term),
    ((Term == end ; Term == end_of_file) -> write('Done');
    write(' -> '), write(Term),nl,read_loop).

% Extra Section examples.
cube(N,X):- 
    X is N*N*N.

cube2:-
    read(X),process(X).
process(stop):-!.
process(X):- 
    C is X*X*X , write(C),nl,cube2.

cube3:- 
    write('Next item,please.'),read(X),process2(X).
process2(stop):-!.
process2(X):- 
    C is X*X*X , write('Cube of '), write(X),
    write(' is '),write(C),nl,cube3.

writelist([]).
writelist([X|L]):-
    write(X),nl,writelist(L).

% handel nested lists
writelist2([]).
writelist2([L|LL]):- 
    doline(L),nl,writelist2(LL).

doline([]).
doline([X|L]):- 
    write(X),tab(1),doline(L).

squeeze :- 
    get0(C), put(C), dorest(C).
% 46 is ASCII for full stop, all done
dorest(46):-!. 
dorest(32) :- !, 
    %32 is the ASCII for space
    get(C), put(C), dorest(C).  
dorest(_) :- squeeze.