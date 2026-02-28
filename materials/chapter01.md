# Chapter 1: Introduction to Prolog

This chapter summary is based on "Prolog Programming for Artificial Intelligence" by Ivan Bratko, fourth edition.

This chapter introduces the fundamental concepts of Prolog, a language for symbolic and non-numeric computation. We will explore how to define relationships using facts, rules, and recursion.

**Associated Lab File:** [labs/lab01/lab01.pl](../labs/lab01/lab01.pl)

---

## 1.1 Defining Relations by Facts

In Prolog, we can define relationships between objects as **facts**. For example, to state that Tom is a parent of Bob, we write:

```prolog
parent(tom, bob).
```

This establishes a `parent` relationship. We can then query the Prolog system to get information about this relationship.

### Asking Questions (Queries)

- **Is Bob a parent of Pat?**

  ```prolog
  ?- parent(bob, pat).
  ```

- **Who is Liz's parent?**

  ```prolog
  ?- parent(X, liz).
  ```

- **Who are Bob's children?**

  ```prolog
  ?- parent(bob, X).
  ```

Prolog answers these questions by trying to satisfy the **goals** provided. We can also ask more complex questions by combining goals:

- **Who is a grandparent of Jim?**

  ```prolog
  ?- parent(Y, jim), parent(X, Y).
  ```

- **Do Ann and Pat have a common parent?**

  ```prolog
  ?- parent(X, ann), parent(X, pat).
  ```

---

## 1.2 Defining Relations by Rules

We can also define new relationships using **rules**. A rule is a general statement about objects and their relationships.

For example, we can define a `mother` relation based on the existing `parent` and `female` relations.

**Logical Statement:**
For all X and Y, X is the mother of Y if X is a parent of Y and X is female.

**Prolog Rule:**

```prolog
mother(X, Y) :-
    parent(X, Y),
    female(X).
```

The `:-` symbol is read as "if".

---

## 1.3 Recursive Rules

Some relations are **recursive**, meaning they can be defined in terms of themselves. The `ancestor` relation is a classic example.

An ancestor can be either:

1. A direct parent.
2. An indirect ancestor (a parent of a parent, and so on).

We can define this in Prolog with two rules:

```prolog
% Rule 1: A direct ancestor is a parent
ancestor(X, Z) :-
    parent(X, Z).

% Rule 2: An indirect ancestor is a parent of another ancestor
ancestor(X, Z) :-
    parent(X, Y),
    ancestor(Y, Z).
```

This recursive definition allows Prolog to find ancestors at any depth in a family tree.

---

### Important Terminology

- **Clause:** A fact or a rule. Each clause terminates with a full stop (`.`).
- **Atom:** A constant value, like `tom` or `ann`.
- **Variable:** A general object, like `X` or `Y`. Variable names start with an uppercase letter or an underscore.
- **Unary Relation:** A property of a single object (e.g., `female(pam)`).
- **Binary Relation:** A relationship between two objects (e.g., `parent(tom, bob)`).
