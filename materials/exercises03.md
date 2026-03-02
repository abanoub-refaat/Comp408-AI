# Chapter 3: Exercises

This file contains exercises related to the concepts covered in Chapter 3. The solutions and implementations can be found in the lab file:

- **Lab File:** [`labs/lab03/ex03.pl`](../labs/lab03/ex03.pl)

---

## Exercise 3.1: Deleting Elements from a List

**(a) Delete the last three elements from a list.**

Write a goal using `conc/3` to delete the last three elements from a list `L`, producing a new list `L1`.

**Hint:** `L` is the concatenation of `L1` and a three-element list.

**Solution:**

```prolog
?- L1 = [a, b, z, d, f], conc(L2, [_, _, _], L1).
L1 = [a, b, z, d, f],
L2 = [a, b].
```

**(b) Delete the first three and last three elements from a list.**

Write a goal to delete the first three and last three elements from a list `L`, producing `L2`.

**Solution:**

```prolog
?- L = [1, 2, 3, a, b, c, 4, 5, 6],
   conc([_, _, _], Rest, L),    % Remove the first 3 elements
   conc(L2, [_, _, _], Rest).   % Remove the last 3 elements from the rest
L2 = [a, b, c].
```

---

## Exercise 3.2: Finding the Last Element

Define the relation `last(Item, List)` where `Item` is the last element of `List`.

**(a) Using the `conc/3` relation.**

**Solution:**

The list `List` can be seen as the concatenation of some `Front` part and a list containing just the `Item`.

```prolog
last(Item, List) :-
    conc(_Front, [Item], List).
```

**(b) Using recursion.**

**Solution:**

This approach "peels off" the head of the list until only one element remains.

- **Base Case:** If the list has only one element, that element is the last one.
  ```prolog
  last(Item, [Item]).
  ```
- **Recursive Step:** If the list has more than one element, the last element of the whole list is the last element of its tail.
  ```prolog
  last(Item, [_ | Tail]) :-
      last(Item, Tail).
  ```

---

## Exercise 3.3: Even and Odd Length Lists

Define two predicates `evenlength(List)` and `oddlength(List)` so that they are true if their argument is a list of even or odd length, respectively.

**Example:**

- `[a,b,c,d]` is `evenlength`.
- `[a,b,c]` is `oddlength`.

---

## Exercise 3.4: Reversing a List

Define the relation `reverse(List, ReversedList)` that reverses lists.

**Example:**

```prolog
reverse([a,b,c,d], [d,c,b,a]).
```

---

## Exercise 3.5: Palindrome Check

Define the predicate `palindrome(List)`. A list is a palindrome if it reads the same forwards and backward.

**Example:**

- `[m,a,d,a,m]` is a palindrome.

---

## Exercise 3.6: Rotational Shift

Define the relation `shift(List1, List2)` so that `List2` is `List1` 'shifted rotationally' by one element to the left.

**Example:**

```prolog
?- shift([1,2,3,4,5], L1),
   shift(L1, L2).
L1 = [2,3,4,5,1]
L2 = [3,4,5,1,2]
```

---

## Exercise 3.7: Number to Word Translation

Define the relation `translate(List1, List2)` to translate a list of numbers between 0 and 9 to a list of the corresponding words.

**Example:**

```prolog
translate([3,5,1,3], [three,five,one,three])
```

Use the following as an auxiliary relation:

```prolog
means(0, zero). means(1, one). means(2, two). ...
```

---

## Exercise 3.8: Subset Relation

Define the relation `subset(Set, Subset)` where `Set` and `Subset` are two lists representing two sets. This relation should not only check for the subset relation but also generate all possible subsets of a given set.

**Example:**

```prolog
?- subset([a,b,c], S).
S = [a,b,c] ;
S = [a,b] ;
S = [a,c] ;
S = [a] ;
S = [b,c] ;
S = [b] ;
S = [c] ;
S = [] ;
no
```

---

## Exercise 3.9: List Partitioning

Define the relation `dividelist(List, List1, List2)` so that the elements of `List` are partitioned between `List1` and `List2`, and `List1` and `List2` are of approximately the same length.

