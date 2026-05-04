# Genetic Algorithms — Crossover Practice Problems

> **Comp 408 Exam Prep | One-Point Crossover on Binary-Encoded Populations**

---

## How to Approach These Problems — General Steps

1. **Encode** each value as a binary string (use enough bits for the largest number)
2. **Calculate fitness** using the given fitness function f(x)
3. **Calculate selection probabilities** → P(xi) = f(xi) / Σf(xj)
4. **Select parents** (usually the two highest fitness chromosomes)
5. **Apply one-point crossover** at a given (or random) cut point
6. **Decode** the offspring back to decimal
7. **Evaluate** the offspring fitness

---

## Original Midterm Problem — Fully Solved

**Problem:** A population contains the numbers 3, 5, 9, 14. The fitness function is f(x) = x². Perform one-point crossover.

---

### Step 1: Encode to Binary

The largest number is 14 → needs 4 bits.

| Chromosome | Decimal | Binary |
| ---------- | ------- | ------ |
| A          | 3       | `0011` |
| B          | 5       | `0101` |
| C          | 9       | `1001` |
| D          | 14      | `1110` |

---

### Step 2: Calculate Fitness → f(x) = x²

| Chromosome | Decimal | Fitness f(x) = x² |
| ---------- | ------- | ----------------- |
| A          | 3       | 3² = **9**        |
| B          | 5       | 5² = **25**       |
| C          | 9       | 9² = **81**       |
| D          | 14      | 14² = **196**     |
| **Total**  |         | **311**           |

---

### Step 3: Selection Probabilities

| Chromosome | Fitness | P(x) = f(x)/311 | Approx % |
| ---------- | ------- | --------------- | -------- |
| A          | 9       | 9/311           | 3%       |
| B          | 25      | 25/311          | 8%       |
| C          | 81      | 81/311          | 26%      |
| D          | 196     | 196/311         | 63%      |

→ **D and C** have the highest probabilities, so they are selected as parents.

---

### Step 4: One-Point Crossover (cut after position 2)

```
Parent C:  1 0 | 0 1
Parent D:  1 1 | 1 0
                ↑ cut point (after bit 2)

Child C1:  1 0 | 1 0   (C's head + D's tail)
Child C2:  1 1 | 0 1   (D's head + C's tail)
```

---

### Step 5: Decode Offspring

| Offspring | Binary | Decimal | Fitness f(x) = x² |
| --------- | ------ | ------- | ----------------- |
| C1        | `1010` | 10      | 100               |
| C2        | `1101` | 13      | 169               |

---

### Step 6: Compare with Parents

|              | Chromosome  | Fitness                 |
| ------------ | ----------- | ----------------------- |
| Parent C     | `1001` = 9  | 81                      |
| Parent D     | `1110` = 14 | 196                     |
| **Child C1** | `1010` = 10 | **100** ↑ better than C |
| **Child C2** | `1101` = 13 | **169** ↑ better than C |

The offspring are viable — C1 improved over parent C!

---

---

## Practice Problems

---

### Problem 1

A population contains the numbers 2, 6, 10, 13. The fitness function is f(x) = x². Perform one-point crossover at position 2 on the two fittest parents.

---

### Problem 2

A population contains the numbers 1, 4, 7, 11. The fitness function is f(x) = 2x + 3. Perform one-point crossover at position 3 on the two fittest parents. Decode the offspring and evaluate their fitness.

---

### Problem 3

A population contains the numbers 5, 8, 12, 15. The fitness function is f(x) = x² - x. Perform one-point crossover at position 1 on the two fittest parents. What are the selection probabilities? What are the offspring values?

---

### Problem 4

A population contains the numbers 3, 7, 10, 14. The fitness function is f(x) = x².

- a) Perform one-point crossover at position 2 on parents C (10) and D (14).
- b) Now perform two-point crossover at positions 1 and 3 on the same parents.
- c) Compare offspring fitness from both methods.

---

### Problem 5

