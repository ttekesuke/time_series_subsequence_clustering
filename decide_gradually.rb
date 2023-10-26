require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

class DecideGradually
  def run
    possible_range = (1..12)
    possible_values = possible_range.to_a 
    target_length = 10

    target_distances_each_length = []
    # for index in 0..target_length
    #   if index == 0
    #     elm = [0]
    #   else
    #     elm = target_distances_each_length[index - 1] + [rand(0..12).to_i]
    #   end
    #   target_distances_each_length << elm
    # end
    target_distances_each_length = [
      [0],
      [0,1],
      [0,1,3,],
      [0,1,3,0],
      [0,1,3,0,1],
      [0,1,3,0,1,3,],
      [0,1,3,0,1,3,0,],
      [0,1,3,0,1,3,0,1,],
      [0,1,3,0,1,3,0,1,3,],
      [0,1,3,0,1,3,0,1,3,0],
    ]

    p target_distances_each_length

    result = [1]
    result.length.upto(target_length - 1) do |counter|
      p "counter:#{counter}"
      shortest_euclidean_distance = Float::INFINITY
      optimal_value = nil

      possible_values.each do |possible|
        ed = compare_original_and_shifted_by_euclidean_distance(result + [possible])
        euclidean_distance = euclidean_distance(target_distances_each_length[counter], ed)
        if shortest_euclidean_distance > euclidean_distance
          shortest_euclidean_distance = euclidean_distance
          optimal_value = possible
        end
      end
      result.push(optimal_value)
    end
    result_distances = compare_original_and_shifted_by_euclidean_distance(result)
    p result_distances
    p result
  end
end

main = DecideGradually.new
main.run