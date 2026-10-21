function [ftyp,fd]=open_ppm(fil)
fd=mopen(fil,"rb") //ouverture du fichier



h=mgetl(fd,1) //lecture du type
//test du type qui doit être:
//    P1, P4 : image noir et blanc
//    P2, P5 : image en niveau de gris
//    P3, P6 : image couleur
ftyp=find(h=="P"+string(1:6))
if ftyp==[] then 
  error("Ce n"'est pas un fichier de type PBM, PGM ou PPM");
end
endfunction

