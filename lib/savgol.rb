require 'savgol/version'
require 'matrix'

module Savgol
  class << self
    def savgol(array, window_points=11, order=4, deriv: 0, check_args: false)
      sg_check_arguments(window_points, order) if check_args
      half_window = (window_points -1) / 2
      weights = sg_weights(half_window, order, deriv)
      padded_array = sg_pad_ends(array, half_window)
      sg_convolve(padded_array, weights)
    end

    def sg_check_arguments(window_points, order)
      if !window_points.is_a?(Integer) || window_points.abs != window_points || window_points % 2 != 1 || window_points < 1
        raise ArgumentError, "window_points size must be a positive odd integer" 
      end
      if !order.is_a?(Integer) || order < 0
        raise ArgumentError, "order must be an integer >= 0"
      end
      if window_points < order + 2
        raise ArgumentError, "window_points is too small for the polynomials order"
      end
    end

    def sg_convolve(data, weights, mode=:valid)
      data.each_cons(weights.size).map do |ar|
        ar.zip(weights).map {|pair| pair[0] * pair[1] }.reduce(:+)
      end
    end

    # pads the ends with the reverse, geometric inverse sequence
    def sg_pad_ends(array, half_window)
      start = array[1..half_window]
      start.reverse!
      start.map! {|v| array[0] - (v - array[0]).abs }

      fin = array[(-half_window-1)...-1]
      fin.reverse!
      fin.map! {|v| array[-1] + (v - array[-1]).abs }
      start.push(*array, *fin)
    end

    # returns an object that will convolve with the padded array
    def sg_weights(half_window, order, deriv=0)
      # byebug
      mat = Matrix[ *(-half_window..half_window).map {|k| (0..order).map {|i| k**i }} ]
      # Moore-Penrose psuedo-inverse without SVD (not so precize)
      # A' = (A.t * A)^-1 * A.t
      pinv_matrix = Matrix[*(mat.transpose*mat).to_a].inverse * Matrix[*mat.to_a].transpose
      pinv = Matrix[*pinv_matrix.to_a]
      pinv.row(deriv).to_a
    end
  end
end

# ar = [1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
# numpy_savgol_output = [1.0, 2.0, 3.12857143, 3.57142857, 4.27142857, 4.12571429, 3.36857143, 2.69714286, 2.04, 0.32571429, -0.05714286, 0.8, 0.51428571, -2.17142857, -5.25714286, -7.65714286, -6.4, -2.77142857, 0.17142857, 0.91428571, 1.0]
# sg = ar.savgol(5,3)
# 
# sg.zip(numpy_savgol_output) do |sgv, numpy_sgv|
#   p "#{sgv} vs #{numpy_sgv} diff #{(sgv - numpy_sgv).abs.round(8)}"
# end
