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

/* Exercise 6.6: Multiplication Table */
/* Define a predicate multi_table(N) that prints the multiplication table for N from 1 to 10. */
multi_table(N) :-
    multi_table(N, 1).

multi_table(_, 11) :- !.
multi_table(N, I) :-
    I =< 10,
    Res is N * I,
    write(N), write(' x '), write(I), write(' = '), write(Res), nl,
    Next is I + 1,
    multi_table(N, Next).

/* Exercise 6.7: Interactive Average Loop */
/* Define a predicate average_loop that repeatedly asks for numbers until 'end' is entered, then calculates the average. */
average_loop :-
    write('Enter numbers to average. Enter "end" to stop.'), nl,
    get_numbers(Nums),
    (Nums = [] -> write('No numbers entered.'), nl ;
        sum_list_custom(Nums, Sum),
        length(Nums, Len),
        Avg is Sum / Len,
        write('Numbers entered: '), write(Nums), nl,
        write('Average: '), write(Avg), nl
    ).

get_numbers(Nums) :-
    write('Number: '), read(X),
    (X = end -> Nums = [] ;
        number(X) -> (Nums = [X|Rest], get_numbers(Rest)) ;
        (write('Please enter a valid number or "end".'), nl, get_numbers(Nums))
    ).

sum_list_custom([], 0).
sum_list_custom([H|T], S) :- sum_list_custom(T, S1), S is H + S1.
