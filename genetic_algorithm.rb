require "./lib/genetic_algorithm"
maxima_indices = [0, 5, 8, 13, 16, 21, 24, 29, 32]
data_length = 37
user_defined_initial_data = [1, 4]
maxima_values = Array.new(maxima_indices.length, 1.0)
user_defined_initial_data = [1,2,3,4]
possible_values = (1..4).to_a

genetic_algorithm = GeneticAlgorithm.new(maxima_indices, maxima_values, data_length, user_defined_initial_data, possible_values)
result = genetic_algorithm.run

puts "Optimal Data: #{result}"