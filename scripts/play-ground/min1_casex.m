w = 6;
Wc = 32;

fname = sprintf('min1_casex.txt');
fid = fopen(fname,'w+');

fprintf(fid,"casex(min1_onehot)\n")
for i = 1:1:Wc
   fprintf(fid,"\t %d'b",Wc);
   for j = 1:1:Wc
     if(i == j)
      fprintf(fid,"1");
     elseif(j<i)
      fprintf(fid,"0");
     else
      fprintf(fid,"x");
     endif
   endfor
   fprintf(fid,": begin\n");
   
   fprintf(fid,"\t\t min1 = inp_sep[%d];\n",Wc-i);
   fprintf(fid,"\t\t min2_onehot = c2[%d];\n",Wc-i);
   fprintf(fid,"\t\t index = %d; \n",Wc - i);
   
   fprintf(fid,"\t end\n");
endfor
fprintf(fid,"endcase")
fclose(fid);