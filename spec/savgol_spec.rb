require 'spec_helper'

describe Savgol do
  describe 'padding' do
    let(:array) { [1, 2, 3, 4, -7, -2, 0, 1, 1] }
    it 'pads with the reverse geometrically inverted sequence' do
      expect(Savgol.sg_pad_ends(array, 2)).to eq [-1, 0, 1, 2, 3, 4, -7, -2, 0, 1, 1, 1, 2]
      expect(Savgol.sg_pad_ends(array, 3)).to eq [-2, -1, 0, 1, 2, 3, 4, -7, -2, 0, 1, 1, 1, 2, 4]
    end

    it 'pads unevenly spaced x vals' do
      ar = %w(-1 0 2 3 4 7 8 10 11 12 13 14 17 18).map &:to_f
      expect(Savgol.sg_pad_xvals(ar, 2)).to eq %w(-4 -2 -1 0 2 3 4 7 8 10 11 12 13 14 17 18 19 22]).map(&:to_f)
    end
  end

  describe 'finding nearest index' do
    let(:original) { [0,1,2,3,4] }

    it 'finds nearest index to the left' do
      newvals = [-2, -1]
      expect(Savgol.sg_nearest_index(original, newvals)).to eq([0,0])
    end

    it 'finds nearest indices in the middle' do
      newvals = [1,1.4,1.5,1.6,2,2.1]
      expect(Savgol.sg_nearest_index(original, newvals)).to eq([1,1,1,2,2,2])
    end
    
    it 'finds nearest index to the right' do
      newvals = [5,6]
      expect(Savgol.sg_nearest_index(original, newvals)).to eq([4,4])
    end

    it 'efficiently finds the nearest index' do
      newvals = [-2,-1,1,2.4,2.5,4,4.5,5]
      expect(Savgol.sg_nearest_index(original, newvals)).to eq([0,0,1,2,2,4,4,4])
    end
  end

  describe 'smoothing unevenly spaced data' do
    xvals = %w(-1 0 2 3 4 7 8 10 11 12 13 14 17 18).map &:to_f
    new_xvals = xvals.map {|v| v + 0.5 }
    yvals = %w(-2 1 0 1 1 3 4 7  8  9  7  4  1   2).map {|v| v.to_f + 30 }

    yvals_on = Savgol.savgol_uneven(xvals, yvals, 5, 2)

    yvals_off = Savgol.savgol_uneven(xvals, yvals, 5, 2, new_xvals: new_xvals)

    yvals_pretend_even = Savgol.savgol(yvals, 5, 2)

    if false
      require 'gnuplot'
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|

          plot.data << Gnuplot::DataSet.new([new_xvals, yvals_off]) do |ds|
            ds.title = "x interpolated"
            ds.with = "linespoints"
          end

          plot.data << Gnuplot::DataSet.new([xvals, yvals_pretend_even]) do |ds|
            ds.title = "pretend evenly spaced"
            ds.with = "linespoints"
          end

          plot.data << Gnuplot::DataSet.new([xvals, yvals_on]) do |ds|
            ds.title = "smoothed"
            ds.with = "linespoints"
          end

          plot.data << Gnuplot::DataSet.new([xvals, yvals]) do |ds|
            ds.title = "original"
            ds.with = "points"
          end

        end
      end
    end

  end
end

