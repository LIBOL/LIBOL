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

double* v_times_v(double* a, double* b, int d){
    double* m = new double[d*d];
    for (int i = 0; i < d; ++i)
        for (int j = 0; j < d; ++j)
            m[i*d+j] = a[i]*b[j];
    return m;
}

// mat1 [m*n] x mat2 [n*p]= mat3 [m*p]
double* v_times_m(double* v, double* m, int d){
   double* v_new = new double[d];
   for (int i = 0; i < d; ++i){
        v_new[i] = v_times(v, m+i*d, d);
   }
   return v_new;
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

double min(double a, double b){
	if(a < b)
	{b = a;}
	return b;
}

double max(double a, double b){
	if(a > b)
	{b = a;}
	return b;
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
    
    mxArray* alpha_ptr = mxGetField(prhs[2],0,"alpha");
    if (!alpha_ptr) mexErrMsgTxt("model.alpha is null");
	double alpha = mxGetScalar(alpha_ptr);
    
    mxArray* k_AL_ptr = mxGetField(prhs[2],0,"k_AL");
    if (!k_AL_ptr) mexErrMsgTxt("model.k_AL is null");
	double k_AL = mxGetScalar(k_AL_ptr);
    
    mxArray* p_ptr = mxGetField(prhs[2],0,"p");
    if (!p_ptr) mexErrMsgTxt("model.p is null");
	double p = mxGetScalar(p_ptr);    
    
    /* =========================== INIT OUTPUT =========================== */

	int hat_y_t;
	double l_t;
    double B = 1/alpha;     
    double C = 1.41421356237;
    /* =========================== PRODUCE =========================== */
    
    double f_t;
	f_t = v_times(w, X, D);

	

	if (f_t >= 0)
       hat_y_t = 1;
    else
       hat_y_t = -1;

	double gamma_k = B*sqrt(p-1)/sqrt(k_AL);
    l_t = (1-alpha)*gamma_k - Y*f_t;

	if (l_t > 0)
	{
        double eta_k   = C/(sqrt(p-1)*sqrt(k_AL));
        times_scale(X, Y*eta_k, D);
        w = v_plus(w, X, D);
        double norm_w = v_times(w,w,D);
        norm_w = sqrt(norm_w);
        times_scale(w, 1/max(1,norm_w),D);
        k_AL    = k_AL + 1;
	}
    
    /* =========================== UPDATE OUTPUT =========================== */

	const char *field_names[] = {"w","alpha","k_AL","p"};
    plhs[0] = mxCreateStructMatrix(1, 1, NUMBER_OF_FIELDS, field_names);
	mxArray* w_mxarray = mxCreateDoubleMatrix(D,1,mxREAL);
	double* w_ptr_mxarray = mxGetPr(w_mxarray);
	memcpy(w_ptr_mxarray, w, D * sizeof(double));
	mxSetField(plhs[0], 0, "w", w_mxarray);
    
    mxArray* alpha_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* alpha_ptr_mxarray = mxGetPr(alpha_mxarray);
    alpha_ptr_mxarray[0] = alpha;
    mxSetField(plhs[0], 0, "alpha", alpha_mxarray);   
    
    mxArray* k_AL_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* k_AL_ptr_mxarray = mxGetPr(k_AL_mxarray);
    k_AL_ptr_mxarray[0] = k_AL;
    mxSetField(plhs[0], 0, "k_AL", k_AL_mxarray);    
   
    mxArray* p_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* p_ptr_mxarray = mxGetPr(p_mxarray);
    p_ptr_mxarray[0] = p;
    mxSetField(plhs[0], 0, "p", p_mxarray);
    
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
