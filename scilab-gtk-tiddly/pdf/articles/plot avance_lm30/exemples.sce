// courbe d'une fonction Scilab
function y=f(x),y=abs(sin(x)),endfunction
xbasc();
fplot2d(linspace(0,2*%pi,100),f)

// Courbe d'une fonction tabul\'ee

p=linspace(0,10,100) ;
x=p.*sin(p) ;
y=p.*cos(p) ;
xbasc() ;plot2d(x,y)

//Trace de plusieurs courbes

// Meme abcisse
x=linspace(0,2*%pi,100) ;
y=[sin(x)', sin(2*x-1)'] ;
xbasc() ;plot2d(x,y)

//Abcisses differententes
x1=linspace(0,2*%pi,100) ;
x2=linspace(0,2*%pi,10) ;
xbasc() ;
plot2d(x1,sin(x1),style=5)
plot2d(x2,sin(x2)+rand(x2)/10,style=-2)

//Options de type et de couleur
p=linspace(0,10,100) ;
x=p.*sin(p) ;
y1=p.*cos(p) ;y2=p.*cos(2*p) ;
xbasc() ;
xset('line style',2) ;plot2d(x,y1,style=5)
xset('color',3) ;plot2d(x,y2,style=-2)

// Trace des axes 
xset('background',33)
xset('foreground',34)
xbasc() ;plot2d(x,y2,style=5,axesflag=4)

// Titres et legendes
x1=linspace(0,2*%pi,100) ;
xbasc() ;
plot2d(x1,10.^x1,style=5,logflag='nl')
legends(['10^x'],5,1) //ajoute un cartouche en haut a droite
//ajoute un titre et des etiquettes d'axes
xtitle('A linear/Log plot','x','y')

// Axes particuliers
x1=linspace(0,2*%pi,100) ;
xbasc() ;plot2d(x1,sin(x1),style=5,axesflag=2)
drawaxis(dir='d',x=0:7,val=['a','b','c','e','f','g','h','i'])

// Courbes en escalier
x1=linspace(0,2*%pi,30) ;
xbasc() ;plot2d2(x1,sin(x1),style=3)

//Repr\'esentation par barres verticales
x1=linspace(0,2*%pi,30) ;
xbasc() ;plot2d3(x1,sin(x1),style=3)

// Histogramme
x=rand(1,3000,'normal') ;
xbasc() ;histplot(100,x,style=2)

// Coordonnees polaires
t= (0:.01:2*%pi)'
xbasc() ;polarplot([sin(7*t') sin(6*t')],[cos(8*t') cos(8*t')],[1,2])

// Visualisation isometrique
t=linspace(0,2*%pi,100) ;
xbasc() ;plot2d(sin(t),cos(t))
xbasc() ;plot2d(sin(t),cos(t),frameflag=4)

// Surface definie par une fonction z=F(x,y)
function z=f(x,y),z=(2*x^2*y+y^2)/(x^2+2*y^2),endfunction
x=-7:0.55:7;
xbasc();fplot3d(x,x,f)

// Changer couleur de la surface
xbasc();fplot3d(x,x,f,flag=[3,2,2])

// Rotation

fplot3d(x,x,f,theta=115,alpha=63,flag=[3,2,2])

// Representation matricielle de la surface par z=feval(x,x,f) ou par 
Y=ones(x')*x ;X=x'*ones(x);
z=(2*X.^2 .*Y+Y.^2)./(X.^2+2*Y.^2) ;

// Utilisation de plot3d
xbasc();xset('color',5) ;xset('hidden3d',24) ;
plot3d(x,x,z,theta=115,alpha=63)

// Colorier les surfaces en fonction de la hauteur
xset('colormap',hotcolormap(128))
xbasc();plot3d1(x,x,z)

// Representation 2D des fonctions 3D
xbasc();grayplot(x,x,z)

// Ajout des courbes iso-valeur
contour2d(x,x,z,10)

// Valeurs non definies
z(10 :15,17:22)=%nan ;
xbasc() ;plot3d1(x,x,z)

// Representation par facettes
// calcul des facettes
[xx,yy,zz]=genfac3d(x,x,z);
function [x,y,z]=sph(alp,tet)
  x=r*cos(alp).*cos(tet)+orig(1)*ones(tet);
  y=r*cos(alp).*sin(tet)+orig(2)*ones(tet)
  z=r*sin(alp)+orig(3)*ones(tet)
endfunction
r=2;//le rayon de la sph\`ere
orig=[-3 3 7/3+r];//le centre de la sph\`ere
[xx1,yy1,zz1]=eval3dp(sph,linspace(-%pi/2,%pi/2,20),linspace(0,%pi*2,20));                              
// Concatenation des deux ensembles de facettes
X=[xx,xx1] ;
Y=[yy,yy1] ;
Z=[zz,zz1] ;

// Visualisation
xbasc() ;plot3d1(X,Y,Z,flag=[-1,4,4])

// Acquisition des coordonnees d'un point
xbasc() ;plot2d()
[btn,x,y]=xclick()

// Suivre la souris
xset('window',0)
while %t
  rep=xgetmouse() ;
  plot2d(rep(1),rep(2),-3)
  if rep(3)==2 then break,end
end
