//----------

function [At,b,c,K]=rls(P,q)
  [m,n]=size(P)
  b = -sparse([1;1;zeros(n,1)]);
  
  At = [-1,zeros(1,n+1);
	zeros(m,2),P];
  c=[0;q];
  K.q = 1+m;
  At=[At; 0,-1,zeros(1,n);
      zeros(1,n+2);
      zeros(n,2),-eye(n,n)];
  At= sparse(At);
  c = sparse([c;0;1;zeros(n,1)]);
  K.q = [K.q,2+n];
endfunction;

P=[3,1,4;0,1,1;-2,5,3;1,4,5];
q=[0;2;1;3];
[At,b,c,K]=rls(P,q);
[x,y,info]=sedumi(At,b,c,K);

if norm(eigK(x,K) - [0;1.4142;0;1.4142]) > 1.e-4 then pause;end 
if norm(eigK(c + (-At*y),K) - [0;3.2307;0;1.4827]) > 1.e-4 then pause;end 

//----------

a1 = zeros(1,length(y)); a1(3)=1;
c=[sparse(-0.1);c];
A1t=[sparse(a1);At];
K.l=1;
[x,y,info]=sedumi(A1t,b,c,K);
if norm(eigK(c +(-A1t*y),K) -[0;0;3.2307;0;1.4904])> 1.e-4 then pause;end 

//----------

clear K;
c=[0,1,0];
b=sqrt(2);
A=[0,0,1];
K.r = 3;
[x,y,info]=sedumi(A,b,c,K);

//---------

clear K;
c=[0,0,1,0];
b=[sqrt(2);1.e7];
A=[0,0,0,1;1,1,0,0];
K.l = 1; K.r = 3;
[x,y,info]=sedumi(A,b,c,K);

//----------

function [At,b,c,K]=specfac(b)
  m=length(b);
  c= diag([m-1:-1:0]);
  c= sparse(c(:));
  e =ones(m,1);
  At = sparse([],[],[m^2,m]);
  for k=1:m 
    xx= diag(e,k-1);
    xx=xx(1:m,1:m)
    At(:,k)= sparse(xx(:));
  end
  K.s=m
endfunction;

b=[2;0.2;-0.3];
[At,b,c,K]=specfac(b);
[x,y,info]=sedumi(At,b,c,K);

[m,n]=size(At);

[spec(matrix(x,n,n)), eigK(x,K)];

//-----------------------------

function [At,b,c,K] = toepest(P)
// [At,b,c,K] = toepest(P)
// Creates dual standard form for Toeplitz-covariance estimation
  m = size(P,1);
  // ---------- maximize y(m+1) ----------
  b = [spcol_create(m,1); sparse(1)];
  // ----- Let e be all-1, and allocate space for the A-matrix -----
  e = ones(m,1);
  K.q = [1 + m*(m+1)/2];
  K.xcomplex = 2:K.q(1);      //Norm-bound entries are complex valued
  At = sparse([],[],[K.q(1) + m^2,m+1]);
  // ---------- constraints ----------
  // -y(m+1) >= norm( vec(P) - sum(y_i * Ti) )     (Qcone)
  // sum(y_i * Ti) is psd                          (Scone)
  // ---------------------------------
  xx=(2:(m+1))';
  At(:,1) = [sparse([xx,ones(size(xx))],ones(size(xx)),[K.q(1),1]); sparse(- eye(m,m)(:))];
  c = [0; diag(P)];
  firstk = m+2;
  for k = 1:(m-1)
    lastk = firstk + m-k-1;
    // Ti = spdiags(e,k,m,m);
    Ti = diag(e,k);Ti=Ti(1:m,1:m);Ti=Ti(:);
    xx=(firstk:lastk)';
    At(:,k+1) = [sqrt(2) * sparse([xx,ones(size(xx))],ones(size(xx)),[K.q(1),1]);sparse( -2*(Ti))];
    c = [c; sqrt(2) * diag(P,k)];
    firstk = lastk + 1;
  end
  At(:,m+1) = [sparse(1); spcol_create(K.q(1) + m^2-1,1)];   // "objective" variable y(m+1)
  c = [c; zeros(m^2,1)];              // all-0 in the psd-part
  K.s = [m];
  K.scomplex=1;                       
  //Complex Hermitian PSD
  // ---------- y(2:m) complex, y(1) and y(m+1) real ----------
  K.ycomplex = 2:m;
endfunction;

P=[4, 1+2*%i, 3-%i; 1-2*%i, 3.5, 0.8+ 2.3*%i; 3+%i, 0.8-2.3*%i,4];

[At,b,c,K] = toepest(P);
[x,y,info]= sedumi(At,b,c,K);

z= c+ (-At*y);
Z=mat(z(K.q+1:length(z)));
Z=(Z+Z')/2;

Zex=[4.2827,0.8079+1.7342*%i, 2.5574 - 0.7938*%i; 
     0.8079-1.7342*%i, 4.2827, 0.8079+1.7342*%i;
     2.5574 + 0.7938*%i, 0.8079-1.7342*%i,4.2827];

if norm(Zex-Z) > 1.e-3 then pause;end 

