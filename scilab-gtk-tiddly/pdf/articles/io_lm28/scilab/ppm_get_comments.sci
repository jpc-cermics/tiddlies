function head=ppm_get_comments(fd)
head=[];
while %t
  pos=mtell(fd);//mémorise la position courante
  ligne=mgetl(fd,1) //lit une ligne comme du texte
  first=part(ligne,1) //le premier caractère de la ligne
  if first ~="#" then //est une ligne de commentaire
    mseek(pos,fd) //positionnement au point mémorisé
    break
  end	
  head=[head;ligne]
end
endfunction
