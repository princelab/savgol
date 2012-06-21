require 'savgol/core'

class Savgol
  class Array
    include Savgol::Core

    def savgol(window_size, order, deriv=0, check_args=false)
      sg_check_args(window_size, order) if check_args
      half_window = (window_size -1) / 2
      weights = sg_weights(half_window, order, deriv)
      ar = sg_pad_ends(half_window)
      sg_convolve(ar, weights)
    end

    def sg_convolve(data, weights, mode=:valid)
      data.each_cons(weights.size).map do |ar|
        ar.zip(weights).map {|pair| pair[0] * pair[1] }.reduce(:+)
      end
    end

    # pads the ends with the reverse, geometric inverse sequence
    def sg_pad_ends(half_window)
      start = self[1..half_window]
      start.reverse!
      start.map! {|v| self[0] - (v - self[0]).abs }

      fin = self[(-half_window-1)...-1]
      fin.reverse!
      fin.map! {|v| self[-1] + (v - self[-1]).abs }
      start.push(*self, *fin)
    end

    # returns an object that will convolve with the padded array
    def sg_weights(half_window, order, deriv=0)
      mat = SVDMatrix[ *(-half_window..half_window).map {|k| (0..order).map {|i| k**i }} ]
      mat.pinv.row(deriv).to_a
    end

  end
end

class Array
  include Savgol::Array
end
