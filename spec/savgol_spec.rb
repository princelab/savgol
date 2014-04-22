require 'spec_helper'
require 'gnuplot'

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

  describe 'smoothing unevenly spaced data' do
    xvals = %w(-1 0 2 3 4 7 8 10 11 12 13 14 17 18).map &:to_f
    yvals = %w(-2 1 0 1 1 3 4 7  8  9  7  4  1   2).map &:to_f
    reply = Savgol.savgol_uneven(xvals, yvals, 5, 2)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.data << Gnuplot::DataSet.new([xvals, yvals]) do |ds|
          ds.title = "original"
          ds.with = "linespoints"
        end
        plot.data << Gnuplot::DataSet.new([xvals, reply]) do |ds|
          ds.title = "smoothed"
          ds.with = "linespoints"
        end
      end
    end

  end
end

