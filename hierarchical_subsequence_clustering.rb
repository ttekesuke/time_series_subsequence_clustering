require 'set'
require "./lib/statistics_calculator"
require "./lib/utility"
include StatisticsCalculator
include Utility

def generate_subsequences(data, window_size)
  data.each_cons(window_size).map.with_index do |subsequence, start_index|
    { start_index: start_index, values: subsequence }
  end
end

def extend_to_max_length(subsequences)
  max_length = subsequences.map { |seq| seq[:values].size }.max
  subsequences.map do |seq|
    new_seq = seq.dup
    if new_seq[:values].size < max_length
      diff = max_length - new_seq[:values].size
      new_seq[:values] = [new_seq[:values].first] + new_seq[:values] + [new_seq[:values].last] * (diff - 1)
    end
    new_seq
  end
end


# data = Array.new(50) { rand(0..9) } 
data = [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4]
p data
 max_clusters = 10
# window_sizeの範囲を定義
min_window_size = 2
max_window_size = 8

# 初期化
all_clusters = []
min_window_size.upto(max_window_size) do |window_size|
  # 部分列を生成
  subsequences = generate_subsequences(data, window_size)

  # 部分列からクラスタを生成
  clusters = subsequences.map.with_index do |subsequence, i|
    { id: i, ave: subsequence[:values], elements: [subsequence] }
  end

  all_clusters += clusters
end


# クラスターの数が最大クラスタ数になるまで繰り返す
while all_clusters.size > max_clusters do
  # クラスタ間のDTW距離の最小値を求める
  min_distance = Float::INFINITY
  closest_pair = nil
  all_clusters.combination(2) do |c1, c2|
    distance = dtw_distance(c1[:ave], c2[:ave])
    if distance < min_distance
      min_distance = distance
      closest_pair = [c1, c2]
    end
  end

  # 最も近い2つのクラスタを結合
  all_clusters.delete_if { |c| c[:id] == closest_pair[0][:id] || c[:id] == closest_pair[1][:id] }
  new_elements = closest_pair[0][:elements] + closest_pair[1][:elements]
  extended_elements = extend_to_max_length(new_elements)
  new_ave = extended_elements.map{|c|c[:values]}.transpose.map {|x| x.inject(:+) / x.size.to_f }
  all_clusters << {id: all_clusters.size, ave: new_ave, elements: new_elements}
end

p all_clusters
