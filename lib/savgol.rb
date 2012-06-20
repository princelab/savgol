

module Savgol
  # checks that both window_size and checks that the window size is positive, odd, and greater than 0
  def check_args(window_size, order)
    ord = Integer(order)
    if ws.abs != ws || ws % 2 != 1 || window_size < 1
      raise ArgumentError, "window_size size must be a positive odd integer" 
    end
    if ord.abs != ord
      raise ArgumentError, "order must be an integer > 1"
    end
    if ws < ord + 2
      raise ArgumentError, "window_size is too small for the polynomials order"
    end
  end
end
