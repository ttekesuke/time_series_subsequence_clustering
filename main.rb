require "./lib/statistics_calculator"

statistics = StatisticsCalculator.new
# data = [1,3,5,1,3,5,1,1,1,1,1,3,5,1,3,5,1,1,1,1,1]
data = [3,4,3,3,4,3]

p 'data'
p data

p 'autocorrelation_coefficient'
autocorrelation_coefficient = statistics.autocorrelation_coefficient(data)
p statistics.rounding_array(autocorrelation_coefficient)
    
p 'max_peak_indexes'
max_peak_indexes = statistics.max_peak_indexes(autocorrelation_coefficient)
p max_peak_indexes

p 'diff'
difference_sequences = statistics.difference_sequence(max_peak_indexes)
p difference_sequences

p 're_autocorrelation_coefficient'
re_autocorrelation_coefficient = statistics.autocorrelation_coefficient(difference_sequences)
p statistics.rounding_array(re_autocorrelation_coefficient)

var1 = [1,2,3,4,5,6]
p statistics.rounding(statistics.variance(var1))