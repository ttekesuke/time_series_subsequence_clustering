require 'set'
require "./lib/statistics_calculator"
require "./lib/utility"
require 'benchmark'
require 'gruff'
include StatisticsCalculator
include Utility

def generate_subsequences(window_size, start_indexes)
  start_indexes.map{|start_index|{start_index: start_index, end_index: start_index + window_size - 1}}
end
result = Benchmark.realtime do
  data_length = 50
  data = Array.new(data_length){ |e| rand(1..12) }
  # data =[1,2,3,4,1,2,3,4,]
  # data_length = data.length
  p data
  min_window_size = 2
  current_window_size = min_window_size
  cluster_id_counter = 0
  all_window_clusters = []
  tolerance_diff_sitance_between_average_and_latest = 1
  start_indexes = 0.step(data_length - min_window_size, 1).to_a

  # 部分列を生成
  current_window_subsequences = generate_subsequences(current_window_size, start_indexes)

  # データの半分になるまで部分列を伸ばして調査
  while current_window_size <= data.length / 2 && current_window_subsequences.length > 0 do
    p "current_window_size:#{current_window_size}"
    min_distances = []
    cluster_merge_counter = 0
    tolerance_over = false
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
    while current_window_clusters.length > 1 && !tolerance_over do
      min_distance = Float::INFINITY
      closest_pair = nil
      current_window_clusters.combination(2).each do |c1, c2|
        distance = euclidean_distance(c1[:average], c2[:average])
        # 部分列が完全一致なら結合して終わり
        if distance == 0.0
          min_distance = distance
          closest_pair = [c1, c2]
          break
        end
        # 最短になったら更新
        if distance < min_distance
          min_distance = distance
          closest_pair = [c1, c2]
        end
      end

      min_distances << min_distance
      
      # 許容値となる距離を超えたら結合終了
      if cluster_merge_counter > 1 && min_distances.last - mean(min_distances[0...min_distances.length - 1]) > tolerance_diff_sitance_between_average_and_latest
        tolerance_over = true
      else
        current_window_clusters.delete_if { |c| c[:id] == closest_pair[0][:id] || c[:id] == closest_pair[1][:id] }
        current_window_clusters << {
          id: cluster_id_counter, 
          average: closest_pair.map{|c|c[:average]}.transpose.map {|x| x.inject(:+) / x.size.to_f },
          subsequences: closest_pair[0][:subsequences] + closest_pair[1][:subsequences]
        }
        cluster_id_counter += 1
        cluster_merge_counter += 1
      end
    end
    # そのwindow_sizeにおけるクラスタリング結果を保存
    all_window_clusters << current_window_clusters
    next_window_clusters = Marshal.load(Marshal.dump(current_window_clusters))
    # 結合完了後に、同じクラスタ内で部分列同士をチェック。部分列同士で時系列上で重複すれば、前にある部分列側は今後クラスタ結合の対象外とする
    next_window_clusters.each do |cluster|
      other_subsequences = []
      not_overlapping = []
      # 時系列上での重複チェック
      cluster[:subsequences].each do |subsequence|
        other_subsequences = cluster[:subsequences].filter{|may_remove_subsequence| subsequence != may_remove_subsequence && subsequence[:start_index] < may_remove_subsequence[:start_index]}
        not_overlapping << subsequence if other_subsequences.all?{|other_subsequence| subsequence[:end_index] + 1 < other_subsequence[:start_index]}
      end
      cluster[:subsequences] = not_overlapping      

      # 次の長さのwindow_sizeでも元データをはみ出さない部分列だけ残す
      cluster[:subsequences] = cluster[:subsequences].filter{|subsequence|subsequence[:start_index] + current_window_size <= data.length - 1}
    end

    current_window_size += 1
    # 次の部分列群を生成する
    current_window_subsequences = generate_subsequences(
      current_window_size, 
      next_window_clusters
      .filter{|cluster|cluster[:subsequences].length > 1}
      .map{|cluster|cluster[:subsequences].map{|subsequence|subsequence[:start_index]}}.flatten
    )
  end

  g = Gruff::Line.new(1200)
  g.hide_legend = true
  g.hide_dots = true
  g.data :data, data
  all_window_clusters.each_with_index do |window_clusters, window_cluster_index|
    window_clusters.filter{|cluster|cluster[:subsequences].length > 1}.each do |cluster, cluster_index|
      current_index = 0
      array = []
      current_position = 0
      old_end = nil
      cluster[:subsequences].each_with_index do |subsequence, index|
        if subsequence[:start_index] > 0
          array += [].fill(nil, 0..subsequence[:start_index] - current_position - 1)
        end
        if !old_end.nil? && subsequence[:start_index] <= old_end
          array.pop(old_end - subsequence[:start_index] + 1)
        end

        array += data[subsequence[:start_index]..subsequence[:end_index]].map{|elm| elm + (12 * (window_cluster_index + 2))} 
        old_end = subsequence[:end_index]

        current_position = subsequence[:end_index] + 1
        if index == cluster[:subsequences].length - 1 && subsequence[:end_index] < data.length - 1
          array += [].fill(nil, 0..data.length - current_position - 1)
        end
      end
      g.data ((window_cluster_index + min_window_size).to_s + '_' + cluster_index.to_s).to_sym, array
    end
    # p "window #{window_cluster_index + min_window_size}============================"
    # window_clusters.each_with_index do |cluster, cluster_index|
    #   p "cluster #{cluster_index}"
    #   p "average: #{cluster[:average]}"
    #   cluster[:subsequences].each do |subsequence|
    #     p data[subsequence[:start_index]..subsequence[:end_index]]
    #   end
    # end
  end
  g.write('exciting.png')
end
puts "処理時間 #{result}s"
