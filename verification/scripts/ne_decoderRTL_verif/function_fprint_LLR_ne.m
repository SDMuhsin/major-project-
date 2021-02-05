function printed = function_fprint_LLR_ne(filename,LLR_var,resolution,bits,abs_en,print_en,hex_en,bin_en)
  [row,col] = size(LLR_var);
  if(print_en)
    if(abs_en)
      %saving bin data
      file2open = sprintf('./outputs/%s',filename);
      fid = fopen(file2open,'wt');
      absqb2h=[];
     for ik=1:row  
      for jk=1:col%1:length(LLR_var)
        absQbin = dec2bin(abs(LLR_var(ik,jk)/resolution),bits-1);   
        absQchar = absQbin;   
        absqb2h=[absQchar,absqb2h];  
        absQcharhex = bin2hex(absQchar);%bin2hex(['0','0','0',absQchar]); 
        if(hex_en==0)
          if(bin_en)
            printtxt=sprintf('%s\n', absQchar);%hex_en=0, bin_en=1, print each symbol binary bits in each line
          else
            printtxt=sprintf('%s\n', absQcharhex); %hex_en=0, bin_en=0, print each symbol hex char in each line
          end        
          fprintf(fid,'%c',transpose(printtxt));
        end%hexen==0 if        
      end%col jk
      if(hex_en)
        absQhex = bin2hex(absqb2h); %hex_en=1, dont print each symbol in new line, instead print a list of symbols in hex.
        printtxt=sprintf('%s\n', absQhex);
        fprintf(fid,'%c',transpose(printtxt));
      end        
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
        if(LLR_var(ik,jk)<0) %if negative then make 2's complement representation 
          Qchar = function_negdec2bin(LLR_var(ik,jk)/resolution,bits); 
        else
          Qchar = Qbin;       
        end
        qb2h=[Qchar,qb2h];%bigendian: MSB(high jk) left, LSB(low jk) on right ends.
        Qcharhex = bin2hex(Qchar);%bin2hex(['0','0',Qchar]);
        if(hex_en==0)
          if(bin_en)
            printtxt=sprintf('%s\n', Qchar); %hex_en=0, bin_en=1, print each symbol binary bits in each line
          else
            printtxt=sprintf('%s\n', Qcharhex); %hex_en=0, bin_en=0, print each symbol hex char in each line
          end        
          fprintf(fid,'%c',transpose(printtxt));
        end%hexen==0 if
        
      end%for col jk

      if(hex_en)
        Qhex = bin2hex(qb2h); %hex_en=1, dont print each symbol in new line, instead print a list of symbols in hex.
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
