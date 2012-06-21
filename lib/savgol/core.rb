require 'ruby-svd'

class SVDMatrix < Matrix
  def self.[](*rows)
    mat = self.new(rows.size,rows.first.size)
    rows.each_with_index {|row,i| mat.set_row(i, row) }
    mat
  end

  # Moore-Penrose psuedo-inverse
  # SVD: A=UWV'
  # A+=V(W'W)^(−1)W'U'
  def pinv
    (u, w, v) = self.decompose
    v * (w.t*w).inverse * w.t * u.t
  end
end

module Savgol
  module Core
    # checks that both window_size and checks that the window size is positive, odd, and greater than 0
    def sg_check_args(window_size, order)
      if !window_size.is_a?(Integer) || window_size.abs != window_size || window_size % 2 != 1 || window_size < 1
        raise ArgumentError, "window_size size must be a positive odd integer" 
      end
      if !order.is_a?(Integer) || order < 0
        raise ArgumentError, "order must be an integer >= 0"
      end
      if window_size < order + 2
        raise ArgumentError, "window_size is too small for the polynomials order"
      end
    end
  end
end
