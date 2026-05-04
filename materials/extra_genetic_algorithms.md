# Comp 408 — Genetic Algorithms Study Guide

> **Lecture 05 | Local Search Algorithms → Genetic Algorithms**

---

## Table of Contents

1. [Big Picture: Why Genetic Algorithms?](#1-big-picture-why-genetic-algorithms)
2. [Core Terminology](#2-core-terminology)
3. [The GA Lifecycle — Step by Step](#3-the-ga-lifecycle--step-by-step)
4. [Chromosome Representation](#4-chromosome-representation)
5. [Fitness Function](#5-fitness-function)
6. [Selection](#6-selection)
7. [Crossover (Recombination)](#7-crossover-recombination)
8. [Mutation](#8-mutation)
9. [Deletion / Survivor Selection](#9-deletion--survivor-selection)
10. [Full Worked Example — 4-Queens Problem](#10-full-worked-example--4-queens-problem)
11. [GA vs. Other Local Search Algorithms](#11-ga-vs-other-local-search-algorithms)
12. [Practice Problems](#12-practice-problems)
13. [Quick-Reference Cheat Sheet](#13-quick-reference-cheat-sheet)

---

## 1. Big Picture: Why Genetic Algorithms?

### Context in Local Search

Regular search algorithms (BFS, DFS, A\*) keep many paths in memory and explore the space systematically. **Local search algorithms** instead work with a _single current state_ (or a small population of states) and move only to neighboring states. They use very little memory and can operate in huge or even continuous spaces.

Genetic Algorithms (GAs) are a **population-based** local search method that mimic biological evolution. Instead of one state, they maintain an entire population of candidate solutions and improve them generation by generation.

### When to Use GAs

GAs shine when:

- The search space is large and complex (many local optima).
- You need a _good enough_ solution fast, not necessarily the perfect one.
- The problem is an **optimization problem** — find the state that maximizes (or minimizes) an objective function.
- Traditional algorithmic approaches are too slow.

**Classic GA problems:** N-Queens, Traveling Salesman, scheduling, neural network weight optimization, game AI.

---

## 2. Core Terminology

| Term                  | Definition                                                 | Analogy                                                |
| --------------------- | ---------------------------------------------------------- | ------------------------------------------------------ |
| **Population**        | The full set of current candidate solutions                | A generation of organisms                              |
| **Chromosome**        | A single candidate solution                                | One individual organism                                |
| **Gene**              | One position (element) in a chromosome                     | A single trait                                         |
| **Allele**            | The _value_ a gene holds                                   | The specific value of a trait (e.g., eye color = blue) |
| **Genotype**          | The solution in the _computation space_ (how it's encoded) | DNA sequence                                           |
| **Phenotype**         | The solution in the _real-world space_ (what it means)     | The actual organism                                    |
| **Fitness Function**  | A function that scores how good a chromosome is            | Natural selection pressure                             |
| **Genetic Operators** | Crossover, Mutation, Selection                             | Reproduction mechanisms                                |

### Genotype vs. Phenotype — A Concrete Example

**Problem:** Knapsack — pick which items to put in a bag.

- **Phenotype:** {Item 2, Item 5, Item 7} — the actual list of chosen items.
- **Genotype:** `01001010` — a binary string where position `i = 1` means item `i` is picked.

The GA works in the _genotype_ space. When we evaluate fitness, we _decode_ the genotype back to the phenotype.

---

## 3. The GA Lifecycle — Step by Step

```
GA()
  initialize population P(0)
  evaluate fitness of all chromosomes in P(0)

  while (stopping condition not met) do:
    select parents from P(t)
    apply crossover  → produce offspring
    apply mutation   → modify offspring
    evaluate fitness of offspring
    select survivors → form P(t+1)
    t = t + 1

  return best chromosome found
```

### The Cycle Visualized

```
Initial Population
      ↓
  Evaluation (Fitness)
      ↓
  Selection (Parents)
      ↓
  Crossover (Children)
      ↓
  Mutation (Modified Children)
      ↓
  Evaluation
      ↓
  Survivor Selection → New Population
      ↓ (repeat)
```

---

## 4. Chromosome Representation

A chromosome can be encoded in multiple ways depending on the problem:

| Representation    | Example             | Suitable For                       |
| ----------------- | ------------------- | ---------------------------------- |
| **Binary string** | `10110010`          | Classic GA problems, combinatorial |
| **Real numbers**  | `43.2, -33.1, 89.2` | Continuous optimization            |
| **Permutation**   | `E3, E7, E1, E11`   | Ordering problems (TSP)            |
| **Rules**         | `R1, R2, R22`       | Rule-based systems                 |

### Example — Encoding the 8-Queens Problem

Each column of the board is a gene. The allele is the _row_ number where the queen sits.

```
Board column:  1  2  3  4  5  6  7  8
Queen row:     2  4  7  4  8  5  5  2
Chromosome:  [ 2  4  7  4  8  5  5  2 ]
```

This means queen in column 1 is at row 2, queen in column 2 is at row 4, etc.

---

## 5. Fitness Function

The fitness function evaluates **how good** a chromosome is. It must:

- Return a numerical score.
- Be computable quickly (it runs every generation for every chromosome).
- Reflect the actual goal of the problem.

### 8-Queens Fitness Function

> **Fitness = number of non-attacking queen pairs**
>
> - Minimum possible = 0 (all queens attacking each other — worst)
> - Maximum possible = 8 × 7 / 2 = **28** (no conflicts — the goal)

**Example calculation:**

Chromosome: `[2, 4, 7, 4, 8, 5, 5, 2]`

Count every pair of queens NOT attacking each other. If the result is 24, the fitness is 24/28 ≈ 86%.

### General Formula for Proportional Selection Probability

$$P(x_i) = \frac{f(x_i)}{\sum_j f(x_j)}$$

**Example from lecture:**

| Chromosome | Fitness (non-attacking pairs) | Selection Probability |
| ---------- | ----------------------------- | --------------------- |
| `24748552` | 24                            | 24/78 = **31%**       |
| `32752411` | 23                            | 23/78 = **29%**       |
| `24415124` | 20                            | 20/78 = **26%**       |
| `32543213` | 11                            | 11/78 = **14%**       |
| **Total**  | **78**                        | **100%**              |

Chromosomes with higher fitness are more likely to be selected as parents.

---

## 6. Selection

Selection picks which chromosomes become parents for the next generation.

### Types of Selection

**1. Random Selection**
Parents are chosen uniformly at random from the population, ignoring fitness. Simple but doesn't favor good solutions.

**2. Proportional Selection (Roulette Wheel)**
Each chromosome is given a slice of a "roulette wheel" proportional to its fitness. Better chromosomes have bigger slices and are more likely to be picked.

```
Chromosome A: fitness 24 → 31% of the wheel
Chromosome B: fitness 23 → 29% of the wheel
Chromosome C: fitness 20 → 26% of the wheel
Chromosome D: fitness 11 → 14% of the wheel
```

Spin the wheel twice → get two parents. Repeat to fill the mating pool.

**3. Tournament Selection** _(common in practice)_
Pick `k` random chromosomes, the fittest one among them becomes a parent.

---

## 7. Crossover (Recombination)

Crossover takes two parent chromosomes and combines their genetic material to produce one or two offspring. This is the **primary search operator** in GAs.

### One-Point Crossover

A random cut point is chosen. The tail of each parent is swapped.

```
Parents:
  P1 = [ 0 0 1 1 0 | 1 1 0 ]
  P2 = [ 1 1 0 1 1 | 0 1 0 ]
                   ↑ cut point (position 5)

Offspring:
  C1 = [ 0 0 1 1 0 | 0 1 0 ]   (P1 head + P2 tail)
  C2 = [ 1 1 0 1 1 | 1 1 0 ]   (P2 head + P1 tail)
```

### Two-Point Crossover

Two cut points are chosen. The segment _between_ them is swapped.

```
Parents:
  P1 = [ 0 0 | 1 1 0 1 | 1 0 ]
  P2 = [ 1 1 | 0 1 1 0 | 1 0 ]
         ↑               ↑ cut points

Offspring:
  C1 = [ 0 0 | 0 1 1 0 | 1 0 ]
  C2 = [ 1 1 | 1 1 0 1 | 1 0 ]
```

### Uniform Crossover

Each bit position is independently assigned to C1 or C2 from a random coin flip.

```
Parents:
  P1 = [ 0 0 1 1 0 1 1 0 ]
  P2 = [ 1 1 0 1 1 0 1 0 ]
Mask:  [ 0 1 0 1 1 0 1 0 ]   ← 0 = take from P1, 1 = take from P2

  C1 = [ 0 1 1 1 1 1 1 0 ]
  C2 = [ 1 0 0 1 0 0 1 0 ]
```

### Summary Table

| Method    | Cut Points | Swapped Part                      |
| --------- | ---------- | --------------------------------- |
| One-point | 1          | Everything after the cut          |
| Two-point | 2          | Segment between the two cuts      |
| Uniform   | None       | Bit-by-bit based on a random mask |

**Why crossover matters:** It lets the GA combine _partial solutions_ (schemata) from different chromosomes — potentially discovering better solutions faster than random search.

---

## 8. Mutation

Mutation randomly alters one or more genes in an offspring chromosome. It's applied with a **small probability** (e.g., 0.01 per gene).

### Binary Mutation (Bit-Flip)

```
Before: [ 1 0 1 1 0 1 1 0 ]
                 ↑ mutated
After:  [ 1 0 1 1 1 1 1 0 ]
```

Gene at position 5 flipped from `0` → `1`.

### Real-Valued Mutation

```
Before: [ 1.38  -69.4  326.44  0.1 ]
                  ↑ mutated
After:  [ 1.38  -67.5  326.44  0.1 ]
```

A small random value is added to the selected gene.

### Why Mutation Matters

1. **Maintains diversity** — prevents the whole population from converging to the same (potentially suboptimal) solution.
2. **Escapes local optima** — introduces novel gene values that crossover alone cannot create.
3. **Restores lost information** — if a useful allele was eliminated from the population, mutation can reintroduce it.

> **Key rule:** Mutation probability must be small. Too much mutation → random search. Too little → premature convergence.

---

## 9. Deletion / Survivor Selection

After producing offspring, we need to decide who survives into the next generation.

### Generational GA

The entire old population is replaced by the offspring. Clean slate each generation.

### Steady-State GA

Only a few of the worst members are replaced each generation. The rest carry over. Preserves good solutions longer.

---

## 10. Full Worked Example — 4-Queens Problem

We'll run **one full GA generation** on a simplified 4-Queens problem (4×4 board). Each chromosome is a list of 4 numbers — the row position of the queen in each column.

### Step 1: Initial Population

| ID  | Chromosome     | Fitness (non-attacking pairs, max = 6) |
| --- | -------------- | -------------------------------------- |
| A   | `[2, 4, 1, 3]` | 6 ✓ (perfect!)                         |
| B   | `[3, 1, 4, 2]` | 6 ✓ (perfect!)                         |
| C   | `[1, 3, 1, 3]` | 2                                      |
| D   | `[2, 2, 3, 1]` | 3                                      |

> Total fitness = 6 + 6 + 2 + 3 = **17**

### Step 2: Calculate Selection Probabilities

| ID  | Fitness | P(selection)   |
| --- | ------- | -------------- |
| A   | 6       | 6/17 = **35%** |
| B   | 6       | 6/17 = **35%** |
| C   | 2       | 2/17 = **12%** |
| D   | 3       | 3/17 = **18%** |

Roulette wheel spin selects parents **A** and **B** (highest probability).

### Step 3: One-Point Crossover (cut after position 2)

```
Parent A: [ 2  4 | 1  3 ]
Parent B: [ 3  1 | 4  2 ]
                ↑ cut

Child C1: [ 2  4 | 4  2 ]
Child C2: [ 3  1 | 1  3 ]
```

### Step 4: Mutation (flip one gene in C1)

```
C1 before: [ 2  4  4  2 ]
                 ↑ mutate position 2: 4 → 3
C1 after:  [ 2  3  4  2 ]
```

### Step 5: Evaluate New Offspring

| Chromosome          | Non-attacking pairs |
| ------------------- | ------------------- |
| C1 = `[2, 3, 4, 2]` | 4                   |
| C2 = `[3, 1, 1, 3]` | 3                   |

These replace C and D (the weakest members) in the next generation.

### New Population (Generation 2)

| ID  | Chromosome     | Fitness |
| --- | -------------- | ------- |
| A   | `[2, 4, 1, 3]` | 6       |
| B   | `[3, 1, 4, 2]` | 6       |
| C1  | `[2, 3, 4, 2]` | 4       |
| C2  | `[3, 1, 1, 3]` | 3       |

Average fitness improved from 17/4 = 4.25 → 19/4 = **4.75**. The population is getting better!

---

## 11. GA vs. Other Local Search Algorithms

| Algorithm             | Memory       | Population | Handles Local Optima?       | Key Mechanism                |
| --------------------- | ------------ | ---------- | --------------------------- | ---------------------------- |
| Hill Climbing         | Single state | 1          | ✗ — gets stuck              | Always move to best neighbor |
| Simulated Annealing   | Single state | 1          | ✓ — probabilistic bad moves | Temperature-based acceptance |
| Local Beam Search     | k states     | k          | Partial — k paths           | Keep k best successors       |
| **Genetic Algorithm** | Population   | N          | ✓ — crossover + mutation    | Evolutionary operators       |

**GAs vs. Hill Climbing:** Hill climbing always moves upward and gets stuck at local optima. GAs explore multiple regions simultaneously (via their population) and can combine partial solutions from different areas.

**GAs vs. Simulated Annealing:** SA escapes local optima by accepting worse solutions with decreasing probability. GAs escape local optima through crossover (mixing good partial solutions) and mutation (random exploration).

**GA as parallel hill climbing:** The lecture notes describe GAs as "simultaneous, parallel hill climbing" — each chromosome is essentially a hill climber, but they share information through crossover.

---

## 12. Practice Problems

### Conceptual Questions

**Q1.** What is the difference between a gene and an allele? Give an example using the 8-queens encoding.

**Q2.** A GA is run on a population of 5 chromosomes with fitness values 10, 5, 20, 15, 10. Calculate the selection probability of each chromosome under proportional (roulette wheel) selection. Which chromosome has the highest chance of being selected?

**Q3.** Explain why mutation probability should be kept small. What happens if it's too high? What if it's too low?

**Q4.** Compare one-point crossover and uniform crossover. In what type of problem might uniform crossover be preferred?

**Q5.** What is the difference between Generational GA and Steady-State GA? What are the trade-offs?

---

### Calculation Problems

**Q6. Crossover Practice**

Given:

```
P1 = [ 1 0 1 1 0 0 1 0 ]
P2 = [ 0 1 0 0 1 1 0 1 ]
```

Perform:
a) One-point crossover at position 4.
b) Two-point crossover at positions 2 and 6.

**Q7. Fitness and Selection**

Four chromosomes represent solutions to a maximization problem with fitness values: A=18, B=12, C=6, D=24.

a) Calculate the total fitness and selection probability for each chromosome.  
b) If we spin the roulette wheel 4 times, how many times do you expect chromosome D to be selected?

**Q8. Mutation**

Apply bit-flip mutation to position 3 of the following chromosome:

```
[ 1  1  0  0  1  1  0  1 ]
```

What is the result?

---

### Scenario Problems

**Q9.** You are designing a GA to solve a scheduling problem — assigning 8 tasks to 4 workers, where each task must be assigned to exactly one worker.

a) Propose a chromosome encoding for this problem.  
b) Design a fitness function. What would you want to maximize/minimize?  
c) Would standard one-point crossover work for your encoding? Why or why not?

**Q10.** A GA for the 8-queens problem runs for 100 generations but the best fitness is stuck at 24 (out of 28). Suggest **two** modifications you could make to help the GA escape this plateau and potentially find the optimal solution.

**Q11 (Essay).** Compare the Genetic Algorithm with Simulated Annealing as approaches to solving the N-Queens problem. Discuss: population vs. single state, how each handles local optima, computational cost, and which you would choose and why.

---

### Tracing Problems

**Q12.** Trace one full GA generation given:

Initial Population:

```
A = [ 1  0  1  0 ]  fitness = 3
B = [ 0  1  0  1 ]  fitness = 1
C = [ 1  1  0  0 ]  fitness = 2
D = [ 0  0  1  1 ]  fitness = 2
```

a) Calculate selection probabilities.  
b) Select parents A and C using proportional selection (assume they were selected).  
c) Apply one-point crossover at position 2.  
d) Apply bit-flip mutation to position 4 of each offspring.  
e) What is the fitness of the new offspring (assume fitness = number of 1s)?

---

## 13. Quick-Reference Cheat Sheet

```
╔══════════════════════════════════════════════════════════════╗
║              GENETIC ALGORITHM — QUICK REFERENCE             ║
╠══════════════════════════════════════════════════════════════╣
║  KEY TERMS                                                   ║
║  • Chromosome  = one candidate solution                      ║
║  • Gene        = one position in chromosome                  ║
║  • Allele      = value of a gene                             ║
║  • Fitness     = score of how good a chromosome is           ║
╠══════════════════════════════════════════════════════════════╣
║  SELECTION PROBABILITY                                       ║
║  P(xi) = f(xi) / Σf(xj)                                     ║
╠══════════════════════════════════════════════════════════════╣
║  CROSSOVER TYPES                                             ║
║  One-point  → swap tail after one cut point                  ║
║  Two-point  → swap segment between two cut points            ║
║  Uniform    → swap bit-by-bit using a random mask            ║
╠══════════════════════════════════════════════════════════════╣
║  MUTATION                                                    ║
║  Binary     → flip one bit (0→1 or 1→0)                     ║
║  Real       → add small random value to a gene               ║
║  Purpose    → diversity, escape local optima                 ║
╠══════════════════════════════════════════════════════════════╣
║  8-QUEENS FITNESS                                            ║
║  Max = 8 × 7 / 2 = 28 (non-attacking pairs)                 ║
║  Goal: maximize fitness                                      ║
╠══════════════════════════════════════════════════════════════╣
║  GA LOOP                                                     ║
║  Init → Evaluate → Select → Crossover → Mutate              ║
║       → Evaluate → Survive → Repeat                         ║
╚══════════════════════════════════════════════════════════════╝
```

---

_Study Guide based on Comp 408 Lecture 05 and the Tutorialspoint Genetic Algorithms Tutorial._