A population contains the numbers 6, 9, 11, 15. The fitness function is f(x) = x². Perform one-point crossover at position 3 on the two fittest parents. Then apply **bit-flip mutation** at position 2 of each offspring. Decode and evaluate the final mutated offspring.

---

### Problem 6

A population contains the numbers 4, 8, 13, 15. The fitness function is f(x) = x² + x.

- a) Calculate fitness and selection probabilities.
- b) How many times would you expect the fittest chromosome to be selected if the roulette wheel is spun 5 times?
- c) Perform one-point crossover at position 2 on the two fittest parents.

---

### Problem 7

A population contains the numbers 2, 5, 11, 14. The fitness function is f(x) = x².

- a) Encode all chromosomes in binary.
- b) Perform one-point crossover at position 3 on the two fittest parents.
- c) One of the offspring has a lower fitness than both parents. Which one, and why did this happen? What GA mechanism would help recover from this?

---

---

## Answers

---

### Answer 1

**Encode** (largest = 13 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x² |
| ---------- | ------- | ------ | ---------- |
| A          | 2       | `0010` | 4          |
| B          | 6       | `0110` | 36         |
| C          | 10      | `1010` | 100        |
| D          | 13      | `1101` | 169        |
| Total      |         |        | **309**    |

**Selection Probabilities:**

- A: 4/309 = 1%, B: 36/309 = 12%, C: 100/309 = 32%, D: 169/309 = **55%**

**Parents selected: D and C** (highest fitness)

**One-point crossover at position 2:**

```
Parent D:  1 1 | 0 1
Parent C:  1 0 | 1 0

Child C1:  1 1 | 1 0  = 1110 → decimal 14 → fitness 196
Child C2:  1 0 | 0 1  = 1001 → decimal 9  → fitness 81
```

---

### Answer 2

**Encode** (largest = 11 → 4 bits):

| Chromosome | Decimal | Binary | Fitness 2x+3 |
| ---------- | ------- | ------ | ------------ |
| A          | 1       | `0001` | 5            |
| B          | 4       | `0100` | 11           |
| C          | 7       | `0111` | 17           |
| D          | 11      | `1011` | 25           |
| Total      |         |        | **58**       |

**Parents selected: D and C**

**One-point crossover at position 3:**

```
Parent D:  1 0 1 | 1
Parent C:  0 1 1 | 1

Child C1:  1 0 1 | 1  = 1011 → decimal 11 → fitness 2(11)+3 = 25
Child C2:  0 1 1 | 1  = 0111 → decimal 7  → fitness 2(7)+3  = 17
```

Offspring are identical to parents in this case — the cut point was at the last position and both parents shared the same last bit.

---

### Answer 3

**Encode** (largest = 15 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x²-x |
| ---------- | ------- | ------ | ------------ |
| A          | 5       | `0101` | 20           |
| B          | 8       | `1000` | 56           |
| C          | 12      | `1100` | 132          |
| D          | 15      | `1111` | 210          |
| Total      |         |        | **418**      |

**Selection Probabilities:**

- A: 20/418 = 5%, B: 56/418 = 13%, C: 132/418 = 32%, D: 210/418 = **50%**

**Parents selected: D and C**

**One-point crossover at position 1:**

```
Parent D:  1 | 1 1 1
Parent C:  1 | 1 0 0

Child C1:  1 | 1 0 0  = 1100 → decimal 12 → fitness 132
Child C2:  1 | 1 1 1  = 1111 → decimal 15 → fitness 210
```

Both offspring are identical to the original parents — when the cut is at position 1 and parents share the same first bit, no new information is created. This illustrates why crossover point selection matters.

---

### Answer 4

**Encode** (largest = 14 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x² |
| ---------- | ------- | ------ | ---------- |
| A          | 3       | `0011` | 9          |
| B          | 7       | `0111` | 49         |
| C          | 10      | `1010` | 100        |
| D          | 14      | `1110` | 196        |

**Parents: D (1110) and C (1010)**

**a) One-point crossover at position 2:**

```
Parent D:  1 1 | 1 0
Parent C:  1 0 | 1 0

Child C1:  1 1 | 1 0  = 1110 → 14 → fitness 196
Child C2:  1 0 | 1 0  = 1010 → 10 → fitness 100
```

Offspring identical to parents (same tail bits).

**b) Two-point crossover at positions 1 and 3:**

```
Parent D:  1 | 1 1 | 0
Parent C:  1 | 0 1 | 0

Child C1:  1 | 0 1 | 0  = 1010 → 10 → fitness 100
Child C2:  1 | 1 1 | 0  = 1110 → 14 → fitness 196
```

**c) Comparison:** Both methods produced offspring with fitness 100 and 196 in this case. Two-point crossover swapped the middle segment but the result was the same due to the specific bit patterns. In general, two-point crossover preserves more of both parents' structure.

