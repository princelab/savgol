require 'spec_helper'

describe Savgol do
  describe 'padding' do
    let(:array) { [1, 2, 3, 4, -7, -2, 0, 1, 1] }
    it 'pads with the reverse geometrically inverted sequence' do
      expect(Savgol.sg_pad_ends(array, 2)).to eq [-1, 0, 1, 2, 3, 4, -7, -2, 0, 1, 1, 1, 2]
      expect(Savgol.sg_pad_ends(array, 3)).to eq [-2, -1, 0, 1, 2, 3, 4, -7, -2, 0, 1, 1, 1, 2, 4]
    end
  end
end

