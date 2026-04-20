/* Exercise 6.1: Countdown from N to 0 */
countdown(0) :- write(0), nl.
countdown(N) :-
    N > 0,
    write(N), nl,
    N1 is N - 1,
    countdown(N1).

/* Exercise 6.2: Countup from Low to High */
countup(High, High) :- write(High), nl.
countup(Low, High) :-
    Low < High,
    write(Low), nl,
    Next is Low + 1,
    countup(Next, High).

/* Exercise 6.3: Recursive Factorial */
factorial(0, 1).
factorial(N, F) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, F1),
    F is N * F1.

/* Exercise 6.4: Read terms from user until 'stop' is entered */
read_until_stop :-
    repeat,
    write('Enter term (stop to exit): '),
    read(Term),
    write('You entered: '), write(Term), nl,
    Term = stop,
    write('Finished.'), nl.

/* Exercise 6.5: Simple Calculator Loop */
calc :-
    repeat,
    write('Enter first number (or 0 to exit): '), read(A),
    (A = 0 -> ! ;
        write('Enter second number: '), read(B),
        Sum is A + B,
        write('Sum: '), write(Sum), nl,
        fail
    ).
