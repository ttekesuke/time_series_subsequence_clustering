require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

class DecideGradually
  def run
    possible_range = (0..9)
    possible_values = possible_range.to_a 
    result = [0,3,6]

    ideal_result = result + [0]

    ideal_absolute_distances_each_length = []
    for index in 0..ideal_result.length
      ideal_absolute_distances_each_length << compare_original_and_shifted_by_euclidean_distance(ideal_result[0..index])

    end
    ideal_absolute_distances_each_length.each do |elm|
      p elm
    end

    target_normalized_distances = [0,0.4,0.35,0]
    # ideal_absolute_distan
    all_length = target_normalized_distances.length
    target_absolute_distances_each_length = []

    powered_maximum_range = (possible_values.last - possible_values.first)**2
    for index in 0..all_length
      maximum_euclide_distance = Math.sqrt(powered_maximum_range * (index + 1))
      absolute = target_normalized_distances[0..index].map{|distance| distance * maximum_euclide_distance}
      target_absolute_distances_each_length << absolute
    end    

    p target_absolute_distances_each_length

    result.length.upto(all_length - 1) do |counter|
      p "counter:#{counter}"
      shortest_diff = Float::INFINITY
      optimal_value = nil

      possible_values.each do |possible|
        compare_original_and_shifted_by_euclidean_distance = compare_original_and_shifted_by_euclidean_distance(result + [possible])
        p compare_original_and_shifted_by_euclidean_distance
        diff_target_and_possible = euclidean_distance(target_absolute_distances_each_length[counter], compare_original_and_shifted_by_euclidean_distance)
        if shortest_diff > diff_target_and_possible
          shortest_diff = diff_target_and_possible
          optimal_value = possible
        end
      end
      result.push(optimal_value)
    end
    result_distances = compare_original_and_shifted_by_euclidean_distance(result)
    # p result_distances
    p result
  end
end

main = DecideGradually.new
main.run

# target_values = [1,2,3,1,2,3,1,2,3,1,2,3,1,2,3]
# target_normalized_distances = []

# for index in 0..target_values.length
#   target_distances_each_length << round_array(compare_original_and_shifted_by_euclidean_distance(target_values[0..index]))
# end 
# p target_distances_each_length
# target_distances_each_length.each_with_index do |elm, index|
#   p index
#   p elm
# end
# p round_array(compare_original_and_shifted_by_euclidean_distance([1,2,3,1,2,3,1,2,3]))