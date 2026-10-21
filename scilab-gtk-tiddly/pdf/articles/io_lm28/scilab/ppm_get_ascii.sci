function img=ppm_get_ascii(fd,ftyp,sz)
//Lit les valeurs des pixels pour une image ASCII
if or(ftyp==[4 5]) then //N&B ou niveau de gris
  img=matrix(uint8(mfscanf(sz(1)*sz(2),fd,"%i ")),sz)
else
  img=matrix(uint8(mfscanf(3*sz(1)*sz(2),fd,"%i ")),[3,sz])
end
endfunction
