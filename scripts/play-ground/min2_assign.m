w = 6;
Wc = 32;

fname = sprintf('min2_assign.txt');
fid = fopen(fname,'w+');
for i = 1:1:Wc
  for j = 1:1:Wc
    fprintf(fid,"assign c2[%d][%d] = ", i-1,j-1 );
    if(i~=j)
        for k = 1:1:Wc
          if(k ~= i)
            fprintf(fid, "comp_array[%d][%d] ",j-1,k-1);
          endif
          if(k~=Wc )
            if( ~(k==Wc-1 && i == Wc) && ~( k == i))
              fprintf(fid,"&&");
            endif
          end
        endfor
     else
         fprintf(fid,"1'b0");           
     endif
    fprintf(fid,";\n");
  endfor
endfor
fprintf("\n")
fclose(fid);