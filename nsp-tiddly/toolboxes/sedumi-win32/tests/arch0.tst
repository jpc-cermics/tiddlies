//exec('loader.sce')
load('../examples/arch0-nsp.mat');
[x,y,info]=sedumi(At,b,c,K);
if abs(full(c'*x) - (- 5.66517e-01)) > 1.e-5 then pause;end



