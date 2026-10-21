name=input("Donnez le nom de l"'article","string");
while %t 
  data=input("Donnez son prix, son poids et le nombre en stock");
  if size(data,"*")==3 then break,end
  mprintf("Saisie incorrecte !\n");
end
mprintf("\n%s prix=%.2fF, poids=%.2fkg, stock=%d\n",name,data)
	
