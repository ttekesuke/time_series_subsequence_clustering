require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

class DecideGradually
  def run
    original = [1,3,5,1,3,5,1,1,1,1,1,3,5,1,1,3,5,1,1,1,1]
    original_autocorrelation = round_array(compare_original_and_shifted_data(original) {|d1, d2| correlation_coefficient(d1, d2)})
    result = [1, 3, 5]
    possible_values = (1..5).to_a   
    (result.length - 1).upto(original.length - 2) do |counter|
      shortest_euclidean_distance = Float::INFINITY
      optimal_value = nil
      possible_values.each do |possible|
        acf = compare_original_and_shifted_data(result + [possible]) {|d1, d2| correlation_coefficient(d1, d2)}
        acf.delete_at(-1) 
        euclidean_distance = euclidean_distance(original_autocorrelation[0..counter], acf)
        if shortest_euclidean_distance > euclidean_distance
          shortest_euclidean_distance = euclidean_distance
          optimal_value = possible
        end
      end
      result.push(optimal_value)
    end
    result_autocorrelation = round_array(compare_original_and_shifted_data(result) {|d1, d2| correlation_coefficient(d1, d2)})
    p original
    p result
    p original_autocorrelation
    p result_autocorrelation
  end
end

main = DecideGradually.new
main.run