require "./lib/statistics_calculator"
require "./lib/utility"
class GeneticAlgorithm
  include StatisticsCalculator
  include Utility

  def initialize(maxima_indices, maxima_values, data_length, user_defined_initial_data, possible_values)
    @maxima_indices = maxima_indices
    @maxima_values = maxima_values
    @data_length = data_length
    @user_defined_initial_data = user_defined_initial_data
    @possible_values = possible_values
    @population_size = 50
    @mutation_rate = 0.1
    @generations = 100
  end

  def run
    population = generate_initial_population


    @generations.times do |generation_index|
      fitness_scores = calculate_fitness(population)
      parents = select_parents(population, fitness_scores)
      children = crossover(parents, population)
      children = mutate(children)
      population = children
      p "current generation：#{generation_index}"
    end

    fitness_values = calculate_fitness(population)
    min_value = fitness_values.min
    min_value_indices = []
    fitness_values.each_index do |i|
      min_value_indices << i if fitness_values[i] == min_value
    end
    best_individuals = min_value_indices.map { |index| population[index] }
    p best_individuals
    acf = round_array(autocorrelation_coefficient(best_individuals[0]))
    p acf
    p max_peak_indexes(acf)
  end

  private

  def generate_initial_population
    population = []

    @population_size.times do
      individual = @user_defined_initial_data.clone
      remaining_length = @data_length - individual.length
      remaining_length.times { individual << @possible_values.sample }
      population << individual
    end
    population
  end

  def calculate_fitness(population)
    fitness_values = []

    population.each do |individual|
      acf = round_array(autocorrelation_coefficient(individual))
      fitness_values << calculate_score(acf)
    end

    fitness_values
  end

  def calculate_score(acf)
    diffs = []
    @maxima_indices.each_with_index do |index, i|
      diff = (acf[index] - @maxima_values[i]).abs
      diffs << diff
    end

    diffs.sum
  end


  def select_parents(population, fitness_scores)
    parents = []

    ranked_population = population.zip(fitness_scores).sort_by { |_, fitness| fitness }
    selection_probabilities = calculate_selection_probabilities(ranked_population.length)    
    num_parents = 2

    num_parents.times do
      selected_index = select_individual(selection_probabilities)
      parents << ranked_population[selected_index][0]
    end

    parents
  end

  def select_individual(selection_probabilities)
    random_value = rand
    cumulative_probability = 0.0
    selected_index = 0

    selection_probabilities.each_with_index do |probability, index|
      cumulative_probability += probability
      if random_value <= cumulative_probability
        selected_index = index
        break
      end
    end

    selected_index
  end

  def calculate_selection_probabilities(population_size)
    selection_probabilities = (1..population_size).map { |rank| 1.0 / rank }
    total_probability = selection_probabilities.sum
    normalized_probabilities = selection_probabilities.map { |prob| prob / total_probability }
    
    normalized_probabilities
  end
  def crossover(parents, population)
    children = []
  
    (population.length / 2).times do
      crossover_point = rand(1..(parents[0].length - 1))
  
      child1 = parents[0][0...crossover_point] + parents[1][crossover_point..-1]
      child2 = parents[1][0...crossover_point] + parents[0][crossover_point..-1]
  
      children << child1
      children << child2
    end
  
    if population.length.odd?
      children << parents.last
    end
  
    children
  end

  def mutate(children)
    mutated_children = children.map do |child|
      mutation_point = rand(child.length)
      mutated_value = rand(1..4)
      child[mutation_point] = mutated_value
      child
    end

    mutated_children
  end
end