function [sz,nc]=ppm_get_size(fd,ftyp)
// Dimensions de l'image
ligne=mgetl(fd,1);
execstr("sz=["+ligne+"]");
// Nombre de couleurs
if and(ftyp<>[1,4]) then 
  ligne=mgetl(fd,1);
  execstr("nc="+ligne);
else
  nc=[];
end
endfunction
