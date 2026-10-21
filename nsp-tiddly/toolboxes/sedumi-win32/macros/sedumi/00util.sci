
function y=xx_isnan_sp(x)
  // should give a boolean sparse but 
  [ij,v]=spget(x);
  I=find(isnan(v));
  y=sparse(ij(I,:),ones(size(I,'*'),1),size(x))
endfunction

function y=xx_isinf_sp(x)
  [ij,v]=spget(x);
  I=find(isinf(v));
  y=sparse(ij(I,:),ones(size(I,'*'),1),size(x))
endfunction

function y=xx_randn(m,n)
  y=randn(m,n);
endfunction

function y=and_m(x,mode)
// In the matlab spirit for matrices 
// note that and exists for booleans but 
// not with the 'r' convention by default.
  if nargin<=1 then mode='r';end 
  [m,n]=size(x);
  if m==1 || n==1 then 
    y=and(m2b(x));
  else
    y=and(m2b(x),mode);
  end
endfunction

function y=or_sp(x)
  [ij,v]=spget(x);
  y=or(v==1) 
endfunction