---

### Answer 5

**Encode** (largest = 15 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x² |
| ---------- | ------- | ------ | ---------- |
| A          | 6       | `0110` | 36         |
| B          | 9       | `1001` | 81         |
| C          | 11      | `1011` | 121        |
| D          | 15      | `1111` | 225        |

**Parents: D (1111) and C (1011)**

**One-point crossover at position 3:**

```
Parent D:  1 1 1 | 1
Parent C:  1 0 1 | 1

Child C1:  1 1 1 | 1  = 1111 → 15 → fitness 225
Child C2:  1 0 1 | 1  = 1011 → 11 → fitness 121
```

**Bit-flip mutation at position 2 of each offspring:**

```
C1 before: 1 1 1 1  → flip bit 2 → 1 0 1 1 = 1011 → 11 → fitness 121
C2 before: 1 0 1 1  → flip bit 2 → 1 1 1 1 = 1111 → 15 → fitness 225
```

Interestingly, mutation caused C1 and C2 to swap values — a reminder that mutation is random and can both help and hurt fitness.

---

### Answer 6

**Encode** (largest = 15 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x²+x |
| ---------- | ------- | ------ | ------------ |
| A          | 4       | `0100` | 20           |
| B          | 8       | `1000` | 72           |
| C          | 13      | `1101` | 182          |
| D          | 15      | `1111` | 240          |
| Total      |         |        | **514**      |

**a) Selection Probabilities:**

- A: 20/514 = 4%, B: 72/514 = 14%, C: 182/514 = 35%, D: 240/514 = **47%**

**b) Expected selections of D in 5 spins:**
Expected = 0.47 × 5 = **2.35 times**

**c) One-point crossover at position 2 on D and C:**

```
Parent D:  1 1 | 1 1
Parent C:  1 1 | 0 1

Child C1:  1 1 | 0 1  = 1101 → 13 → fitness 182
Child C2:  1 1 | 1 1  = 1111 → 15 → fitness 240
```

---

### Answer 7

**Encode** (largest = 14 → 4 bits):

| Chromosome | Decimal | Binary | Fitness x² |
| ---------- | ------- | ------ | ---------- |
| A          | 2       | `0010` | 4          |
| B          | 5       | `0101` | 25         |
| C          | 11      | `1011` | 121        |
| D          | 14      | `1110` | 196        |

**a) Binary encodings:** listed above.

**b) One-point crossover at position 3 on D and C:**

```
Parent D:  1 1 1 | 0
Parent C:  1 0 1 | 1

Child C1:  1 1 1 | 1  = 1111 → 15 → fitness 225  ↑ better than both parents
Child C2:  1 0 1 | 0  = 1010 → 10 → fitness 100  ↓ worse than both parents
```

**c) C2 (fitness 100) is weaker than both parents (121 and 196).**

This happens because the crossover split apart a good combination of bits that existed in the parents. The tail bit `0` from D combined with C's head to produce a lower value.

**How to recover:** **Mutation** can flip C2's bits to explore nearby values. Additionally, **elitism** (always keeping the best chromosome unchanged in the next generation) ensures the population never loses its best solution.

---

_Practice file generated for Comp 408 exam prep — Genetic Algorithms Unit_
