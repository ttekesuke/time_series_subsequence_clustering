require 'set'
require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

def generate_subsequences(data, window_size)
  data.each_cons(window_size).map.with_index do |subsequence, start_index|
    { start_index: start_index, end_index: start_index + window_size - 1 }
  end
end

def extend_to_max_length(subsequences, data)
  max_length = subsequences.map { |seq| seq[:end_index] - seq[:start_index] + 1 }.max
  subsequences.map do |seq|
    seq_length = seq[:end_index] - seq[:start_index] + 1
    new_data = data[seq[:start_index]..seq[:end_index]]
    if seq_length < max_length
      diff = max_length / seq_length
      remainder = max_length % seq_length
      new_data = data[seq[:start_index]..seq[:end_index]].flat_map { |v| [v] * diff }
      new_data += [data[seq[:start_index]..seq[:end_index]].last] * remainder
    end
    new_data
  end
end

def merge_clusters(cluster_a, cluster_b, new_id, data)
  new_elements = []
  overlapped_elements_a = []
  overlapped_elements_b = []
  cluster_a[:elements].each do |element_a|
    cluster_b[:elements].each do |element_b|
      overlap = overlapping(element_a, element_b)
      unless overlap.nil?
        new_elements << overlap
        overlapped_elements_a << element_a
        overlapped_elements_b << element_b
      end
    end
  end
  remaining_elements_a = cluster_a[:elements] - overlapped_elements_a
  remaining_elements_b = cluster_b[:elements] - overlapped_elements_b
  new_elements += remaining_elements_a
  new_elements += remaining_elements_b
  extended_elements = extend_to_max_length(new_elements, data)
  before_transpose = []
  new_ave = extended_elements.transpose.map {|x| x.inject(:+) / x.size.to_f }
  { id: new_id, elements: new_elements, average: new_ave }
end

def overlapping(subseq_a, subseq_b)
  start_index = [subseq_a[:start_index], subseq_b[:start_index]].max
  end_index = [subseq_a[:end_index], subseq_b[:end_index]].min
  if start_index <= end_index
    { start_index: start_index, end_index: end_index }
  else
    nil
  end
end

data = Array.new(40) { rand(0..9) } 
# data = [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,3,4,1,2,3,4,1,2,3,4]
p data
max_clusters = 15
min_window_size = 2
max_window_size = 6
cluster_id_counter = 0
all_clusters = []

min_window_size.upto(max_window_size) do |window_size|
  # 部分列を生成
  subsequences = generate_subsequences(data, window_size)

  # 部分列からクラスタを生成
  clusters = subsequences.map do |subsequence|
    cluster = { id: cluster_id_counter, average: data[subsequence[:start_index]..subsequence[:end_index]], elements: [subsequence] }
    cluster_id_counter += 1
    cluster
  end
  all_clusters += clusters
end

# クラスターの数が最大クラスタ数になるまで繰り返す
while all_clusters.size > max_clusters do
  # クラスタ間のDTW距離の最小値を求める
  min_distance = Float::INFINITY
  min_difference_sequence_distance = Float::INFINITY
  closest_pair = nil
  all_clusters.combination(2) do |c1, c2|
    distance = dtw_distance(c1[:average], c2[:average])
    difference_sequence_distance = dtw_distance(difference_sequence(c1[:average]), difference_sequence(c2[:average]))
    if distance < min_distance && difference_sequence_distance < min_difference_sequence_distance
      min_distance = distance
      min_difference_sequence_distance = difference_sequence_distance
      closest_pair = [c1, c2]
    end
  end
  # 最も近い2つのクラスタを結合
  all_clusters.delete_if { |c| c[:id] == closest_pair[0][:id] || c[:id] == closest_pair[1][:id] }
  all_clusters << merge_clusters(closest_pair[0], closest_pair[1], cluster_id_counter, data)
  cluster_id_counter += 1
end

all_clusters.each_with_index do |cluster, index|
  p "cluster #{index}"
  p cluster[:average]
  cluster[:elements].each do |element|
    p data[element[:start_index]..element[:end_index]]
  end
end