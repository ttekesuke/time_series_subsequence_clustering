require "./lib/fft"
require "./lib/utility"
require "./lib/statistics_calculator"
include Fft
include Utility
include StatisticsCalculator

class DecideGraduallyFft
  def run
    possible_range = (1..12)
    possible_values = possible_range.to_a 
    result = [1,2,3]

    target_distances = [1.0, 0.786, 0.786, 1.0, 0.786, 0.786, 1.0, 0.786, 0.786, 1.0, 0.786, 0.786, 1.0, 0.786, 0.786]
    all_length = target_distances.length
    target_distances_each_length = []

    for index in 0..all_length
      target_distances_each_length << target_distances[0..index]
    end    

    p target_distances_each_length

    result.length.upto(all_length - 1) do |counter|
      p "counter:#{counter}"
      p "target:#{target_distances_each_length[counter]}"
      shortest_euclidean_distance = Float::INFINITY
      optimal_value = nil

      possible_values.each do |possible|
        acf = round_array(autocorrelation_coefficient_fft(result + [possible]))
        p acf
        euclidean_distance = dtw_distance(target_distances_each_length[counter], acf)
        if shortest_euclidean_distance > euclidean_distance
          shortest_euclidean_distance = euclidean_distance
          optimal_value = possible
        end
      end
      result.push(optimal_value)
    end
    result_distances = autocorrelation_coefficient_fft(result)
    p result_distances
    p result
  end

end

# main = DecideGraduallyFft.new
# main.run

# target_values = [1,2,3,1,2,3,1,2,3,1,2,3,1,2,3]
# p 'original'
# p round_array(autocorrelation_coefficient(target_values))
# p 'added'
# possible_range = (1..12)
# possible_values = possible_range.to_a 
# possible_values.each do |possible|
#   acf = round_array(autocorrelation_coefficient(target_values + [possible]))
#   p acf
# end

# target_distances_each_length = []

# for index in 0..target_values.length
#   target_distances_each_length << round_array(autocorrelation_coefficient_fft(target_values[0..index]))
# end 
# p target_distances_each_length
# target_distances_each_length.each_with_index do |elm, index|
#   p index
#   p elm
# end
# p round_array(autocorrelation_coefficient_fft([1,2,3,1,2,3,1,2,3]))

target_values = [1,2,3,1,2,3,1,2,3,1,2,3,1,2,3]
p 'first'
p round_array(autocorrelation_coefficient(target_values))
p 'next'
main = DecideGraduallyFft.new
possible_range = (1..12)
possible_values = possible_range.to_a
possible_values.each do |value|
  result = (compare_original_and_shifted_by_euclidean_distance(target_values + [value]))
  result.map{|elm| elm}
end

one = [1,2,3,1,2,3,1,2,3,1,2,3,1]
two = [1,2,3,1,2,3,1,2,3,1,2,3,12]
p dtw_distance(one, two)