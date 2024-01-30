require "./lib/statistics_calculator"
require "./lib/utility"

class AllPattern
  include StatisticsCalculator
  include Utility

  def run
    data_length = 20
    accumulation_intervals = 0
    maxima_indices = [accumulation_intervals]
    while accumulation_intervals < data_length
      interval = rand(3..5).to_i
      accumulation_intervals += interval
      maxima_indices << accumulation_intervals
    end
    p 'maxima_indices'
    p maxima_indices
    data_length = accumulation_intervals + 1
    p 'data_length'
    p data_length
    maxima_values = Array.new(maxima_indices.length, 1.0)
    user_defined_initial_data = [1,2,3,4]
    optimal_data = user_defined_initial_data
    possible_values = (1..4).to_a    
    remaining_length = data_length - optimal_data.length
    maxima_indices.each_with_index do |_, maxima_incidies_index|
      p "#{maxima_incidies_index}/#{maxima_indices.length - 1}"
    
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
        acf = round_array(compare_original_and_shifted_data(full_pattern) {|d1, d2| dtw_distance(d1, d2)})
    
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
    p 'autocorrelation_coefficient'
    p round_array(autocorrelation_coefficient(optimal_data))
    
  end
end

all_pattern = AllPattern.new
all_pattern.run