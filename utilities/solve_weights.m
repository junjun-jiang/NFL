
function W = solve_weights(X,x,K,tau)

tol = tau;
z   = X-repmat(x,1,K);                       % shift ith pt to origin
C   = z'*z;                                  % local covariance
C   = C + eye(K,K)*tol*trace(C); % regularlization (K>D)
W   = C\ones(K,1);                           % solve Cw=1
W   = W/sum(W);                              % enforce sum(w)=1