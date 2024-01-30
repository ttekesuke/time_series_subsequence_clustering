require 'numo/pocketfft'
module Fft
  def autocorrelation_coefficient_fft(data)
    dfloat_data = Numo::DFloat[*data]
    fft_result = Numo::Pocketfft.fft(dfloat_data)
    ifft_result = Numo::Pocketfft.ifft(fft_result * fft_result.conj)
    real_part = ifft_result.real
    normalized_result = real_part / real_part[0]
    normalized_result.to_a.map { |element| BigDecimal(element.to_s) }
  end
end