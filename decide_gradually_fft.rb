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
    original = Array.new(5000){ |e| rand(possible_range) }
    original_autocorrelations_each_length = []
    for index in 0..original.length
      p "index:#{index}"
      original_autocorrelations_each_length << autocorrelation_coefficient_fft(original[0..index])
    end

    result = original[0..2]
    result.length.upto(original.length - 1) do |counter|
      p "counter:#{counter}"
      shortest_euclidean_distance = Float::INFINITY
      optimal_value = nil

      possible_values.each do |possible|
        acf = autocorrelation_coefficient_fft(result + [possible])
        euclidean_distance = euclidean_distance(original_autocorrelations_each_length[counter], acf)
        if shortest_euclidean_distance > euclidean_distance
          shortest_euclidean_distance = euclidean_distance
          optimal_value = possible
        end
      end
      result.push(optimal_value)
    end
    result_autocorrelation = autocorrelation_coefficient_fft(result)
    p original
    p result
  end
end

main = DecideGraduallyFft.new
main.run