**Example:**

```prolog
dividelist([a,b,c,d,e], [a,c,e], [b,d]).
```

---

## Exercise 3.10: Equal Length Lists

Define the predicate `equal_length(L1, L2)` which is true if lists `L1` and `L2` have an equal number of elements.

---

## Exercise 3.11: Flatten a List

Define the relation `flatten(List, FlatList)` where `List` can be a list of lists, and `FlatList` is `List` 'flattened' so that the elements of `List`'s sublists (or sub-sublists) are reorganized as one plain list.

**Example:**

```prolog
?- flatten([a,b,[c,d],[],[[[e]]],f], L).
L = [a,b,c,d,e,f]
```

---

## Extra Exercises

### 1. Add an Element to the End of a List

Implement the relation `add_last(X, List, NewList)` for adding an element `X` to the end of a `List`.

**(a) Using the `conc/3` relation.**

This is the most elegant way. The new list is the result of joining the old list with a list containing only the new element.

```prolog
add_last(X, List, NewList) :-
    conc(List, [X], NewList).
```

**(b) Using recursion.**

This method traverses the list until it finds the end and then adds the new element.

- **Base Case:** If the original list is empty, adding `X` to the end results in `[X]`.
  ```prolog
  add_last(X, [], [X]).
  ```
- **Recursive Step:** Keep the head and recursively add `X` to the tail.
  ```prolog
  add_last(X, [H | T], [H | NewT]) :-
      add_last(X, T, NewT).
  ```

### 2. Reverse a List

#### The Simple Way (Using `conc/3`)

This method uses the "peel and stick" logic. You take the head off, reverse the rest of the list, and then use `conc/3` to put that head at the very end.

```prolog
% Base Case: An empty list reversed is still empty.
reverse_list([], []).

% Recursive Step:
reverse_list([X | Tail], Reversed) :-
    reverse_list(Tail, RevTail), % Reverse the rest of the list first
    conc(RevTail, [X], Reversed). % Add the original Head (X) to the end
```

#### The Efficient Way (Using an "Accumulator")

The simple way above is often less efficient due to repeated calls to `conc/3`. A more efficient way is to use an accumulator. This is like moving items from one pile to another; as you pick an item from the first pile, you place it on top of the second pile. When the first pile is empty, the second pile contains the reversed items.

```prolog
% The main rule starts with an empty accumulator [].
reverse_fast(List, Reversed) :-
    reverse_acc(List, [], Reversed).

% Base Case: When the input list is empty, the Accumulator is our answer.
reverse_acc([], Acc, Acc).

% Recursive Step: Take the Head (X) and add it to the FRONT of the Accumulator.
reverse_acc([X | Tail], Acc, Reversed) :-
    reverse_acc(Tail, [X | Acc], Reversed).
```

**How the Accumulator works (O(N) speed):**

If you run `reverse_fast([a, b, c], L)`, the internal steps look like this:

| Step | Input List  | Accumulator |
| :--- | :---------- | :---------- |
| 1    | `[a, b, c]` | `[]`        |
| 2    | `[b, c]`    | `[a]`       |
| 3    | `[c]`       | `[b, a]`    |
| 4    | `[]`        | `[c, b, a]` |

### 3. define `oddlength` and `evenlength` in terms of each other

In Prolog, it’s often cleaner to define them in terms of each other. This is a very common pattern:

```prolog
% A list is even if it's empty.
evenlength([]).

% A list is even if it has one element followed by an ODD tail.
evenlength([_|Tail]) :-
oddlength(Tail).

% A list is odd if it has one element followed by an EVEN tail.
oddlength([_|Tail]) :-
evenlength(Tail).
```

**How it works step-by-step:**

If you call `?- evenlength([a, b, c, d]).`:

1. evenlength([a, b, c, d]) calls oddlength([b, c, d]).
2. oddlength([b, c, d]) calls evenlength([c, d]).
3. evenlength([c, d]) calls oddlength([d]).
4. oddlength([d]) calls evenlength([]).
5. evenlength([]) is true!
