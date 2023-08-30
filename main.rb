require "./lib/statistics_calculator"

statistics_calculator = StatisticsCalculator.new
data1 = [50,60,70,80,90]
data2 = [40,70,90,60,100]
p statistics_calculator.correlation_coefficient(data1, data2)