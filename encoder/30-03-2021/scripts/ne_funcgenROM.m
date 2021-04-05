%ne func generator ROM
%Near earth Para RCE Encoder Validation
% Validation Successful for 18 zero prepended case.
clc
clear all
close all
pkg load communications
%
Z=511
KB=14
Lm=16
k=7136

%generate G matrix parity part for Near earth:
Gne= func_NE_makeG();
Gne_p= Gne(:,KB*Z + 1:end); 

MB = size(Gne_p)(2)/Z
DATAWIDTH = MB*Z;

file2open = sprintf("./outputs/ne_funcgenROM.v");
fid = fopen(file2open,'wt'); 
  fprintf(fid,'%c',transpose(sprintf("`timescale 1ns / 1ps\n\n"))); 
  fprintf(fid,'%c',transpose(sprintf("module ne_funcgenROM(f, romaddress, rden);\n"))); 
  fprintf(fid,'%c',transpose(sprintf("parameter Z=511;//circulant size\n"))); 
  fprintf(fid,'%c',transpose(sprintf("parameter MB=2;//num of blk columns of G parity part\n"))); 
  fprintf(fid,'%c',transpose(sprintf("parameter ADDRESSWIDTH=4;\n"))); 
  fprintf(fid,'%c',transpose(sprintf("parameter READDEFAULTCASE = (2**ADDRESSWIDTH)-1;\n\n"))); 
  fprintf(fid,'%c',transpose(sprintf("output reg[(MB*Z)-1:0] f;\n"))); 
  fprintf(fid,'%c',transpose(sprintf("input[(ADDRESSWIDTH)-1:0] romaddress;\n"))); 
  fprintf(fid,'%c',transpose(sprintf("input rden;\n\n"))); 
  fprintf(fid,'%c',transpose(sprintf("wire[(ADDRESSWIDTH)-1:0] romaddress_case = rden ? romaddress : READDEFAULTCASE;\n\n"))); 
  fprintf(fid,'%c',transpose(sprintf("always@(*)\n"))); 
  fprintf(fid,'%c',transpose(sprintf("begin\n"))); 
  fprintf(fid,'%c',transpose(sprintf("  case(romaddress_case)\n"))); 

%Do parallel RCE mul for each circulant:

for circ=1:KB
  fprintf(fid,'%c',transpose(sprintf("    %2d: begin\n",circ-1)));   
  %I> Fetch the circ row of G parity part :
  blkcol=1;
  circrow1 = Gne_p((1+(circ-1)*Z),(1+(blkcol-1)*Z):(blkcol*Z)); 
  %shift right by 2 for compensating parity register shift:
  circrow1 = func_rotator(circrow1,2,'R');  
  %and shift it by 'circ-1' right due to zero insertions:
  circrow1 = func_rotator(circrow1,circ-1,'R');
  
  blkcol=2;
  circrow2 = Gne_p((1+(circ-1)*Z),(1+(blkcol-1)*Z):(blkcol*Z)); 
  %shift right by 2 for compensating parity register shift:
  circrow2 = func_rotator(circrow2,2,'R');  
  %and shift it by 'circ-1' right due to zero insertions:
  circrow2 = func_rotator(circrow2,circ-1,'R');
  
  circrow = [circrow1,circrow2];
  circrowhex = bin2hex(circrow);
  fprintf(fid,'%c',transpose(sprintf("         f=%d'h%s;\n",DATAWIDTH,circrowhex)));  
  fprintf(fid,'%c',transpose(sprintf("       end\n")));
end
fprintf(fid,'%c',transpose(sprintf("    default: begin\n",circ-1)));
fprintf(fid,'%c',transpose(sprintf("               f=0;\n")));  
fprintf(fid,'%c',transpose(sprintf("             end\n")));

fprintf(fid,'%c',transpose(sprintf("  endcase\n"))); 
fprintf(fid,'%c',transpose(sprintf("end\n"))); 
fprintf(fid,'%c',transpose(sprintf("endmodule\n"))); 
fclose(fid);