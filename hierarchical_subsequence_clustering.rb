require 'set'
require "./lib/statistics_calculator"
require "./lib/utility"
require 'benchmark'
include StatisticsCalculator
include Utility

def generate_subsequences(window_size, start_indexes)
  start_indexes.map{|start_index|{start_index: start_index, end_index: start_index + window_size - 1}}
end
result = Benchmark.realtime do
  data_length = 200
  data = Array.new(data_length){ |e| rand(1..12) }
  1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,3,4,1,2,3,4,1,2,3,4]
  # data_length = data.length
  p data
  min_window_size = 2
  current_window_size = min_window_size
  cluster_id_counter = 0
  all_window_clusters = []
  start_indexes = 0.step(data_length - min_window_size, 1).to_a

  # 部分列を生成
  current_window_subsequences = generate_subsequences(current_window_size, start_indexes)

  # データの半分になるまで部分列を伸ばして調査
  while current_window_size < data.length / 2 && current_window_subsequences.length > 0 do
    p "current_window_size:#{current_window_size}"
    current_window_clusters = []
    # 部分列を使って初期クラスタ作成
    current_window_subsequences.each do |subsequence|
      current_window_clusters << {
        id: cluster_id_counter, 
        average: data[subsequence[:start_index]..subsequence[:end_index]], 
        subsequences: [subsequence]
      }
      cluster_id_counter += 1
    end
    # クラスタ結合
    while current_window_clusters.length > current_window_subsequences.length / 2 do
      min_distance = Float::INFINITY
      closest_pair = nil
      current_window_clusters.combination(2) do |c1, c2|
        distance = euclidean_distance(c1[:average], c2[:average])
        # 最短になったら更新
        if distance < min_distance
          min_distance = distance
          closest_pair = [c1, c2]
        end
      end
      current_window_clusters.delete_if { |c| c[:id] == closest_pair[0][:id] || c[:id] == closest_pair[1][:id] }
      current_window_clusters << {
        id: cluster_id_counter, 
        average: closest_pair.map{|c|c[:average]}.transpose.map {|x| x.inject(:+) / x.size.to_f },
        subsequences: closest_pair[0][:subsequences] + closest_pair[1][:subsequences]
      }
      cluster_id_counter += 1
    end
    all_window_clusters << current_window_clusters
    current_window_size += 1
    #結合完了後に、クラスタ内で結合されたものを使って次の部分列群を生成する
    current_window_subsequences = generate_subsequences(
      current_window_size, 
      current_window_clusters
      .filter{|cluster|cluster[:subsequences].length > 1 && cluster[:subsequences].all?{|subsequence|subsequence[:start_index] + current_window_size <= data.length - 1}}
      .map{|cluster|cluster[:subsequences].map{|subsequence|subsequence[:start_index]}}.flatten
    )
  end

  all_window_clusters.each_with_index do |window_clusters, window_cluster_index|
    p "window #{window_cluster_index + min_window_size}============================"
    window_clusters.each_with_index do |cluster, cluster_index|
      p "cluster #{cluster_index}"
      p "average: #{cluster[:average]}"
      cluster[:subsequences].each do |subsequence|
        p data[subsequence[:start_index]..subsequence[:end_index]]
      end
    end
  end
end
puts "処理時間 #{result}s"