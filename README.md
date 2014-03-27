# savgol

Provides implementations of Savitzky-Golay smoothing (filtering).

The gem is based on the [scipy implementation](http://www.scipy.org/Cookbook/SavitzkyGolay).  A good explanation of the process may be found [here on stackexchange](http://dsp.stackexchange.com/a/9494).

# Examples

## Array implementation

    require 'savgol/array'
    data = [1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
    # window size = 5, polynomial order = 3
    data.savgol(5,3)

# Installation
    
    gem install savgol

# TODO

* Implement for Scriruby's Nmatrix and NArray.
* Implement smoothing for unevenly sampled data.

# Copyright

MIT license.  See LICENSE.txt.

