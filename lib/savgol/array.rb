require "matrix"

module Savgol
	
	def savgol(window_size, order, deriv=0, check_args=false)
		  
		# check arguments
		if !window_size.is_a?(Integer) || window_size.abs != window_size || window_size % 2 != 1 || window_size < 1
			raise ArgumentError, "window_size size must be a positive odd integer" 
		end
		if !order.is_a?(Integer) || order < 0
			raise ArgumentError, "order must be an integer >= 0"
		end
		if window_size < order + 2
			raise ArgumentError, "window_size is too small for the polynomials order"
		end
	  
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
		# byebug
		mat = Matrix[ *(-half_window..half_window).map {|k| (0..order).map {|i| k**i }} ]
		# Moore-Penrose psuedo-inverse without SVD (not so precize)
		# A' = (A.t * A)^-1 * A.t
		pinv_matrix = Matrix[*(mat.trans*mat).to_a].inverse * Matrix[*mat.to_a].transpose
		pinv = Matrix[*pinv_matrix.to_a]
		pinv.row(deriv).to_a
	end

end

class Array
	include Savgol
end
