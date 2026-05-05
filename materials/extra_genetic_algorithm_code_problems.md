# Comp 408 — Genetic Algorithm: Code Implementation Study Guide

> **Lab Code Walkthrough | String Evolution using GA**

---

## Table of Contents

- [Comp 408 — Genetic Algorithm: Code Implementation Study Guide](#comp-408--genetic-algorithm-code-implementation-study-guide)
  - [Table of Contents](#table-of-contents)
  - [1. What Does This Program Do?](#1-what-does-this-program-do)
    - [The Big Picture Flow](#the-big-picture-flow)
  - [2. Function-by-Function Explanation](#2-function-by-function-explanation)
    - [2.1 `create_gen`](#21-create_gen)
    - [2.2 `calculate_fitness`](#22-calculate_fitness)
    - [2.3 `create_population`](#23-create_population)
    - [2.4 `selection`](#24-selection)
    - [2.5 `crossover`](#25-crossover)
    - [2.6 `mutation`](#26-mutation)
    - [2.7 `regeneration`](#27-regeneration)
    - [2.8 `bestgen` / `bestfitness` / `display`](#28-bestgen--bestfitness--display)
  - [3. Full Walkthrough Example](#3-full-walkthrough-example)
    - [Step 1: `create_population`](#step-1-create_population)
    - [Step 2: `selection`](#step-2-selection)
    - [Step 3: `crossover`](#step-3-crossover)
    - [Step 4: `mutation` (mutation_rate = 0.2)](#step-4-mutation-mutation_rate--02)
    - [Step 5: Check improvement](#step-5-check-improvement)
    - [Step 6: `display` output](#step-6-display-output)
  - [4. The Main Loop — How It All Connects](#4-the-main-loop--how-it-all-connects)
    - [Sample Console Output](#sample-console-output)
  - [5. Practice Questions](#5-practice-questions)
    - [Conceptual Questions](#conceptual-questions)
    - [Tracing / Calculation Questions](#tracing--calculation-questions)
    - [Scenario Questions](#scenario-questions)
  - [6. Small Coding Questions](#6-small-coding-questions)
  - [Answers to Tracing Questions](#answers-to-tracing-questions)
    - [A6 — `calculate_fitness("Hat", "Cat")`](#a6--calculate_fitnesshat-cat)
    - [A7 — `selection`](#a7--selection)
    - [A8 — `crossover("abcdef", "ABCDEF")`](#a8--crossoverabcdef-abcdef)
    - [A9 — `mutation("Hello", rate=0.2)`](#a9--mutationhello-rate02)
    - [A10 — `regeneration`](#a10--regeneration)
    - [A11 — `display`](#a11--display)
    - [A12 — Scenario](#a12--scenario)

---

## 1. What Does This Program Do?

This program evolves a **random string** towards a **target string** using a Genetic Algorithm. Think of it as the computer "guessing" the phrase `"Hello World!"` through evolution rather than brute force.

**The target:** `"Hello World!"`  
**The approach:** Start with random gibberish strings, score them, mate the best ones, mutate offspring, repeat until a perfect match is found.

### The Big Picture Flow

```
Create random population
        ↓
Select 2 best (parents)
        ↓
Crossover → 2 children
        ↓
Mutation → 2 mutants
        ↓
If mutants are better → replace worst in population
        ↓
Repeat until fitness = 100%
```

---

## 2. Function-by-Function Explanation

---

### 2.1 `create_gen`

```python
def create_gen(panjang_target):
    random_number = np.random.randint(32, 126, size=panjang_target)
    gen = ''.join([chr(i) for i in random_number])
    return gen
```

**Purpose:** Generate one random chromosome (a random string of the same length as the target).

**Key detail:** ASCII values 32–125 cover all printable characters:

- 32 = space `' '`
- 65 = `'A'`, 72 = `'H'`, 101 = `'e'`
- 125 = `'}'`

**Step by step:**

1. Generate `panjang_target` random integers between 32 and 125.
2. Convert each integer to its ASCII character using `chr()`.
3. Join all characters into one string.

**Example:**  
`panjang_target = 5`  
Random numbers: `[72, 51, 88, 100, 65]`  
Characters: `['H', '3', 'X', 'd', 'A']`  
Gene: `"H3XdA"`

---

### 2.2 `calculate_fitness`

```python
def calculate_fitness(gen, target, panjang_target):
    fitness = 0
    for i in range(panjang_target):
        if gen[i:i+1] == target[i:i+1]:
            fitness += 1
    fitness = fitness / panjang_target * 100
    return fitness
```

**Purpose:** Score a chromosome by comparing it to the target **character by character**.

**How scoring works:**

- For each position `i`, check if `gen[i] == target[i]`.
- Each match adds 1 to the score.
- Final score = (matches / total characters) × 100

**This is position-sensitive** — `'H'` at position 0 scores, but `'H'` at position 3 does NOT score for `"Hello"`.

**Example:**

Target: `"Hello"`  
Gene: `"HXllZ"`

| Position | Target | Gene | Match? |
| -------- | ------ | ---- | ------ |
| 0        | H      | H    | ✓      |
| 1        | e      | X    | ✗      |
| 2        | l      | l    | ✓      |
| 3        | l      | l    | ✓      |
| 4        | o      | Z    | ✗      |

Matches = 3 → fitness = 3/5 × 100 = **60%**

---

### 2.3 `create_population`

```python
def create_population(target, max_population, panjang_target):
    populasi = {}
    for i in range(max_population):
        gen = create_gen(panjang_target)
        genfitness = calculate_fitness(gen, target, panjang_target)
        populasi[gen] = genfitness
    return populasi
```

**Purpose:** Build the initial population — a dictionary mapping each random chromosome to its fitness score.

**Data structure:**

```python
{
  "H3XdA": 20.0,
  "ZBllo": 60.0,
  "qWeRt": 0.0,
  ...
}
```

**Example with target = `"Hello"`, max_population = 3:**

| Gene      | Fitness |
| --------- | ------- |
| `"HXllZ"` | 60.0    |
| `"Zello"` | 80.0    |
| `"QQQQQ"` | 0.0     |

Population dictionary:

```python
{"HXllZ": 60.0, "Zello": 80.0, "QQQQQ": 0.0}
```

---

### 2.4 `selection`

```python
def selection(populasi):
    pop = dict(populasi)
    parent = {}
    for i in range(2):
        gen = max(pop, key=pop.get)
        genfitness = pop[gen]
        parent[gen] = genfitness
        if i == 0:
            del pop[gen]
    return parent
```

**Purpose:** Pick the **two fittest** chromosomes from the population to be parents.

**Step by step:**

1. Make a copy of the population (to avoid modifying the original).
2. Find the gene with the **maximum** fitness → that's Parent 1.
3. Remove Parent 1 from the copy.
4. Find the new maximum → that's Parent 2.
5. Return both parents in a dictionary.

**Example:**

Population:

```python
{"HXllZ": 60.0, "Zello": 80.0, "QQQQQ": 0.0, "Hellp": 80.0}
```

- Iteration 1: max fitness = 80.0 → `"Zello"` → Parent 1
- Remove `"Zello"` from copy
- Iteration 2: max fitness = 80.0 → `"Hellp"` → Parent 2

Result:

```python
{"Zello": 80.0, "Hellp": 80.0}
```

---

### 2.5 `crossover`

```python
def crossover(parent, target, panjang_target):
    child = {}
    cp = round(len(list(parent)[0])/2)
    for i in range(2):
        gen = list(parent)[i][:cp] + list(parent)[1-i][cp:]
        genfitness = calculate_fitness(gen, target, panjang_target)
        child[gen] = genfitness
    return child
```

**Purpose:** Combine the two parents using **one-point crossover at the midpoint**.

**Key calculation:**

```
cp = round(length / 2)
```

For a 12-character string (like "Hello World!") → cp = 6

**Crossover logic:**

- Child 1 = Parent1[:cp] + Parent2[cp:] → first half of P1, second half of P2
- Child 2 = Parent2[:cp] + Parent1[cp:] → first half of P2, second half of P1

**Example with target = `"Hello"` (length 5, cp = 3):**

```
Parent 1: "Zello"   →  Z e l | l o
Parent 2: "Hellp"   →  H e l | l p
                              ↑ cp = 3 (cut here, 0-indexed: after index 2)

Child 1: "Zel" + "lp" = "Zellp"
Child 2: "Hel" + "lo" = "Hello"  ← 100% fitness! Found the target!
```

Fitness:

- Child 1: `"Zellp"` vs `"Hello"` → matches at positions 2,3 → 2/5 × 100 = **40%**
- Child 2: `"Hello"` vs `"Hello"` → 5/5 × 100 = **100%** 🎉

---

### 2.6 `mutation`

```python
def mutation(child, target, mutation_rate, panjang_target):
    mutant = {}
    for i in range(len(child)):
        data = list(list(child)[i])
        for j in range(len(data)):
            if np.random.rand(1) <= mutation_rate:
                ch = chr(np.random.randint(32, 126))
                data[j] = ch
        gen = ''.join(data)
        genfitness = calculate_fitness(gen, target, panjang_target)
        mutant[gen] = genfitness
    return mutant
```

**Purpose:** Randomly alter characters in each child based on the mutation rate.

**mutation_rate = 0.2** means each character has a **20% chance** of being replaced with a random character.

**Step by step for each child:**

1. Convert string to a list of characters.
2. For each character, generate a random number between 0 and 1.
3. If that number ≤ mutation_rate → replace the character with a random ASCII character.
4. Join back to a string and calculate fitness.

**Example with mutation_rate = 0.2:**

Child: `"Zellp"` → characters: `['Z', 'e', 'l', 'l', 'p']`

| Position | Char | Random value | ≤ 0.2? | Action          |
| -------- | ---- | ------------ | ------ | --------------- |
| 0        | Z    | 0.85         | ✗      | keep Z          |
| 1        | e    | 0.12         | ✓      | replace → `'X'` |
| 2        | l    | 0.67         | ✗      | keep l          |
| 3        | l    | 0.31         | ✗      | keep l          |
| 4        | p    | 0.05         | ✓      | replace → `'o'` |

Mutant: `"ZXllo"` → fitness vs `"Hello"` = 2/5 × 100 = **40%**

> **Note:** Mutation can increase OR decrease fitness — it's random. The main loop only keeps mutants if they improve on the parents.

---

### 2.7 `regeneration`

```python
def regeneration(mutant, populasi):
    for i in range(len(mutant)):
        bad_gen = min(populasi, key=populasi.get)
        del populasi[bad_gen]
    populasi.update(mutant)
    return populasi
```

**Purpose:** Replace the **weakest** chromosomes in the population with the new mutants.

**Step by step:**

1. For each mutant (there are always 2), find and delete the chromosome with the **lowest fitness** from the population.
2. Add the mutants to the population.

**Example:**

Population before:

```python
{"HXllZ": 60.0, "Zello": 80.0, "QQQQQ": 0.0, "Hellp": 80.0}
```

Mutants:

```python
{"ZXllo": 40.0, "Hello": 100.0}
```

- Remove worst: `"QQQQQ"` (0.0) → deleted
- Remove next worst: `"HXllZ"` (60.0) → deleted
- Add mutants

Population after:

```python
{"Zello": 80.0, "Hellp": 80.0, "ZXllo": 40.0, "Hello": 100.0}
```

---

### 2.8 `bestgen` / `bestfitness` / `display`

```python
def bestgen(parent):
    gen = max(parent, key=parent.get)
    return gen

def bestfitness(parent):
    fitness = parent[max(parent, key=parent.get)]
    return fitness

def display(parent):
    timeDiff = datetime.datetime.now() - startTime
    print('{}\t{}%\t{}'.format(bestgen(parent), round(bestfitness(parent), 2), timeDiff))
```

**`bestgen`:** Returns the chromosome string with the highest fitness.  
**`bestfitness`:** Returns the highest fitness value (a float).  
**`display`:** Prints the best gene, its fitness %, and elapsed time in a formatted row.

**Example output line:**

```
Hellp       80.0%   0:00:00.003421
```

---

## 3. Full Walkthrough Example

Let's trace the algorithm with a **simplified target: `"Hi"` (length = 2)** and **population size = 4**.

---

### Step 1: `create_population`

4 random genes of length 2 are created:

| Gene   | vs `"Hi"` | Fitness  |
| ------ | --------- | -------- |
| `"Hi"` | H✓ i✓     | **100%** |
| `"Xz"` | X✗ z✗     | **0%**   |
| `"Hz"` | H✓ z✗     | **50%**  |
| `"Ai"` | A✗ i✓     | **50%**  |

Population:

```python
{"Hi": 100.0, "Xz": 0.0, "Hz": 50.0, "Ai": 50.0}
```

_(In a real run, getting "Hi" immediately is extremely unlikely — this is simplified for tracing purposes.)_

---

### Step 2: `selection`

Two highest fitness genes:

- Parent 1: `"Hi"` → fitness 100.0
- Parent 2: `"Hz"` → fitness 50.0 (or `"Ai"` — tied, depends on dict order)

```python
parent = {"Hi": 100.0, "Hz": 50.0}
```

---

### Step 3: `crossover`

Length = 2, cp = round(2/2) = **1**

```
Parent 1: "Hi"  → H | i
Parent 2: "Hz"  → H | z
                   ↑ cp = 1

Child 1: "H" + "z" = "Hz"  → fitness 50%
Child 2: "H" + "i" = "Hi"  → fitness 100%
```

```python
child = {"Hz": 50.0, "Hi": 100.0}
```

---

### Step 4: `mutation` (mutation_rate = 0.2)

For each character in each child, 20% chance of replacement.

Assume no mutation occurs (random values all > 0.2):

```python
mutant = {"Hz": 50.0, "Hi": 100.0}
```

---

### Step 5: Check improvement

```python
if bestfitness(parent) >= bestfitness(mutant):
    continue   # skip — no improvement
```

`bestfitness(parent)` = 100.0  
`bestfitness(mutant)` = 100.0  
100 >= 100 → **skip this iteration**, go back to crossover.

The loop continues until a mutant exceeds the current best, OR it hits 100% and breaks. Since 100% is already reached, eventually the `break` condition fires.

---

### Step 6: `display` output

```
Hi    100.0%    0:00:00.001234
```

---

## 4. The Main Loop — How It All Connects

```python
while 1:
    child  = crossover(parent, target, panjang_target)   # mate parents
    mutant = mutation(child, target, mutation_rate, panjang_target)  # mutate children

    if bestfitness(parent) >= bestfitness(mutant):
        continue   # no improvement → try again

    populasi = regeneration(mutant, populasi)  # replace weak with strong
    parent   = selection(populasi)             # pick new best two
    display(parent)                            # print progress

    if bestfitness(mutant) >= 100:
        break   # perfect match → done
```

**The key design decision:** The line `if bestfitness(parent) >= bestfitness(mutant): continue` ensures the population **only ever improves** — bad mutations are silently discarded and the loop retries.

### Sample Console Output

```
Target Word : Hello World!
Max Population : 10
Mutation Rate : 0.2
----------------------------------------------
The Best        Fitness     Time
----------------------------------------------
#Xk@z Wtrld?    25.0%       0:00:00.000512
H3llo World?    75.0%       0:00:00.002341
Hello Worle!    91.67%      0:00:00.008901
Hello World!    100.0%      0:00:00.021003
```

---

## 5. Practice Questions

### Conceptual Questions

**Q1.** Why does the program use a **dictionary** `{gene: fitness}` instead of a list? What advantage does this give?

**Q2.** The crossover point is always fixed at `round(length/2)`. What is a potential problem with this approach? How could it be improved?

**Q3.** The main loop has `if bestfitness(parent) >= bestfitness(mutant): continue`. What would happen if you **removed** this condition? Would the algorithm still work? Would it be faster or slower?

**Q4.** The mutation function can both **increase and decrease** fitness. Why is this acceptable and even desirable in a GA?

**Q5.** The `selection` function always picks the top 2. What is a potential long-term problem with always selecting the absolute best? (Hint: think about diversity.)

---

### Tracing / Calculation Questions

**Q6.** Given:

```
target = "Cat"
gene   = "Hat"
```

Trace through `calculate_fitness` step by step and give the final fitness value.

---

**Q7.** Given the population:

```python
{"AbC": 33.3, "xYz": 0.0, "aBc": 66.6, "ABC": 33.3}
```

Trace through `selection` and identify the two parents returned.

---

**Q8.** Given:

```
Parent 1: "abcdef"  (length 6, cp = 3)
Parent 2: "ABCDEF"
```

Trace through `crossover` and give:

- a) The value of `cp`
- b) Child 1
- c) Child 2

---

**Q9.** Given:

```
Child: "Hello"
mutation_rate = 0.2
Random values generated per character: [0.45, 0.10, 0.82, 0.19, 0.55]
Random replacement characters generated: ['Q', 'X', '-', 'P', '!']
```

Trace through `mutation` and give the final mutant string.

---

**Q10.** Given:

```python
populasi = {"abc": 10.0, "xyz": 90.0, "mno": 50.0, "pqr": 70.0}
mutant   = {"ABc": 60.0, "XYZ": 80.0}
```

Trace through `regeneration` and give the final population dictionary.

---

**Q11.** Given:

```python
parent = {"Hello": 100.0, "Hellz": 91.67}
```

What does `display(parent)` print? (Ignore the time component.)

---

### Scenario Questions

**Q12.** The program is run with `target = "AI"` and `max_population = 3`. The initial population is:

```python
{"Bz": 0.0, "AI": 100.0, "Az": 50.0}
```

- a) What do `selection` return?
- b) What does `crossover` produce? (cp = ?)
- c) Will the while loop's `continue` condition trigger on the first iteration? Why?

---

**Q13.** If `mutation_rate = 0.0`, what would happen to the algorithm? Would it still converge? Explain using your understanding of the crossover and mutation functions.

---

**Q14.** If `mutation_rate = 1.0`, what would happen? How does this affect the relationship between parents and their offspring?

---

## 6. Small Coding Questions

**C1.** The current `selection` function always picks the top 2. Rewrite it to use **tournament selection**: randomly pick 3 chromosomes, return the best one as parent 1, then repeat for parent 2.

```python
def selection_tournament(populasi):
    # Your code here
    pass
```

---

**C2.** The crossover point is fixed at the midpoint. Modify `crossover` to use a **random crossover point** instead.

```python
def crossover_random(parent, target, panjang_target):
    # Your code here
    pass
```

---

**C3.** The current `mutation` replaces a character with a completely random one. Write a new mutation function that **shifts the ASCII value by ±1** instead of replacing randomly.

```python
def mutation_shift(child, target, mutation_rate, panjang_target):
    # Your code here
    pass
```

---

**C4.** Add an **elitism** feature to `regeneration` — always keep the single best chromosome from the old population, regardless of what the mutants are.

```python
def regeneration_elitism(mutant, populasi):
    # Your code here
    pass
```

---

**C5.** Write a function `average_fitness(populasi)` that returns the average fitness of the entire population, and modify `display` to print it alongside the best fitness.

```python
def average_fitness(populasi):
    # Your code here
    pass
```

---

## Answers to Tracing Questions

### A6 — `calculate_fitness("Hat", "Cat")`

| Position | Target | Gene | Match? |
| -------- | ------ | ---- | ------ |
| 0        | C      | H    | ✗      |
| 1        | a      | a    | ✓      |
| 2        | t      | t    | ✓      |

Fitness = 2/3 × 100 = **66.67%**

---

### A7 — `selection`

```python
{"AbC": 33.3, "xYz": 0.0, "aBc": 66.6, "ABC": 33.3}
```

- Iteration 1: max = 66.6 → Parent 1 = `"aBc"`
- Remove `"aBc"`, Iteration 2: max = 33.3 → Parent 2 = `"AbC"` (or `"ABC"` — tied)

Result: `{"aBc": 66.6, "AbC": 33.3}`

---

### A8 — `crossover("abcdef", "ABCDEF")`

- a) cp = round(6/2) = **3**
- b) Child 1 = `"abc"` + `"DEF"` = **`"abcDEF"`**
- c) Child 2 = `"ABC"` + `"def"` = **`"ABCdef"`**

---

### A9 — `mutation("Hello", rate=0.2)`

Random values: [0.45, 0.10, 0.82, 0.19, 0.55]  
Trigger mutation if value ≤ 0.2:

| Pos | Char | Random | ≤ 0.2? | Result |
| --- | ---- | ------ | ------ | ------ |
| 0   | H    | 0.45   | ✗      | H      |
| 1   | e    | 0.10   | ✓      | X      |
| 2   | l    | 0.82   | ✗      | l      |
| 3   | l    | 0.19   | ✓      | P      |
| 4   | o    | 0.55   | ✗      | o      |

Mutant: **`"HXlPo"`**

---

### A10 — `regeneration`

Population: `{"abc": 10.0, "xyz": 90.0, "mno": 50.0, "pqr": 70.0}`  
Mutants: `{"ABc": 60.0, "XYZ": 80.0}`

- Remove worst: `"abc"` (10.0) → deleted
- Remove next worst: `"mno"` (50.0) → deleted
- Add mutants

Final population:

```python
{"xyz": 90.0, "pqr": 70.0, "ABc": 60.0, "XYZ": 80.0}
```

---

### A11 — `display`

```
Hello    100.0%    0:00:00.XXXXXX
```

`bestgen` returns `"Hello"` (fitness 100.0 > 91.67).

---

### A12 — Scenario

- a) Parent 1 = `"AI"` (100%), Parent 2 = `"Az"` (50%)
- b) cp = round(2/2) = 1
  - Child 1 = `"A"` + `"z"` = `"Az"` → 50%
  - Child 2 = `"A"` + `"I"` = `"AI"` → 100%
- c) `bestfitness(parent)` = 100%, `bestfitness(mutant)` ≤ 100% → condition `>=` triggers → **yes, `continue` fires** and the loop retries without updating the population.
