function [a]=graph()

STOP = 0; // variable me permettant de boucler dessus

//affichage d'une nouvelle fenetre
disp('creation d''une nouvelle fenetre') ;
gwin = (max(winsid())+1);// genere un nouveau numero de fenetre
xset('window',gwin);// affiche la nouvelle fenetre

// nouveaux coordonnees utilisateur
xsetech([0 0 1 1],[-10 -10 10 10]);

// ajout des menus de dessins

// definition du nom du menu
Nom_de_Menu = 'Dessin';

// definition des sous-menus
Sub_Menu    = ['Rectangle';'Polyline';'Fleche';'Cercle'];

// definition du type de fonctions associees au menu Dessin
Action      = list(0,'Dessin');

// definition du vecteur de callback
execstr(Nom_de_Menu + '_' + string(gwin) + '= [''Rec()''; ''Poly()''; ...
           ''Fleche()''; ''Cercle()'']');
addmenu(gwin,'Dessin',Sub_Menu,Action);

//definition de menu d'arret dans la fenetre graphique
Stop='STOP = 1; delmenu(''Stop''); delmenu(gwin,Nom_de_Menu); delmenu(gwin,''Stop'')'
execstr('Stop_' + string(gwin) + '= Stop')

// ajout du menu Stop dans la fenetre graphique
addmenu(gwin,'Stop');
// ajout du menu Stop dans la fenetre texte
addmenu('Stop')

//boucle infinie
while (STOP == 0)
end;
a= 0;
endfunction

// fonction de dessin du rectangle
function Rec()
  xset("alufunction",6);//nous passons en mode xor
  xinfo(" drawing a rectangle ");//nous affichons de l'information
  [b,x0,y0]=xclick(); 
  rep=[x0,y0,-1]; 
  x=x0; 
  y=y0;
  xrect(x0,y0,x-x0,y-y0);
  while rep(3)==-1 then
      rep=xgetmouse(0);
      if (rep(3) ~= 2) then 
        xrect(min(x,x0),max(y,y0),abs(x-x0),abs(y0-y));
        x=rep(1); y=rep(2);
        xrect(min(x,x0),max(y,y0),abs(x-x0),abs(y0-y));
      else
        xrect(min(x,x0),max(y,y0),abs(x-x0),abs(y0-y));
      end;
  end;
  xset("alufunction",3);//nous repassons en mode normale
endfunction

// fonction de dessin de la polyline
function Poly()
  xset("alufunction",6);//nous passons en mode xor
  xinfo(" cliquez avec le bouton droite ou du milieu. Bouton de gauche pour arreter ");//nous affichons de l'information
  a=locate(-1,1);// nous definissons les points a relier
    xpoly(a(1,:),a(2,:),"lines")
  xset("alufunction",3);
endfunction

// fonction de dessin de la fleche
function Fleche()
  xset("alufunction",6);//nous passons en mode xor
  xinfo("cliquez a gauche pour valider, a droite pour annuler");//nous repassons en mode normale
  a = locate(1);
  rep = [a(1) a(2) -1];
  v=[a(2) rep(2)]
  w=[a(1) rep(1)]
  xarrows(w,v,0.3);
  while rep(3) == -1,
    rep = xgetmouse(0)
    if (rep(3) ~= 2) then 
      xarrows(w,v,0.3);
      b=[rep(1) ; rep(2)];
      v=[a(2) b(2)]
      w=[a(1) b(1)]
      xarrows(w,v,0.3);
    else
      xarrows(w,v,0.3);
    end;
  end;
endfunction

// fonction de dessin du cercle
function Cercle()  
  xset("alufunction",6);//nous passons en mode xor
  xinfo("cliquez a gauche pour valider, a droite pour annuler");//nous repassons en mode normale
  a = locate(1);
  rep = [a(1) a(2) -1];
  x=rep(1); y=rep(2);
  xarc(a(1),a(2),0,0,0,360*64);
  while rep(3) == -1,
    rep = xgetmouse(0)
    if (rep(3) ~= 2) then 
      xarc(min(x,a(1)),max(y,a(2)),abs(x-a(1)), abs(y-a(2)),0,360*64);
      x=rep(1); y=rep(2);
      xarc(min(x,a(1)),max(y,a(2)),abs(x-a(1)), abs(y-a(2)),0,360*64);
    else
      xarc(min(x,a(1)),max(y,a(2)),abs(x-a(1)), abs(y-a(2)),0,360*64);
    end;
  end;
endfunction

