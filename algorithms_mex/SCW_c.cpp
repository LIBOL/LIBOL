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
    
    mxArray* Sigma_ptr = mxGetField(prhs[2],0,"Sigma");
    if (!Sigma_ptr) mexErrMsgTxt("model.Sigma is null");
	double* Sigma_init = mxGetPr(Sigma_ptr);
	double* Sigma = new double[D*D];
	memcpy(Sigma, Sigma_init, D*D* sizeof(double));
    
    mxArray* phi_ptr = mxGetField(prhs[2],0,"phi");
    if (!phi_ptr) mexErrMsgTxt("model.phi is null");
	double phi = mxGetScalar(phi_ptr);
	double psi   = 1 + (pow(phi,2))/2;
    double xi    = 1 + pow(phi,2);
    
    mxArray* C_ptr = mxGetField(prhs[2],0,"C");
    if (!C_ptr) mexErrMsgTxt("model.C is null");
	double C = mxGetScalar(C_ptr);    
    
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
    
    double* v_S_x_t = v_times_m(X, Sigma, D);
    double v_t = v_times(v_S_x_t, X, D);
    
    double m_t = Y*f_t;
    l_t = phi*sqrt(v_t)-m_t;

	if (l_t > 0)
	{
	    double alpha_t = max(0,(-m_t*psi+sqrt((pow(m_t,2)*pow(phi,4))/4+v_t*pow(phi,2)*xi))/(v_t*xi));
        alpha_t = min(alpha_t, C);
        double u_t = 0.25*pow(-alpha_t*v_t*phi+sqrt(pow(alpha_t,2)*pow(v_t,2)*pow(phi,2)+4*v_t),2);
        double beta_t = alpha_t*phi/(sqrt(u_t)+alpha_t*phi*v_t);
        for (int i = 0; i < D; i++)
            for (int j = 0; j < D; j++)
                Sigma[i*D+j] = Sigma[i*D+j] - beta_t*v_S_x_t[i]*v_S_x_t[j];        
	    times_scale(v_S_x_t, alpha_t*Y, D);
        w = v_plus(w, v_S_x_t, D);
	}
    
    /* =========================== UPDATE OUTPUT =========================== */

	const char *field_names[] = {"w","Sigma","phi","C"};
    plhs[0] = mxCreateStructMatrix(1, 1, NUMBER_OF_FIELDS, field_names);
	mxArray* w_mxarray = mxCreateDoubleMatrix(D,1,mxREAL);
	double* w_ptr_mxarray = mxGetPr(w_mxarray);
	memcpy(w_ptr_mxarray, w, D * sizeof(double));
    mxSetField(plhs[0], 0, "w", w_mxarray);
    
    mxArray* phi_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* phi_ptr_mxarray = mxGetPr(phi_mxarray);
    phi_ptr_mxarray[0] = phi;
    mxSetField(plhs[0], 0, "phi", phi_mxarray);
    
	mxArray* Sigma_mxarray = mxCreateDoubleMatrix(D,D,mxREAL);
	double* Sigma_ptr_mxarray = mxGetPr(Sigma_mxarray);
	memcpy(Sigma_ptr_mxarray, Sigma, D* D * sizeof(double));    
	mxSetField(plhs[0], 0, "Sigma", Sigma_mxarray);
    
    mxArray* C_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* C_ptr_mxarray = mxGetPr(C_mxarray);
    C_ptr_mxarray[0] = C;
    mxSetField(plhs[0], 0, "C", C_mxarray);     
    
    plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* hat_y_t_ptr = mxGetPr(plhs[1]); 
	hat_y_t_ptr[0] =  hat_y_t;
	plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* l_t_ptr = mxGetPr(plhs[2]); 
    l_t_ptr[0] = l_t;
    
    /* =========================== FREE MEMORY =========================== */

	delete[] w;
	delete[] X;
    delete[] Sigma;
    delete[] v_S_x_t;
    
    
}
