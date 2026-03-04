% implement the factorial function

% base case:
factorial(0, 1).
factorial(1, 1).

% recursive case:
factorial(N, Ans):-
    N > 0,
    N2 is N -1,
    factorial(N1, Rest),
    Ans is N * Rest.
