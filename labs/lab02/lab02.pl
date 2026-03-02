% for chapter explaination check materials/chapter02.md

big(bear).              %clause 1
big(elephant).          %clause 2
small(cat).             %clause 3
brown(bear).            %clause 4
black(cat).             %clause 5
gray(elephant).         %clause 6

dark(Z) :-              %clause 7
    black(Z).

dark(Z) :-              %clause 8
    brown(Z).
