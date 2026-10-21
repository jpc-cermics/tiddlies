// Linear prog 
// min c'*x 
//  10x1 -7x2 >=5 
//  x1 + x2/2 <=3 
//  x1 >= 0 x2>= 0
// en rajoutant x3 et x4 le pb equivaut a 
// min c'*x
// A*x=b 
// x_i >=0 

c=[1;-1;0;0];
A=[10,-7,-1,0;1,1/2,0,1];
b=[5;3];
x=sedumi(A,b,c);
if norm(full(x)-[1.9583;2.0833;0;0]) > 1.e-4 then pause;end 

[x,y,info]=sedumi(A,b,c);
[x,y,info]=sedumi(A,b,0*c);

K.l=1;K.r=3;
A=[0,0,0,1;1,1,0,0];
b=[sqrt(2);1.e7];
c=[0,0,1,0];
[x,y,info]=sedumi(A,b,c,K);

