require "./lib/genetic_algorithm"
require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility
original = Array.new(500){ |e| rand(1..12) }
p original
original_autocorrelation = round_array(autocorrelation_coefficient(original))
p original_autocorrelation
data_length = original_autocorrelation.length
user_defined_initial_data = [1, 3, 5]
possible_values = (1..12).to_a

genetic_algorithm = GeneticAlgorithm.new(original_autocorrelation, data_length, user_defined_initial_data, possible_values)
result = genetic_algorithm.run

