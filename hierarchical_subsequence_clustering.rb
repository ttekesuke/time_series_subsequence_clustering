require 'set'
require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

data = Array.new(100) { rand(0..9) } 
p data
max_clusters = 20
window_size = 5
subsequences = data.each_cons(window_size).to_a
clusters = subsequences.map.with_index { |seq, i| {id: i, ave: seq, elements: [seq]} }

while clusters.size > max_clusters do
  min_distance = Float::INFINITY
  closest_pair = nil
  clusters.combination(2) do |c1, c2|
    distance = dtw_distance(c1[:ave], c2[:ave])
    if distance < min_distance
      min_distance = distance
      closest_pair = [c1, c2]
    end
  end

  clusters.delete_if { |c| c[:id] == closest_pair[0][:id] || c[:id] == closest_pair[1][:id] }
  new_elements = closest_pair[0][:elements] + closest_pair[1][:elements]
  new_ave = new_elements.transpose.map {|x| x.inject(:+) / x.size.to_f }
  clusters << {id: clusters.size, ave: new_ave, elements: new_elements}
end

clusters.each_with_index do |cluster, index|
  puts "Cluster #{index+1}:"
  cluster.each { |seq| p seq }
end