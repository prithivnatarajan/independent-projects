function [ mu1, s ] = wide_distribution_learn( Xtrn, Ytrn, nu, C, solver)
%This function learns a Gaussian distribution of non-homogenous linear classifiers
%   INPUT: 
%   - Ytrn is the training vector of labels in {-1, +1}
%   - Xtrn is the training matrix of instances in R^(m x d) (where d is the
%        dimension of the data)
%   - Both nu and C are parameters that influence accuracy. They are described in the paper (CIKM'14). 
%   - Solver is 1 if SDPT3, 2 if SEDUMI, and 3 if MOSEK (3 is recommended)
%   OUTPIT:
%   - mu is the mean of the distribution
%   - s is a vecotr of the diagonal entries of the covariance matrix.
%   If instances are in R^d, then both mu and s are in R^(d+1) to account
%   for the biasing term. 

nu_c = norminv(nu);

%first step, add a constant component to X
n=size(Xtrn,2)+1;
m=size(Xtrn,1);
Xtrn = [ones(m,1) Xtrn];

%begin the CVX solver
cvx_begin
cvx_quiet(true)
if solver==1 
        cvx_solver sdpt3
elseif solver==2
        cvx_solver sedumi
elseif solver==3
        cvx_solver mosek
end

variable s(n)
variable mu1(n)
variable xi(m)
minimize (0.5*quad_over_lin(mu1, ones(1,n)*s) + C*ones(1,m)*xi)
subject to
        diag(Ytrn)*Xtrn*mu1 >= ones(m,1)+nu_c*(Xtrn.^2)*s-xi
        xi>=0
        s>=0
cvx_end



end
