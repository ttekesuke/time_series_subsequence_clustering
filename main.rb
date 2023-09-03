require "./lib/statistics_calculator"

statistics_calculator = StatisticsCalculator.new
p 'correlation_coefficient'
data1 = [50,60,70,80,90]
data2 = [40,70,90,60,100]
p statistics_calculator.correlation_coefficient(data1, data2)


# data3 = [1,5,9,5,1,3,5,3,1,5,9,5,1,3,5,3,1,5,9,5,1,3,5,3]
# data3 = [1,2,3,1,3,5,1,2,3,1,3,5,1,2,3,1,3,5,1,2,3,1,3,5]
# data3 = [1,2,3,2,1,3,5,3,1,2,3,2,1,3,5,3,1,2,3,2,1,3,5,3,1,2,3,2,1,3,5,3]
# data3 = [1,3,5,1,3,5,1,1,1,1,1,1,3,5,1,3,5,1,1,1,1,1,1]
data3 = [1,3,5,1,3,5,1,1,1,1,1,3,5,1,3,5,1,1,1,1,1]

p 'data'
p data3

p 'autocorrelation_coefficient'
autocorrelation_coefficient = statistics_calculator.autocorrelation_coefficient(data3)
p autocorrelation_coefficient

p 'max_peak_indexes'
max_peak_indexes = statistics_calculator.max_peak_indexes(autocorrelation_coefficient)
p max_peak_indexes

p 'diff'
difference_sequences = statistics_calculator.difference_sequence(max_peak_indexes)
p difference_sequences

p 're_autocorrelation_coefficient'
re_autocorrelation_coefficient = statistics_calculator.autocorrelation_coefficient(difference_sequences)
p re_autocorrelation_coefficient