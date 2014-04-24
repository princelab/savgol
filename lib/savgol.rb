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
 
  def peek
    begin
      @enum.peek
    rescue StopIteration
      nil
    end
  end
end

module Enumerable
  def nilstop_iterator
    NilEnumerator.new(self.each)
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
        abort 'here'
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
      newval_iter = new_vals.nilstop_iterator
      indices = []

      index_iter = (0...original_vals.size).nilstop_iterator
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


#if xval == xvals[i]
  #i
#else
#end

                #ars = [xvals_padded, yvals_padded].
                  #map {|ar| ar[i_xval_near, window_points] }
                ##puts "arsfirst: #{ars.first}, last:#{ars.last}, order:#{order}, xval:#{xval}"
                #new_yvals << sg_regress_and_find(ars.first, ars.last, order, xval)
                #break
              #else
                #i += 1





# ar = [1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
# numpy_savgol_output = [1.0, 2.0, 3.12857143, 3.57142857, 4.27142857, 4.12571429, 3.36857143, 2.69714286, 2.04, 0.32571429, -0.05714286, 0.8, 0.51428571, -2.17142857, -5.25714286, -7.65714286, -6.4, -2.77142857, 0.17142857, 0.91428571, 1.0]
# sg = ar.savgol(5,3)
# 
# sg.zip(numpy_savgol_output) do |sgv, numpy_sgv|
#   p "#{sgv} vs #{numpy_sgv} diff #{(sgv - numpy_sgv).abs.round(8)}"
# end
