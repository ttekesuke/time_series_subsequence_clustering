class StatisticsCalculator
  require 'bigdecimal'
  require 'bigdecimal/util'
  def mean(d)
    d.sum / d.length.to_d
  end

  def covariance(d1, d2)
    raise "The two data lengths are different." if d1.size != d2.size

    (d1.zip(d2).map{|_d1, _d2 |_d1 * _d2}.sum / d1.size.to_d) - (mean(d1) * mean(d2))
  end

  def standard_deviation(d)
    Math.sqrt(d.map{|i| (i - (mean(d))) ** 2}.sum / d.length.to_d)
  end

  def correlation_coefficient(d1, d2)
    covariance(d1, d2) / ( standard_deviation(d1) * standard_deviation(d2) ).to_d
  end

  def autocorrelation_coefficient(d)
    result = []
    for lag in 0..d.length - 2
      result << correlation_coefficient(d[0...(d.length - lag)], d[lag..-1]).round(3).to_f 
    end
   
    result
  end
end