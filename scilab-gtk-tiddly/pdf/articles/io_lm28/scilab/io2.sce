mprintf("Donnez le nom de l"'article,"+..
            " son prix, son poids et le nombre en stock\n")
while %t
  [n,name,prix,poids,nombre]=mscanf("%s %f %f %d")
  if n==4 then break,end
  mprintf("Saisie incorrecte !\n");
end
mprintf("\n%s prix=%.2fF, poids=%.2fkg, stock=%d\n",..
                          name,prix,poids,nombre)
		      
