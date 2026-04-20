/* Example 1: Loop a fixed number of times (down to 1) */

loop(0).
loop(N) :-
    write('the number is '), write(N), nl,
    M is N - 1,
    loop(M).

/* Example 2: Output integers from First to Last inclusive */
output_values(Last, Last) :-
    write(Last), nl,
    write('end of example'), nl.
output_values(First, Last) :-
    First =\= Last,
    write(First), nl,
    N is First + 1,
    output_values(N, Last).

/* Example 3: Sum of the first N integers (recursive) */
sumto(1, 1).
sumto(N, S):-
    N > 1,
    N1 is N -1,
    sumto(N1, S1),
    S is S1 + N.

/* Example 4: Output the squares of the first N integers */
writesquares(1) :-
    write(1), nl.
writesquares(N) :-
    N > 1,
    N1 is N - 1,
    writesquares(N1),
    Nsq is N * N,
    write(Nsq), nl.

/* Example 5: Read the first 6 terms from a file */
read_six(Infile) :-
    seeing(S),
    see(Infile),
    process_terms(6),
    seen,
    see(S).

process_terms(0).
process_terms(N) :-
    N > 0,
    read(X),
    write(X), nl,
    N1 is N - 1,
    process_terms(N1).

/* Section 6.2.1: Looping until a condition is satisfied (Recursion) */
go_recursive :-
    loop_recursive(start).

loop_recursive(end).
loop_recursive(X) :-
    X \= end,
    write('Type end to end: '),
    read(Word),
    write('Input was '), write(Word), nl,
    loop_recursive(Word).

/* Single clause loop using disjunction */
loop_disjunction :-
    write('Type end to end: '),
    read(Word),
    write('Input was '), write(Word), nl,
    (Word = end ; loop_disjunction).

/* Repeated prompt until yes/no is entered (Recursion) */
get_answer_rec(Ans) :-
    write('Enter answer to question'), nl,
    get_answer2(Ans).

get_answer2(Ans) :-
    write('answer yes or no: '),
    read(A),
    ((valid(A), Ans = A, write('Answer is '), write(A), nl) ; get_answer2(Ans)).

valid(yes).
valid(no).

/* Section 6.2.2: Using the 'repeat' predicate */
get_answer_repeat(Ans) :-
    write('Enter answer to question'), nl,
    repeat,
    write('answer yes or no: '),
    read(Ans),
    valid(Ans),
    write('Answer is '), write(Ans), nl.

/* Read terms from a file until 'end' is encountered (using repeat) */
readterms(Infile) :-
    seeing(S),
    see(Infile),
    repeat,
    read(X),
    write(X), nl,
    X = end,
    seen,
    see(S).

/* Repeated Menu structure */
go_menu :-
    write('This shows how a repeated menu works'),
    menu.

menu :-
    nl,
    write('MENU'), nl,
    write('a. Activity A'), nl,
    write('b. Activity B'), nl,
    write('c. Activity C'), nl,
    write('d. End'), nl,
    read(Choice), nl,
    choice(Choice).

choice(a) :- write('Activity A chosen'), menu.
choice(b) :- write('Activity B chosen'), menu.
choice(c) :- write('Activity C chosen'), menu.
choice(d) :- write('Goodbye!'), nl.
choice(_) :- write('Please try again!'), menu.
