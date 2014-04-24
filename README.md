# savgol

Provides implementations of Savitzky-Golay smoothing (filtering).

The gem is based on the [scipy implementation](http://www.scipy.org/Cookbook/SavitzkyGolay) (gives exactly the same result).  A good explanation of the process may be found [here on stackexchange](http://dsp.stackexchange.com/a/9494).

# Examples

## Evenly spaced data

### Array implementation (object oriented)

    require 'savgol/array'
    data = [1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
    # window size = 5, polynomial order = 3
    data.savgol(5,3)

### Module implementation

    require 'savgol'
    data = [1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
    # window size = 5, polynomial order = 3
    Savgol.savgol(data, 5,3)

## Uneven data

The speed gain of the Savitzky-Golay filter is lost when interpolating
unevenly spaced data and devolves into simple polynomial linear regression [At
least I believe they are equivalent in complexity since both require a matrix
pseudo-inverse calculation as the most complex operation].  Even though it may
be much slower, a filter that handles unevenly spaced data may be useful in
some cases.

    require 'savgol'
    xvals = %w(-1 0 2 3 4 7 8 10 11 12 13 14 17 18).map &:to_f
    yvals = %w(-2 1 0 1 1 3 4 7  8  9  7  4  1   2).map {|v| v.to_f + 30 }

### Interpolate at the given x-values

    Savgol.savgol_uneven(xvals, yvals, 5, 2)

### Interpolate at a new set of x values

    new_xvals = xvals.map {|v| v + 0.5 }
    Savgol.savgol_uneven(xvals, yvals, 5, 2, new_xvals: new_xvals)

# Installation
    
    gem install savgol

# TODO

* Implement for Scriruby's Nmatrix and NArray.
* Implement smoothing for unevenly sampled data.

# Copyright

MIT license.  See LICENSE.txt.

