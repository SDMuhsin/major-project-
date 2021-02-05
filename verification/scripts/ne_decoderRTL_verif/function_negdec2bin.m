function negbin = function_negdec2bin(negdec,bits)
  Qbin = dec2bin(abs(negdec),bits);
        binb=zeros(1,bits);
        binb(find(Qbin=='0'))=0;
        binb(find(Qbin=='1'))=1;

          binb= gf(binb,1);
          b1s=gf2toint(binb+1);      
          b1schar = function_numlist2strconv(b1s);
          Qchar = dec2bin(bin2dec(b1schar)+1,bits);
  negbin = Qchar;
end
