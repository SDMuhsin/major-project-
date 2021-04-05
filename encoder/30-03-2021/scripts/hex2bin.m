function dgt = hex2bin(wrd)
%%matrix indeices 1, 2, 3, ... n
%%powers: MSBfirst 31, 29, 28, ... 0 LSBlast
   n=length(wrd)*4;
   dgt=[];
   for i=1:length(wrd)
       switch wrd(i)
           case '0'
               dgt = [dgt,0,0,0,0];
           case '1'
               dgt = [dgt,0,0,0,1];
           case '2'
               dgt = [dgt,0,0,1,0];               
           case '3'
               dgt = [dgt,0,0,1,1];
           case '4'
               dgt = [dgt,0,1,0,0];
           case '5'
               dgt = [dgt,0,1,0,1];
           case '6'
               dgt = [dgt,0,1,1,0];
           case '7'
               dgt = [dgt,0,1,1,1];
           case '8'
               dgt = [dgt,1,0,0,0];
           case '9'
               dgt = [dgt,1,0,0,1];
           case 'A'
               dgt = [dgt,1,0,1,0];
           case 'B'
               dgt = [dgt,1,0,1,1];
           case 'C'
               dgt = [dgt,1,1,0,0];               
           case 'D'
               dgt = [dgt,1,1,0,1];
           case 'E'
               dgt = [dgt,1,1,1,0];
           case 'F'
               dgt = [dgt,1,1,1,1];
       end
       
   end    

end