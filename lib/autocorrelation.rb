class Autocorrelation
  def mean(d)
    d.sum / d.length
  end

  def covariance(d1, d2)
    raise "The two data lengths are different." if d1.size != d2.size
    (d1.zip(d2).map{|_d1, _d2 |_d1 * _d2}.sum / d1.size) - (mean(d1) * mean(d2))
  end

  def standard_deviation(d)
    Math.sqrt(d.map{|i| (i - (mean(d))) ** 2}.sum / d.length)
  end

  def correlation_coefficient(d1, d2)
    covariance(d1, d2) / ( standard_deviation(d1) * standard_deviation(d2) )
  end
end