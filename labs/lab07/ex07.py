import numpy as np
import datetime

# =====================================================
# Original Helper Functions (unchanged)
# =====================================================

def calculate_fitness(gen, target, panjang_target):
    fitness = 0
    for i in range(panjang_target):
        if gen[i:i+1] == target[i:i+1]:
            fitness += 1
    fitness = fitness / panjang_target * 100
    return fitness

def create_gen(panjang_target):
    random_number = np.random.randint(32, 126, size=panjang_target)
    gen = ''.join([chr(i) for i in random_number])
    return gen

def create_population(target, max_population, panjang_target):
    populasi = {}
    for i in range(max_population):
        gen = create_gen(panjang_target)
        genfitness = calculate_fitness(gen, target, panjang_target)
        populasi[gen] = genfitness
    return populasi

def bestgen(parent):
    return max(parent, key=parent.get)

def bestfitness(parent):
    return parent[max(parent, key=parent.get)]

def regeneration(mutant, populasi):
    for i in range(len(mutant)):
        bad_gen = min(populasi, key=populasi.get)
        del populasi[bad_gen]
    populasi.update(mutant)
    return populasi


# =====================================================
# C1 — Tournament Selection
# =====================================================
# Original selection always picked the top 2 from the
# entire population. Tournament selection instead picks
# a random subset (k=3) and returns the best among them.
# This adds randomness and preserves population diversity.

def selection_tournament(populasi):
    """
    Select two parents using tournament selection.
    Each parent is chosen by: randomly sampling 3 chromosomes,
    then picking the fittest among those 3.

    Args:
        populasi (dict): Dictionary mapping genes to fitness scores

    Returns:
        dict: Dictionary with two selected parent genes and their fitness scores
    """
    parent = {}

    for _ in range(2):
        # Randomly sample 3 chromosomes from the population (keys only)
        tournament_genes = np.random.choice(list(populasi.keys()), size=3, replace=False)

        # Build a temporary dict for just those 3 competitors
        tournament = {gene: populasi[gene] for gene in tournament_genes}

        # Pick the winner (highest fitness in the tournament)
        winner = max(tournament, key=lambda gene: tournament[gene])

        # Only add if not already selected (avoid duplicate parents)
        if winner not in parent:
            parent[winner] = populasi[winner]
        else:
            # If duplicate, pick the second best from the tournament
            del tournament[winner]
            runner_up = max(tournament, key=lambda gene: tournament[gene])
            parent[runner_up] = populasi[runner_up]

    return parent


# =====================================================
# C2 — Crossover with Random Cut Point
# =====================================================
# Original crossover always cut at the midpoint (length/2).
# This version picks a random cut point between position 1
# and length-1, allowing more diverse offspring combinations.

def crossover_random(parent, target, panjang_target):
    """
    Perform one-point crossover with a randomly chosen cut point.

    Args:
        parent (dict): Dictionary with two parent genes and fitness scores
        target (str): Target string
        panjang_target (int): Length of target string

    Returns:
        dict: Dictionary with two child genes and their fitness scores
    """
    child = {}
    gene_length = len(list(parent)[0])

    # Random cut point between position 1 and length-1
    # (avoid 0 or full length — those produce clones of parents)
    cp = np.random.randint(1, gene_length)

    for i in range(2):
        # Same logic as original but with random cp
        gen = list(parent)[i][:cp] + list(parent)[1 - i][cp:]
        genfitness = calculate_fitness(gen, target, panjang_target)
        child[gen] = genfitness

    return child


# =====================================================
# C3 — Shift Mutation (±1 ASCII)
# =====================================================
# Original mutation replaced a character with a completely
# random ASCII character anywhere in the 32-125 range.
# Shift mutation instead nudges the character by just ±1,
# making smaller, more controlled changes to the gene.
# This is a finer-grained exploration of the search space.

def mutation_shift(child, target, mutation_rate, panjang_target):
    """
    Apply shift mutation: each character has a mutation_rate chance
    of being shifted by +1 or -1 in ASCII value (clamped to 32-125).

    Args:
        child (dict): Dictionary with child genes and fitness scores
        target (str): Target string
        mutation_rate (float): Probability of mutation per character (0-1)
        panjang_target (int): Length of target string

    Returns:
        dict: Dictionary with mutated genes and their fitness scores
    """
    mutant = {}

    for i in range(len(child)):
        data = list(list(child)[i])  # Convert gene string to char list

        for j in range(len(data)):
            if np.random.rand(1) <= mutation_rate:
                current_ascii = ord(data[j])

                # Randomly choose to shift +1 or -1
                shift = np.random.choice([-1, 1])
                new_ascii = current_ascii + shift

                # Clamp to valid printable ASCII range (32-125)
                new_ascii = max(32, min(125, new_ascii))

                data[j] = chr(new_ascii)

        gen = ''.join(data)
        genfitness = calculate_fitness(gen, target, panjang_target)
        mutant[gen] = genfitness

    return mutant


