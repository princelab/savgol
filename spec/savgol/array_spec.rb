require 'spec_helper'

require 'savgol_shared_example'

require 'savgol/array'

describe Array do
  it_behaves_like "a savgol smoother"
end
