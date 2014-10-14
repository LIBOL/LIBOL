#include "mex.h"
#include <memory.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <algorithm>
#include <assert.h>

using namespace std;

#define NUMBER_OF_FIELDS (sizeof(field_names)/sizeof(*field_names))

void mexFunction(int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[]) {

  if (nrhs < 1){
    mexErrMsgTxt("Input agruments number < 1");
  } 

  double* R_ptr = mxGetPr(prhs[0]);
  int M = mxGetM(prhs[0]);
  int N = mxGetN(prhs[0]);
  if (nrhs == 2) {
    srand(unsigned(*mxGetPr(prhs[1])));
  }
  plhs[0] = mxCreateDoubleMatrix(M,N,mxREAL);
  double* P_ptr = mxGetPr(plhs[0]); 
  memcpy(P_ptr, R_ptr, M*N*sizeof(double));
  random_shuffle(P_ptr, P_ptr+M*N);
}

