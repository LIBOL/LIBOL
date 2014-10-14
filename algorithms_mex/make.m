% This part is for OCTAVE
if(is_octave)
      mex rand_c.cpp;
      mex Perceptron_c.cpp;
      mex CW_c.cpp;
      mex PA_c.cpp;
      mex PA1_c.cpp;
      mex PA2_c.cpp;
      mex SOP_c.cpp;
      mex AROW_c.cpp;
      mex SCW_c.cpp;
      mex SCW2_c.cpp;
      mex OGD_c.cpp;
      mex ROMMA_c.cpp;
      mex aROMMA_c.cpp;
      mex ALMA_c.cpp;
      mex IELLIP_c.cpp;
      mex NAROW_c.cpp;
      mex NHERD_c.cpp;
      mex M_PerceptronM_c.cpp;
      mex M_PerceptronU_c.cpp;
      mex M_PerceptronS_c.cpp;
      mex M_PA_c.cpp;
      mex M_PA1_c.cpp;
      mex M_PA2_c.cpp;
      mex M_CW_c.cpp;
      mex M_SCW1_c.cpp;
      mex M_SCW2_c.cpp;
      mex M_AROW_c.cpp;
      mex M_ROMMA_c.cpp;
      mex M_aROMMA_c.cpp;
      mex M_OGD_c.cpp;
      mex NEW_ALGORITHM_c.cpp;
% This part is for MATLAB
% Add -largeArrayDims on 64-bit machines of MATLAB
else
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims rand_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims Perceptron_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims CW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims PA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims PA1_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims PA2_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims SOP_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims AROW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims SCW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims SCW2_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims OGD_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims ROMMA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims aROMMA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims ALMA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims IELLIP_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims NAROW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims NHERD_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PerceptronM_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PerceptronU_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PerceptronS_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PA1_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_PA2_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_CW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_SCW1_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_SCW2_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_AROW_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_ROMMA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_aROMMA_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims M_OGD_c.cpp;
      mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims NEW_ALGORITHM_c.cpp;
end