# =====================================================
# C4 — Regeneration with Elitism
# =====================================================
# Original regeneration replaced the worst chromosomes
# with mutants, but the best chromosome could still be
# lost if it happened to be displaced.
# Elitism guarantees the single best chromosome always
# survives into the next generation unchanged.

def regeneration_elitism(mutant, populasi):
    """
    Replace worst chromosomes with mutants, but always preserve
    the single best chromosome from the current population (elitism).

    Args:
        mutant (dict): Dictionary with mutant genes and fitness scores
        populasi (dict): Current population dictionary

    Returns:
        dict: Updated population with elitism applied
    """
    # Save the elite (best chromosome) before any deletions
    elite_gene = max(populasi, key=populasi.get)
    elite_fitness = populasi[elite_gene]

    # Remove worst genes (same count as number of mutants)
    for i in range(len(mutant)):
        bad_gen = min(populasi, key=populasi.get)
        del populasi[bad_gen]

    # Add mutants to population
    populasi.update(mutant)

    # Re-insert elite if it was accidentally removed
    if elite_gene not in populasi:
        # Remove the worst again to make room for the elite
        bad_gen = min(populasi, key=populasi.get)
        del populasi[bad_gen]
        populasi[elite_gene] = elite_fitness

    return populasi


# =====================================================
# C5 — Average Fitness + Updated Display
# =====================================================
# average_fitness computes the mean fitness across all
# chromosomes in the population.
# The updated display prints both the best fitness AND
# the average fitness so you can track overall improvement.

def average_fitness(populasi):
    """
    Calculate the average fitness of the entire population.

    Args:
        populasi (dict): Dictionary mapping genes to fitness scores

    Returns:
        float: Average fitness value rounded to 2 decimal places
    """
    total = sum(populasi.values())
    avg = total / len(populasi)
    return round(avg, 2)


def display(parent, populasi, startTime):
    """
    Display current best gene, its fitness, average population fitness,
    and elapsed time.

    Args:
        parent (dict): Dictionary with parent genes
        populasi (dict): Full population dictionary
        startTime (datetime): Algorithm start time
    """
    timeDiff = datetime.datetime.now() - startTime
    best  = bestgen(parent)
    bfit  = round(bestfitness(parent), 2)
    avg   = average_fitness(populasi)
    print('{}\tBest: {}%\tAvg: {}%\t{}'.format(best, bfit, avg, timeDiff))


# =====================================================
# Demo — Run All 5 Functions Together
# =====================================================

if __name__ == "__main__":
    target         = 'Hello World!'
    max_population = 10
    mutation_rate  = 0.2
    panjang_target = len(target)
    startTime      = datetime.datetime.now()

    print('Target       :', target)
    print('Population   :', max_population)
    print('Mutation Rate:', mutation_rate)
    print('--------------------------------------------------------------')
    print('{}\t\t\tBest\t\tAvg\t\tTime'.format('The Best Gene'))
    print('--------------------------------------------------------------')

    # Initialize population
    populasi = create_population(target, max_population, panjang_target)

    # C1 — Tournament selection for initial parents
    parent = selection_tournament(populasi)
    display(parent, populasi, startTime)

    while True:
        # C2 — Random crossover point
        child = crossover_random(parent, target, panjang_target)

        # C3 — Shift mutation
        mutant = mutation_shift(child, target, float(mutation_rate), panjang_target)

        # Skip if no improvement
        if bestfitness(parent) >= bestfitness(mutant):
            continue

        # C4 — Elitism regeneration
        populasi = regeneration_elitism(mutant, populasi)

        # C1 — Tournament selection for next generation
        parent = selection_tournament(populasi)

        # C5 — Display with average fitness
        display(parent, populasi, startTime)

        if bestfitness(mutant) >= 100:
            break

    print('--------------------------------------------------------------')
    print('Done! Target reached:', bestgen(parent))