function dgt = hex2binstr(wrd)
%%matrix indeices 1, 2, 3, ... n
%%powers: MSBfirst 31, 29, 28, ... 0 LSBlast
   n=length(wrd)*4;
   dgt=char([]);
   for i=1:length(wrd)
       switch wrd(i)
           case '0'
               dgt = [dgt,'0000'];
           case '1'
               dgt = [dgt,'0001'];
           case '2'
               dgt = [dgt,'0010'];               
           case '3'
               dgt = [dgt,'0011'];
           case '4'
               dgt = [dgt,'0100'];
           case '5'
               dgt = [dgt,'0101'];
           case '6'
               dgt = [dgt,'0110'];
           case '7'
               dgt = [dgt,'0111'];
           case '8'
               dgt = [dgt,'1000'];
           case '9'
               dgt = [dgt,'1001'];
           case 'A'
               dgt = [dgt,'1010'];
           case 'B'
               dgt = [dgt,'1011'];
           case 'C'
               dgt = [dgt,'1100'];               
           case 'D'
               dgt = [dgt,'1101'];
           case 'E'
               dgt = [dgt,'1110'];
           case 'F'
               dgt = [dgt,'1111'];
       end
       
   end    

end