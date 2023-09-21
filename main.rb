require "./lib/statistics_calculator"

statistics = StatisticsCalculator.new

maxima_indices = [0, 4]
maxima_values = [1.0, 1.0]
data_length = 8
possible_values = (1..3).to_a
optimal_data = []
optimal_acf = []
optimal_acf_fit_score = nil

possible_patterns = possible_values.repeated_permutation(data_length).to_a
possible_patterns.each do |pattern|
  acf = statistics.rounding_array(statistics.autocorrelation_coefficient(pattern))
  fit_score = 0
  maxima_indices.each_with_index do |index, i|
    fit_score += (acf[index] - maxima_values[i]).abs
  end

  if optimal_acf.empty? || fit_score < optimal_acf_fit_score
    optimal_data = pattern
    optimal_acf = acf
    optimal_acf_fit_score = fit_score
  end
end

p "optimal_data"
p optimal_data
p "optimal_acf"
p optimal_acf