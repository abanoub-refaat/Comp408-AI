# Chapter 01 - Exercises

## 1.1 Exercises

Assuming the parent relation as defined in this section (see Figure 1.1), what will be
Prolog's answers to the following questions?
(a) ?- parent( jim, X).
(b) ?-parent( X, jim).
(c) ?- parent( pam, X), parent( X, pat).
(d) ?- parent( pam, X), parent( X, Y), parent( Y, jim).

## 1.2 Exercises

Translate the following statements into Prolog rules:
(a) Everybody who has a child is happy (introduce a one-argument relation
happy).

(b) For all X, if X has a child who has a sister then X has two children (introduce
new relation hastwochildren).

1.4 Define the relation grandchild using the parent relation. Hint: It will be similar to
the grandparent relation (see Figure 1.3).
1.5 Define the relation aunt( X, Y) in terms of the relations parent and sister.
As an aid you can first draw a diagram in the style of Figure 1.3 for the aunt
relation.
