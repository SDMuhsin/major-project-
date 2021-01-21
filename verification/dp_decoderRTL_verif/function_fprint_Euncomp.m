function printed = function_fprint_Euncomp(filename,LLR_var,resolution,bits,abs_en,print_en,hex_en,bin_en)
  if(print_en)
    if(abs_en)
      %saving bin data
      file2open = sprintf('./outputs/%s',filename);
      fid = fopen(file2open,'wt');

      [rowE,colE]=size(LLR_var);
   for ik=1:rowE
      printtxt=sprintf('Row=%d \n', ik);
      fprintf(fid,'%c',transpose(printtxt));
      for jk=1:colE
        absQbin = dec2bin(abs(LLR_var(ik,jk)/resolution),bits);   
        absQchar = absQbin;     
        absQcharhex = bin2hex(absQchar);%bin2hex(['0','0','0',absQchar]);  
        printtxt=sprintf('%s\n', absQcharhex);
        fprintf(fid,'%c',transpose(printtxt)); 
      end%for colE
    end%for rowE
      fclose(fid);
      printed=1;
      %saving bin data     
      
    else %if not absolute value
      file2open = sprintf('./outputs/%s',filename);
      fid = fopen(file2open,'wt');
      [rowE,colE]=size(LLR_var);
      qb2hwhole=[];
   for ik=1:rowE
      qb2h=[];
      printtxt=sprintf('Row=%d \n', ik);
      fprintf(fid,'%c',transpose(printtxt));
      for jk=1:colE
        Qbin = dec2bin(abs(LLR_var(ik,jk)/resolution),bits);
        binb=zeros(1,bits);
        binb(find(Qbin=='0'))=0;
        binb(find(Qbin=='1'))=1;
        if(LLR_var(ik,jk)<0)
          binb= gf(binb,1);
          b1s=gf2toint(binb+1); %1's complement= xor with 1
##          b1schar=['0','0','0','0','0','0'];
##          b1schar(find(b1s==0))='0';
##          b1schar(find(b1s==1))='1';        
          b1schar = function_numlist2strconv(b1s);
          Qchar = dec2bin(bin2dec(b1schar)+1,bits); %add 1 with 1's complement
         %binb=binb+1+gf([0,0,0,0,0,1],1);
        else
          Qchar = Qbin;       
        end
        qb2h=[Qchar,qb2h];
        Qcharhex = bin2hex(Qchar);%bin2hex(['0','0',Qchar]);
        if(hex_en==0)
          if(bin_en)
            printtxt=sprintf('%s\n', Qchar);
          else
            printtxt=sprintf('%s\n', Qcharhex);
          end                
          fprintf(fid,'%c',transpose(printtxt)); 
        end
      end%for colE
      qb2hwhole=[qb2hwhole,qb2h];
      if(hex_en)%((hex_en)||((hex_en==0)&&(bin_en==0)))
        Qhex = bin2hex(qb2h);
        printtxt=sprintf('%s\n', Qhex);
        fprintf(fid,'%c',transpose(printtxt));
      end    
      prte=0;
      prte=0;
    end%for rowE
    
    if(hex_en)%((hex_en)||((hex_en==0)&&(bin_en==0)))
      Qhexwhole = bin2hex(qb2hwhole);
      printtxt=sprintf('%s\n', Qhexwhole);
      fprintf(fid,'%c',transpose(printtxt));
    end    
      prte=0;
      prte=0;    
      fclose(fid);
      printed=1;
     end%abs_en else
  else
    printed=0;
  end%print_en

end
