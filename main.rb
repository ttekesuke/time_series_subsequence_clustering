require "./lib/statistics_calculator"

statistics_calculator = StatisticsCalculator.new
p 'correlation_coefficient'
data1 = [50,60,70,80,90]
data2 = [40,70,90,60,100]
p statistics_calculator.correlation_coefficient(data1, data2)

p 'autocorrelation_coefficient'
data3 = [1,3,1,3,1,3,1,3,1,3]
p statistics_calculator.autocorrelation_coefficient(data3)