# Chapter 01 - Introduction to Prolog

## 1.1 Defining relations by facts

**Prolog** is a programming language for symbolic, non-numeric computation.

if we want to say that `Tom` is a parent for `Bob` we write:

```prolog
parent(tom, bob)
```

When this program has been communicated to the Prolog system, Prolog can
be posed some questions about the parent relation. For example: Is Bob a parent
of Pat? This question can be communicated to the Prolog system by typing:

```prolog
?- parent(bob,pat) -> yes
```

More interesting questions can also be asked. For example: Who is Liz's parent?

```prolog
?- parent( X, liz).
```

Prolog will now tell us what is the value of X such that the above statement is true.
So the answer is:
X = tomThe question Who are Bob's children? can be communicated to Prolog as:

```prolog
?- parent( bob, X).
```

Our example program can be asked still more complicated questions like: Who
is a grandparent of Jim?

```prolog
?- parent( Y, jim), parent( X, Y).
```

In a similar way we can ask: Who are Tom's grandchildren?

```prolog
?- parent(tom, X), parent( X, Y).
```

Yet another question could be: Do Ann and Pat have a common parent? This can be
expressed again in two steps:
(1) Who is a parent, X, of Ann?
(2) Is X also a parent of Pat?
The corresponding question to Prolog is:

````prolog
?- parent( X, ann), parent( X, pat).
The answer is:

```prolog
X = bob
````

A Prolog program consists of clauses. Each clause terminates with a full stop.

The arguments of relations can (among other things) be: concrete objects (atoms), or
constants (such as tom and ann), or general objects such as X and Y (variables).

The names of variables are strings that
start with an upper-case letter or an underscore.

The word 'goals' is used because Prolog interprets questions as goals that are to
be satisfied. To 'satisfy a goal' means to logically deduce the goal from the
program.

## 1.2 Defining relations by rules

first we need to identify the gender of the people with `female()` and `male()` relations, and we can ask more intresting questins about them.

A **binary** relation like parent defines a relation between pairs of objects; on the other hand, **unary** relations can be used to declare simple yes/no
properties of objects.

As our next extension to the program, let us introduce the mother relation. We
could define mother in a similar way as the parent relation;

```prolog
mother( pam, bob).
mother( pat, jim).
```

imagine we had a large database of people. Then the mother relation can
be defined much more elegantly by making use of the fact that it can be logically
derived from the already known relations parent and female. This alternative way
can be based on the following logical statement:
For all X and Y,
X is the mother of Y if
X is a parent of Y, and X is female.

In Prolog this is written as:

```prolog
mother(X, Y) :. parent( X, Y), female(X).
```

The Prolog symbol `:-` is read as `if`. This clause can also be read as:
For all X and Y,
if X is a parent of Y and X is female then
X is the mother of Y.

when
