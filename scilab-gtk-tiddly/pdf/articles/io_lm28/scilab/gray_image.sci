function gray_image(img)
  xset("colormap",graycolormap(double(max(img))+1))
  xset("wdim",size(img,1),size(img,2)) //taille de la fenêtre
  xsetech(arect=0*[1 1 1 1]) //suppression des marges
  Matplot(img',"020") //affichage
endfunction 
