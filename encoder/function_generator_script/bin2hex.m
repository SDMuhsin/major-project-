function dgt = bin2hex(wrdin)
%%matrix indeices 1, 2, 3, ... n
%%powers: MSBfirst 31, 29, 28, ... 0 LSBlast
   dgt=char([]);
   wrd=[];
   if(isequal(class(wrdin),'char'))
     for i=1:length(wrdin)
       if(wrdin(1,i) == '0')
         wrd=[wrd,0];
       else
         wrd=[wrd,1];
       end
     end
   else
     wrd = wrdin;
   end
   %length correction
      nzeros=(ceil(length(wrdin)/4)*4)-(length(wrdin));
      wrd=[wrd(1,1)*ones(1,nzeros),wrd];
      
   for i=1:4:length(wrd)
      if(wrd(i:i+3)==[0,0,0,0])
               dgt = [dgt,'0'];
      else
          if(wrd(i:i+3)==[0,0,0,1])
               dgt = [dgt,'1'];
          else
              if(wrd(i:i+3)==[0,0,1,0])
               dgt = [dgt,'2'];               
          else
              if(wrd(i:i+3)==[0,0,1,1])
               dgt = [dgt,'3'];
          else
              if(wrd(i:i+3)==[0,1,0,0])
               dgt = [dgt,'4'];
          else
              if(wrd(i:i+3)==[0,1,0,1])
               dgt = [dgt,'5'];
          else
              if(wrd(i:i+3)==[0,1,1,0])
               dgt = [dgt,'6'];
          else
              if(wrd(i:i+3)==[0,1,1,1])
               dgt = [dgt,'7'];
          else
              if(wrd(i:i+3)==[1,0,0,0])
               dgt = [dgt,'8'];
          else
              if(wrd(i:i+3)==[1,0,0,1])
               dgt = [dgt,'9'];
          else
              if(wrd(i:i+3)==[1,0,1,0])
               dgt = [dgt,'A'];
          else
              if(wrd(i:i+3)==[1,0,1,1])
               dgt = [dgt,'B'];
          else
              if(wrd(i:i+3)==[1,1,0,0])
               dgt = [dgt,'C'];               
          else
              if(wrd(i:i+3)==[1,1,0,1])
               dgt = [dgt,'D'];
          else
              if(wrd(i:i+3)==[1,1,1,0])
               dgt = [dgt,'E'];
          else
              if(wrd(i:i+3)==[1,1,1,1])
               dgt = [dgt,'F'];
              end
              end
              end
              end
              end
              end
              end
              end
              end
              end  
              end
              end
            end
          end
          end
      end
            
   end
   

end