require 'savgol'

class Array
  # see Savgol#savgol
	def savgol(*args)
    Savgol.savgol(self, *args)
  end
end
