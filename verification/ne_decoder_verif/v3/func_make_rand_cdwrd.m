
function [msgksys,code,codetx,cword,s] = func_make_rand_cdwrd (ksys=7136,Ggf)
     pkg load communications
     ksys=7136;
     msgksys = randi([0 1],1,ksys);
    %make k=7154-bit msg frm ksys=7136-bit msg;
     msg = [zeros(1,18),msgksys]; 
     msggf = gf([zeros(1,18),msgksys],1);
    %generating 8160 code frm 8176 code.
     code = msggf*Ggf;
     codetx = [code(19:end),gf(zeros(1,2),1)];
     cword = gf2toint(codetx);
    
    s = 1 - 2 * cword; %BPSK bit to symbol conversion 
    
  
endfunction
