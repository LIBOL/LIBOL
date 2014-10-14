#include "mex.h"
#include <memory.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include <algorithm>
#include <assert.h>
#include <limits>

using namespace std;

void printMatrix(double* X,int m,int n){
    int i,j;
	for (i = 0; i < m; ++i){
        for (j = 0; j < n; ++j)
            mexPrintf("%f ",X[i*n+j]);
        mexPrintf("\n");
	}
	mexPrintf("\n");
}


// a' * b
double v_times(double* a, double* b, int d){
    double rtn = 0;
    for (int i = 0; i < d; ++i){
        rtn += a[i] * b[i];
    }
    return rtn;
}

double* mcv_times(double* a, double* b, int d, int nb_class){
    double* rtn = new double[nb_class];
    for (int i = 0; i < nb_class; ++i){
        rtn[i] = v_times(a+i*d, b, d);
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

double* max_of_vector(double* a, int d, int Y){
    double* max = new double[4];
    max[0] = a[0];// value of the maximum
    max[1] = 1;   // index of the maximum
    for(int i = 1; i < d; ++i){
       if(a[i] > max[0]){
           max[0] = a[i];
           max[1] = i+1;
       }
    }
    double tmp = a[Y-1];
    a[Y-1] = -numeric_limits<double>::infinity();
    max[2] = a[0];// value of the maximum except for Y
    max[3] = 1;
    for(int i = 1; i < d; ++i){
       if(a[i] > max[2]){
           max[2] = a[i];
           max[3] = i+1;
       }
    }    
    a[Y-1] = tmp;
    return max;
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
    mxArray* nb_class_ptr = mxGetField(prhs[2],0,"nb_class");
    if (!nb_class_ptr) mexErrMsgTxt("model.nb_class is null");
	int nb_class = mxGetScalar(nb_class_ptr);
    
    mxArray* W_ptr = mxGetField(prhs[2],0,"W");
    if (!W_ptr) mexErrMsgTxt("model.W is null");
	double* W_init = mxGetPr(W_ptr);
	double* W = new double[D*nb_class];
	memcpy(W, W_init, D*nb_class * sizeof(double));
    
    mxArray* Sigma_ptr = mxGetField(prhs[2],0,"Sigma");
    if (!Sigma_ptr) mexErrMsgTxt("model.Sigma is null");
	double* Sigma_init = mxGetPr(Sigma_ptr);
	double* Sigma = new double[D*D];
	memcpy(Sigma, Sigma_init, D*D* sizeof(double));
    
    mxArray* C_ptr = mxGetField(prhs[2],0,"C");
    if (!C_ptr) mexErrMsgTxt("model.C is null");
	double C = mxGetScalar(C_ptr);

    mxArray* phi_ptr = mxGetField(prhs[2],0,"phi");
    if (!phi_ptr) mexErrMsgTxt("model.phi is null");
	double phi = mxGetScalar(phi_ptr);
	double psi   = 1 + (pow(phi,2))/2;
    double xi    = 1 + pow(phi,2);
    
    
    /* =========================== INIT OUTPUT =========================== */

	int hat_y_t;
	double l_t;

    /* =========================== PRODUCE =========================== */
    
    double* F_t = mcv_times(W, X, D, nb_class);
    double* mc_result = max_of_vector(F_t, nb_class, Y);
    hat_y_t = mc_result[1];
    double F_max = mc_result[0];
    double Fs_max = mc_result[2];
    int s_t = mc_result[3]; 

    double* v_S_x_t = v_times_m(X, Sigma, D);
    double v_t = v_times(v_S_x_t, X, D);    
    double m_t = F_t[Y-1] - F_t[s_t-1];
    l_t = phi*sqrt(v_t) - m_t;

	if (l_t > 0)
	{
        double alpha_t=max(0, (-m_t*psi+sqrt(pow(m_t,2)*pow(psi,2)-pow(m_t,2)*psi+2*v_t*pow(phi,2)*psi))/(2*v_t*psi));
        alpha_t = min(alpha_t, C);
        double u_t= 0.125*pow((-alpha_t*v_t*phi+sqrt(pow(alpha_t,2)*pow(v_t,2)*pow(phi,2)+8*v_t)),2);
        double beta_t=alpha_t*phi/(sqrt(2*u_t)+alpha_t*phi*v_t);

        for (int i = 0; i < D; i++)
            for (int j = 0; j < D; j++)
                Sigma[i*D+j] = Sigma[i*D+j] - beta_t*v_S_x_t[i]*v_S_x_t[j];           
        
        times_scale(v_S_x_t, alpha_t, D);  
	    memcpy(W+(Y-1)*D,v_plus(W+(Y-1)*D, v_S_x_t, D),D*sizeof(double));
        times_scale(v_S_x_t, -1, D);
        memcpy(W+(s_t-1)*D,v_plus(W+(s_t-1)*D, v_S_x_t, D),D*sizeof(double));
	}
    
    /* =========================== UPDATE OUTPUT =========================== */

	const char *field_names[] = {"W","nb_class","Sigma","phi","C"};
    plhs[0] = mxCreateStructMatrix(1, 1, NUMBER_OF_FIELDS, field_names);
	mxArray* W_mxarray = mxCreateDoubleMatrix(D,nb_class,mxREAL);
	double* W_ptr_mxarray = mxGetPr(W_mxarray);
	memcpy(W_ptr_mxarray, W, D*nb_class * sizeof(double));
    mxSetField(plhs[0], 0, "W", W_mxarray);
    
    mxArray* nb_class_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* nb_class_ptr_mxarray = mxGetPr(nb_class_mxarray);
    nb_class_ptr_mxarray[0] = nb_class;
    mxSetField(plhs[0], 0, "nb_class", nb_class_mxarray);
    
	mxArray* Sigma_mxarray = mxCreateDoubleMatrix(D,D,mxREAL);
	double* Sigma_ptr_mxarray = mxGetPr(Sigma_mxarray);
	memcpy(Sigma_ptr_mxarray, Sigma, D* D * sizeof(double));    
	mxSetField(plhs[0], 0, "Sigma", Sigma_mxarray);    
    
    mxArray* C_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* C_ptr_mxarray = mxGetPr(C_mxarray);
    C_ptr_mxarray[0] = C;
    mxSetField(plhs[0], 0, "C", C_mxarray); 
    
    mxArray* phi_mxarray = mxCreateDoubleMatrix(1,1,mxREAL);
    double* phi_ptr_mxarray = mxGetPr(phi_mxarray);
    phi_ptr_mxarray[0] = phi;
    mxSetField(plhs[0], 0, "phi", phi_mxarray);
    
    plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* hat_y_t_ptr = mxGetPr(plhs[1]); 
	hat_y_t_ptr[0] =  hat_y_t;
	plhs[2] = mxCreateDoubleMatrix(1,1,mxREAL);
	double* l_t_ptr = mxGetPr(plhs[2]); 
    l_t_ptr[0] = l_t;
    
    /* =========================== FREE MEMORY =========================== */

	delete[] W;
	delete[] X;
    delete[] F_t;
    delete[] mc_result;
    delete[] Sigma;
    delete[] v_S_x_t;    
    
}
