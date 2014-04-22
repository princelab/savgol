shared_examples "a savgol smoother" do
  let(:smoother) do 
    object = described_class[1, 2, 3, 4, -7, -2, 0, 1, 1]
    object.extend(Savgol)
    object
  end

  describe 'smoothing a signal' do
    let(:smoother) do
      described_class[1, 2, 3, 4, 3.5, 5, 3, 2.2, 3, 0, -1, 2, 0, -2, -5, -8, -7, -2, 0, 1, 1]
    end

    it "works for the simple case" do
      numpy_savgol_output = [1.0, 2.0, 3.12857143, 3.57142857, 4.27142857, 4.12571429, 3.36857143, 2.69714286, 2.04, 0.32571429, -0.05714286, 0.8, 0.51428571, -2.17142857, -5.25714286, -7.65714286, -6.4, -2.77142857, 0.17142857, 0.91428571, 1.0]
      sg = smoother.savgol(5,3)
      sg.size.should == numpy_savgol_output.size

      numpy_savgol_output.each_with_index do |exp, i|
        expect(sg[i]).to be_within(0.000001).of(exp)
      end
    end
  end

end

=begin
    b = matrix([[ 1, -2,  4, -8],
          [ 1, -1,  1, -1],
          [ 1,  0,  0,  0],
          [ 1,  1,  1,  1],
          [ 1,  2,  4,  8]])

# b = np.matrix([[ 1, -2,  4, -8],[ 1, -1,  1, -1],[ 1,  0,  0,  0],[ 1,  1,  1,  1],[ 1,  2,  4,  8]])

    np.linalg.pinv(b)
    matrix([[ -8.57142857e-02,   3.42857143e-01,   4.85714286e-01, 3.42857143e-01,  -8.57142857e-02],
           [  8.33333333e-02,  -6.66666667e-01,   6.17335241e-17, 6.66666667e-01,  -8.33333333e-02],
             [  1.42857143e-01,  -7.14285714e-02,  -1.42857143e-01, -7.14285714e-02,   1.42857143e-01],
               [ -8.33333333e-02,   1.66666667e-01,  -8.12290576e-18, -1.66666667e-01,   8.33333333e-02]])

           [[-0.08571422965620183, 0.34285713252351957, 0.4857142762115429, 0.3428571132587409, -0.08571425328426403], 
           [0.08333333127000826, -0.6666665420778334, -1.4769869399753408e-08, 0.6666665456225483, -0.08333341040935828], 
           [0.14285713578428869, -0.07142855323765136, -0.1428571582020276, -0.07142860273009285, 0.14285714667073207], 
           [-0.08333333356934626, 0.16666666384543039, 5.837836155482957e-11, -0.16666665040013168, 0.0833333492046153]]



    np.linalg.pinv(b).A
    array([[ -8.57142857e-02,   3.42857143e-01,   4.85714286e-01,
          3.42857143e-01,  -8.57142857e-02],
          [  8.33333333e-02,  -6.66666667e-01,   6.17335241e-17,
            6.66666667e-01,  -8.33333333e-02],
            [  1.42857143e-01,  -7.14285714e-02,  -1.42857143e-01,
              -7.14285714e-02,   1.42857143e-01],
              [ -8.33333333e-02,   1.66666667e-01,  -8.12290576e-18,
                -1.66666667e-01,   8.33333333e-02]])

    m = array([-0.08571429,  0.34285714,  0.48571429,  0.34285714, -0.08571429])

    with 

	window_size = 5
    half_window = 2
    firstvals = array([-1.,  0.])
    lastvals = array([ 1.,  2.])
    concat array = array([-1. ,  0. ,  1. ,  2. ,  3. ,  4. ,  3.5,  5. ,  3. ,  2.2,  3. , 0. , -1. ,  2. ,  0. , -2. , -5. , -8. , -7. , -2. ,  0. ,  1. , 1. ,  1. ,  2. ])

    with window_size = 7
    half_window = 3
    firstvals = array([-2., -1.,  0.])
    lastvals = array([ 1.,  2.,  4.])
    concat array = array([-2. , -1. ,  0. ,  1. ,  2. ,  3. ,  4. ,  3.5,  5. ,  3. ,  2.2, 3. ,  0. , -1. ,  2. ,  0. , -2. , -5. , -8. , -7. , -2. ,  0. , 1. ,  1. ,  1. ,  2. ,  4. ])

    The final output:
    savgol
array([ 1.        ,  2.        ,  3.12857143,  3.57142857,  4.27142857,
        4.12571429,  3.36857143,  2.69714286,  2.04      ,  0.32571429,
       -0.05714286,  0.8       ,  0.51428571, -2.17142857, -5.25714286,
       -7.65714286, -6.4       , -2.77142857,  0.17142857,  0.91428571,  1.        ])

=end

