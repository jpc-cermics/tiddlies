function img=ppm_get_bin(fd,ftyp,sz)
select ftyp
case 4 then //blanc et noir
  t=mgeti((sz(1)*sz(2))/8,'uc',fd);	
  f=uint8(2.^(0:7))
  img=matrix([(t&f(8))/f(8);(t&f(7))/f(7);
            (t&f(6))/f(6);(t&f(5))/f(5);
	    (t&f(4))/f(4);(t&f(3))/f(3);
            (t&f(2))/f(2);(t&f(1))/f(1)],sz);
case 5 then // niveau de gris
  img=matrix(mgeti(sz(1)*sz(2),'uc',fd),sz)
case 6 then // couleur
  img=matrix(mgeti(3*sz(1)*sz(2),'uc',fd),[3,sz])
end
endfunction
