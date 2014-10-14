#include "mex.h"
#include <memory.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <algorithm>
#include <assert.h>

using namespace std;

// a' * b
double v_times(double* a, double* b, int d){
    double rtn = 0;
    for (int i = 0; i < d; ++i){
        rtn += a[i] * b[i];
    }
    return rtn;
}

// v = v .* scale
void times_scale(double* v,  double scale, int d){
    for (int i = 0; i < d; ++i){
        v[i] = v[i] * scale;
    }
}

double* v_plus(double* a, double* b, int d){
    for (int i = 0; i < d; ++i){
        a[i] = a[i] + b[i];
    }
    return a;
}

#define NUMBER_OF_FIELDS (sizeof(field_names)/sizeof(*field_names))

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {
                     
    if (nrhs !=3){
        mexErrMsgTxt("Input agruments number != 3");
    } 
    
    /* =========================== INPUT =========================== */
    
    double* Y_ptr = mxGetPr(prhs[0]);
	int Y = Y_ptr[0];
    double* X_init = mxGetPr(prhs[1]);
	int D = mxGetM(prhs[1]);
	double* X = new double[D];
	memcpy(X, X_init, D * sizeof(double));
    /* -------- options ---------- */

    mxArray* w_ptr = mxGetField(prhs[2],0,"w");
    if (!w_ptr) mexErrMsgTxt("model.w is null");
	double* w_init = mxGetPr(w_ptr);
	double* w = new double[D];
	memcpy(w, w_init, D * sizeof(double));

    /* =========================== INIT OUTPUT =========================== */

	int hat_y_t;
	double l_t;

    /* =========================== PRODUCE =========================== */

    double f_t;
	f_t = v_times(w, X, D);	

	if (f_t >= 0)
       hat_y_t = 1;
    else
       hat_y_t = -1;

	/****DEFINE your LOSS function below*****/
	/* e.g., l_t=(hat_y_t~=y_t) for 0-1 loss*/
	if (hat_y_t == Y)
	   l_t = 0;
	else 
	   l_t = 1;

	/* Update when l_t>0 */
	if (l_t > 0)
	{
		/****DEFINE your UPDATE function below****/
		/* e.g., w = w + y_t*x_t; for Perceptron */
	    times_scale(X, Y, D);
	    w = v_plus(w, X, D);
	}

    /* =========================== UPDATE OUTPUT =========================== */

	const char *field_names[] = {"w"};
    plhs[0] = mxCreateStructMatrix(1, 1, NUMBER_OF_FIELDS, field_names);
	mxArray* w_mxarray = mxCreateDoubleMatrix(D,1,mxREAL);
	double* w_ptr_mxarray = mxGetPr(w_mxarray);
	memcpy(w_ptr_mxarray, w, D * sizeof(double));
	mxSetField(plhs[0], 0, "w", w_mxarray);

    plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* hat_y_t_ptr = mxGetPr(plhs[1]); 
	hat_y_t_ptr[0] =  hat_y_t;
	plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* l_t_ptr = mxGetPr(plhs[2]); 
    l_t_ptr[0] = l_t;
    
    /* =========================== FREE MEMORY =========================== */

	delete[] w;
	delete[] X;    
}
