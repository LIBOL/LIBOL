% This make.m is for MATLAB and OCTAVE under Windows, Mac, and Unix
init;

disp('Please wait for compiling the core algorithms...');

cd libsvm
if (is_octave)
  mex libsvmread.c
else
  mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims libsvmread.c
end
cd ..

cd algorithms_mex
make
cd ..
