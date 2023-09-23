require "./lib/statistics_calculator"
require "./lib/utility"

class Main
  include StatisticsCalculator
  include Utility

  def run
    maxima_indices = [0, 5, 8, 13, 16, 21, 24, 29, 32]
    maxima_values = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    data_length = 37
    user_defined_initial_data = [1, 4]
    possible_values = (1..4).to_a 
    optimal_data = user_defined_initial_data
    
    remaining_length = data_length - optimal_data.length
    maxima_indices.each_with_index do |_, maxima_incidies_index|
    
      current_optimal_data = []
    
      current_required_length = maxima_indices[maxima_incidies_index + 2]
      if current_required_length.nil?
        current_required_length = data_length
      end
      current_remain_length = current_required_length - optimal_data.length
    
      optimal_acf_fit_score = Float::INFINITY
    
      possible_patterns = possible_values.repeated_permutation(current_remain_length).to_a
      possible_patterns.each do |pattern|
        full_pattern = optimal_data + pattern
        acf = round_array(autocorrelation_coefficient(full_pattern))
    
        fit_score = 0
        maxima_indices[0..maxima_incidies_index + 1].each_with_index do |local_maxima_index_value, local_maxima_incidies_index|
    
          fit_score += (acf[local_maxima_index_value] - maxima_values[local_maxima_incidies_index]).abs
        end
      
        if fit_score < optimal_acf_fit_score
          current_optimal_data = full_pattern
          optimal_acf_fit_score = fit_score
        end
      end
      optimal_data = current_optimal_data
    end

    p "optimal_data"
    p optimal_data
    
    p round_array(autocorrelation_coefficient(optimal_data))
    
    
  end
end

main = Main.new
main.run