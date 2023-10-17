require "./lib/statistics_calculator"
require "./lib/utility"
class GeneticAlgorithm
  include StatisticsCalculator
  include Utility

  def initialize(target_acf, data_length, user_defined_initial_data, possible_values)
    @target_acf = target_acf
    @data_length = data_length
    @user_defined_initial_data = user_defined_initial_data
    @possible_values = possible_values
    @population_size = 100
    @mutation_rate = 0.1
    @generations = 10
  end

  def run
    population = generate_initial_population

    @generations.times do |generation_index|
      fitness_scores = calculate_fitness(population)
      parents = select_parents(population, fitness_scores)
      children = crossover(parents, population)
      children = mutate(children)
      population = children
      p "current generation：#{generation_index} time:#{Time.now}"
    end

    fitness_values = calculate_fitness(population)
    min_value = fitness_values.min
    min_value_indices = []
    fitness_values.each_index do |i|
      min_value_indices << i if fitness_values[i] == min_value
    end
    best_individuals = min_value_indices.map { |index| population[index] }
    unique_best_individuals = best_individuals.uniq
    acf = round_array(autocorrelation_coefficient(unique_best_individuals[0]))
    p unique_best_individuals
    p acf
  end

  private

  def generate_initial_population
    population = []
    @population_size.times do
      individual = @user_defined_initial_data.clone
      remaining_length = @data_length - individual.length
      individual.concat(Array.new(500){ |e| rand(1..12) })
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
    @target_acf.each_with_index do |target_acf_element, index|
      diff = (acf[index] - target_acf_element).abs
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
      children << parents.last.clone # user_defined_initial_data の部分を保持するために clone を使用
    end
  
    children
  end

  def mutate(children)
    mutated_children = children.map do |child|
      mutation_point = rand(@user_defined_initial_data.length...child.length)  # user_defined_initial_dataより後ろの部分をmutateする
      mutated_value = rand(@possible_values[0]..@possible_values[-1])
      child_copy = child.dup  # 元のデータを変更しないようにコピー
      child_copy[mutation_point] = mutated_value
      child_copy
    end
  
    mutated_children
  end
end