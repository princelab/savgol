require 'matrix'
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

  def sg_convolve(other, mode=:valid)
  end

  def sg_pad_ends(half_window)
    start = self[1..half_window]
    start.reverse!
    start.map! {|v| self[0] - (v - self[0]).abs }

    fin = self[-half_window..-2]
    fin.reverse!
    fin.map! {|v| self[-1] - (v - self[-1]).abs }
    start.push(*self, *fin)
  end

  def savgol(window_size, order, deriv=0)
    puts "HIAY"
    p window_size
    p order
    sg_check_args(window_size, order)
    # (//) is integer division in python 3
    # half_window = (window_size -1) // 2
    half_window = (window_size -1) / 2
    # precompute coefficients
    # order_range = range(order+1)
    # (0..order) is order_range
    b = SVDMatrix[ *(-half_window..half_window).map {|k| (0..order).map {|i| k**i }} ]
    m = b.pinv.row(deriv).to_a

    p half_window
    p self
    p sg_pad_ends(half_window)

    abort 'here'

    #firstvals = self[0] - (self[1..half_window].reverse - self[0])
    #firstvals = self[0] - (self[1..half_window].reverse - self[0])
    #y.convolve(m, :valid)

    #firstvals = y[0] - np.abs( y[1:half_window+1][::-1] - y[0] )
    #lastvals = y[-1] + np.abs(y[-half_window-1:-1][::-1] - y[-1])
    
    # .A is the array representation
    #m = np.linalg.pinv(b).A[deriv]
    ## pad the signal at the extremes with
    ## values taken from the signal itself

    #firstvals = y[0] - np.abs( y[1:half_window+1][::-1] - y[0] )
    #lastvals = y[-1] + np.abs(y[-half_window-1:-1][::-1] - y[-1])
    #y = np.concatenate((firstvals, y, lastvals))
    #return np.convolve( m, y, mode='valid')
  end
end
