require 'savgol/version'
require 'matrix'

class NilEnumerator < Enumerator
  def initialize(enum)
    @enum = enum
  end

  def next
    begin
      @enum.next
    rescue StopIteration
      nil
    end
  end
end

module Savgol
  class << self
    # Does simple least squares to fit a polynomial based on the given x
    # values.  The major speed-boost of doing savgol is lost for uneven time points.
    # TODO: implement for different derivatives; implement with a window that
    # is of fixed size (not based on the number of points)
    def savgol_uneven(xvals, yvals, window_points=11, order=4, check_args: false, new_xvals: nil)
      sg_check_arguments(window_points, order) if check_args

      half_window = (window_points -1) / 2
      yvals_padded = sg_pad_ends(yvals, half_window)
      xvals_padded = sg_pad_xvals(xvals, half_window)
      xvals_size = xvals.size

      if new_xvals
        nearest_xval_indices = sg_nearest_index(xvals, new_xvals)
        new_xvals.zip(nearest_xval_indices).map do |new_xval, index|
          sg_regress_and_find(
            xvals_padded[index,window_points],
            yvals_padded[index,window_points],
            order,
            new_xval
          )
        end
      else
        xs_iter = xvals_padded.each_cons(window_points)
        yvals_padded.each_cons(window_points).map do |ys|
          xs = xs_iter.next
          sg_regress_and_find(xs, ys, order, xs[half_window])
        end
      end
    end

    # returns the nearest index in original_vals for each value in new_vals
    # (assumes both are sorted arrays). complexity: O(n + m)
    def sg_nearest_index(original_vals, new_vals)
      newval_iter = NilEnumerator.new(new_vals.each)
      indices = []

      index_iter = NilEnumerator.new((0...original_vals.size).each)
      index = index_iter.next
      newval=newval_iter.next
      last_index = original_vals.size-1

      until newval >= original_vals[index]
        indices << index
        break unless newval = newval_iter.next
      end

      loop do
        break unless newval

        if index.nil?
          indices << last_index
        else
          until newval <= original_vals[index]
            index = index_iter.next
            if !index
              indices << last_index
              break
            end
          end

          if index
            if newval < original_vals[index]
              indices << ((newval - original_vals[index-1]) <= (original_vals[index] - newval) ? index-1 : index)
            else
              indices << index
            end
          end
        end
        newval = newval_iter.next
      end

      indices
    end

    def sg_regress_and_find(xdata, ydata, order, xval)
      xdata_matrix = xdata.map { |xi| (0..order).map { |pow| (xi**pow).to_f } }
      mx = Matrix[*xdata_matrix]
      my = Matrix.column_vector(ydata)
      ((mx.t * mx).inv * mx.t * my).transpose.to_a[0].
        zip((0..order).to_a).
        map {|coeff, pow| coeff * (xval**pow) }.
        reduce(:+)
    end

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

    # pads the ends of x vals
    def sg_pad_xvals(array, half_window)
      deltas = array[0..half_window].each_cons(2).map {|a,b| b-a }
      start = array[0]
      prevals = deltas.map do |delta|
        newval = start - delta
        start = newval
        newval
      end
      prevals.reverse!

      deltas = array[(-half_window-1)..-1].each_cons(2).map {|a,b| b-a }
      start = array[-1]
      postvals = deltas.reverse.map do |delta|
        newval = start + delta
        start = newval
        newval
      end

      prevals.push(*array, *postvals)
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
