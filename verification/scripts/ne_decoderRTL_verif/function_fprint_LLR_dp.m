function printed = function_fprint_LLR_dp(filename,LLR_var,resolution,bits,abs_en,print_en,hex_en,bin_en)
  [row,col] = size(LLR_var);
  if(print_en)
    if(abs_en)
      %saving bin data
      file2open = sprintf('./outputs/%s',filename);
      fid = fopen(file2open,'wt');
     for ik=1:row  
      for jk=1:col%1:length(LLR_var)
        absQbin = dec2bin(abs(LLR_var(ik,jk)/resolution),bits);   
        absQchar = absQbin;     
        absQcharhex = bin2hex(absQchar);%bin2hex(['0','0','0',absQchar]);  
        printtxt=sprintf('%s\n', absQcharhex);
        fprintf(fid,'%c',transpose(printtxt)); 
      end%col jk
        printtxt=sprintf('\n');
        fprintf(fid,'%c',transpose(printtxt));       
     end%row ik
      fclose(fid);
      printed=1;
      %saving bin data     
    else
      
      %saving bin data
      file2open = sprintf('./outputs/%s',filename);
      fid = fopen(file2open,'wt');
      qb2h=[];
     for ik=1:row
      for jk=1:col%1:length(LLR_var)
        Qbin = dec2bin(abs(LLR_var(ik,jk)/resolution),bits);
        binb=zeros(1,bits);
        binb(find(Qbin=='0'))=0;
        binb(find(Qbin=='1'))=1;
        if(LLR_var(ik,jk)<0) %if negative then make 2's complement representation
          binb= gf(binb,1);
          b1s=gf2toint(binb+1);
##          b1schar=['0','0','0','0','0','0'];
##          b1schar(find(b1s==0))='0';
##          b1schar(find(b1s==1))='1';        
          b1schar = function_numlist2strconv(b1s);
          Qchar = dec2bin(bin2dec(b1schar)+1,bits);
         %binb=binb+1+gf([0,0,0,0,0,1],1);
        else
          Qchar = Qbin;       
        end
        qb2h=[Qchar,qb2h];%bigendian: MSB(high jk) left, LSB(low jk) on right ends.
        Qcharhex = bin2hex(Qchar);%bin2hex(['0','0',Qchar]);
        if(hex_en==0)
          if(bin_en)
            printtxt=sprintf('%s\n', Qchar);
          else
            printtxt=sprintf('%s\n', Qcharhex);
          end        
          fprintf(fid,'%c',transpose(printtxt));
        end%hexen==0 if
        
      end%for col jk

      if(hex_en)
        Qhex = bin2hex(qb2h);
        printtxt=sprintf('%s\n', Qhex);
        fprintf(fid,'%c',transpose(printtxt));
      end     
      
    end%for row ik
      fclose(fid);
      printed=1;
   end%abs_en
  
  else
    printed=0;
  end%print_en
          %saving bin data
end
