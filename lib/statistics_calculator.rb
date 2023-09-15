class StatisticsCalculator
  require 'bigdecimal'
  require 'bigdecimal/util'

  ROUNDING_DIGIT = 3
  def mean(d)
    d.sum / d.length.to_d
  end

  def covariance(d1, d2)
    raise "The two data lengths are different." if d1.size != d2.size

    (d1.zip(d2).map{|_d1, _d2 |_d1 * _d2}.sum / d1.size.to_d) - (mean(d1) * mean(d2))
  end

  def variance(d)
    d.map{|e| (e - (mean(d))) ** 2}.sum / d.length.to_d
  end

  def standard_deviation(d)
    Math.sqrt(variance(d))
  end

  def correlation_coefficient(d1, d2)
    covariance(d1, d2) / ( standard_deviation(d1) * standard_deviation(d2) ).to_d
  end

  def autocorrelation_coefficient(d)
    result = []
    for lag in 0..d.length - 2
      result << correlation_coefficient(d[0...(d.length - lag)], d[lag..-1])
    end
    result
  end

  def max_peak_indexes(d)
    old = d[0]
    result = [0]
    up = nil
    d.shift
    d.each_with_index do |elm, index|
      result << index if up and old >= elm
      up = old <= elm
      old = elm
    end
    result
  end

  def difference_sequence(d)
    result = []
    old = d[0]

    d.shift
    d.each_with_index do |elm|
      result << elm - old
      old = elm
    end
    result
  end

  def rounding(e)
    e.round(ROUNDING_DIGIT).to_f 
  end

  def rounding_array(d)
    d.map{|e|rounding(e)}
  end

end