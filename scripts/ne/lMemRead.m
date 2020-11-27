## Copyright (C) 2020 sayed
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} lMemRead (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-11-27

circSize = 511;
filename = sprintf("DMem%dScripted.txt",circSize);
fid = fopen (filename, "w");
fprintf(fid,sprintf("module LMem%dScripted(\n\t\t muxOut,\n\t\t dMemIn,\n\t\t reaccessAddress,\n\t\t clk,rst \n );\n",circSize));


M= 511;
%h=zeros(2*M,16*M);
%table from ccsds for nearearthLDPC
circulantsLUT=[0, 176 0, 176;
12, 239 523, 750;
0, 352 1022, 1374;
24, 431 1557, 1964;
0, 392 2044, 2436;
151, 409 2706, 2964;
0, 351 3066, 3417;
9, 359 3586, 3936;
0, 307 4088, 4395;
53, 329 4652, 4928;
0, 207 5110, 5317;
18, 281 5639, 5902;
0, 399 6132, 6531;
202, 457 6845, 7100;
0, 247 7154, 7401;
36, 261 7701, 7926;
99, 471 99, 471;
130, 473 641, 984;
198, 435 1220, 1457;
260, 478 1793, 2011;
215, 420 2259, 2464;
282, 481 2837, 3036;
48, 396 3114, 3462;
193, 445 3770, 4022;
273, 430 4361, 4518;
302, 451 4901, 5050;
96, 379 5206, 5489;
191, 386 5812, 6007;
244, 467 6376, 6599;
364, 470 7007, 7113;
51, 382 7205, 7536;
192, 414 7857, 8079];
%H matrix construction
ro=0;
h=[];
hloc=[];
for h_row=1:2
  hlyr = [];
  hlyrloc=[];
  for h_col=1:16
    ro = ro+1;
    firstrow = zeros(1,M);
    firstrow(1,circulantsLUT(ro,1)+1) = 1;
    firstrow(1,circulantsLUT(ro,2)+1) = 1;
    A = makecirculant(firstrow,M);
    hlyr = [hlyr,A];
    %Location finding
    Aloc = func_makecirculantlocations((circulantsLUT(ro,1:2)+1),M,M);
    hlyrloc=[hlyrloc,Aloc];      
  end
  h = [h;hlyr];
  %Locations
  hloc = [hloc;hlyrloc];
end

%exact loc adding 511 offsets
h_exactloc = zeros(size(hloc));
for lyr=1:2
  for irow=1+(lyr-1)*511:511+(lyr-1)*511
    for circ=1:16
      wtc1 = 2*circ - 1;
      wtc2 = 2*circ;
      offset=511*(circ-1);
      h_exactloc(irow,wtc1)=hloc(irow,wtc1)+offset;
      h_exactloc(irow,wtc2)=hloc(irow,wtc2)+offset;
    end
  end
end

p = 26;
rowsPerLayer = 511;
layersCount = 2;
blocksCount = 16;
offsetsPerCircCount = 2;

% -- GENERATE ADDRESS TABLE -- %
addressTableRows = layersCount * ceil( M / p);
addressTableColumns = blocksCount * offsetsPerCircCount * p;

addressTable = zeros(addressTableRows,addressTableColumns);
for ly = 1:layersCount
  hl = h( (ly-1) * M  + 1: ly*M , :);
  for slice = 1:1:addressTableRows/2
    
    sliceStart = 1 + p*(slice -1);
    sliceEnd = slice * p;
    
    if sliceEnd > 511
      sliceEnd = 511;  
    endif
    disp("slice");
    disp(slice);
    % - Get addresses of 1's in a slice -- %
    addressTable( (ly-1)*addressTableRows/2 + slice, :) = iloc(hl(sliceStart:sliceEnd,:),p,blocksCount,1);
    
  endfor
endfor

symbolAccessCounts = ones(1,M*blocksCount);
for i = 1:1:addressTableRows
  
  toAccess = [];
  for j = 1:1:addressTableColumns
    if( addressTable(i,j) ~= 0 && symbolAccessCounts(1,addressTable(i,j)) == 1)
      symbolAccessCounts(1,addressTable(i,j)) = 0;
    
    elseif(addressTable(i,j) ~= 0 &&  symbolAccessCounts(1,addressTable(i,j)) == 0)
      toAccess = [toAccess, addressTable(i,j)];
    end
  endfor
  
  %-- PRINT --%
  fprintf(fid,sprintf("\n\t\t\t case %d :\n \t\t\t\t muxOut = {", i -1 ));
  for k = 1:1:length(toAccess)
    fprintf(fid,sprintf(" %d,", toAccess(k)-1));
  endfor
  fprintf(fid,sprintf("};"));
endfor

fprintf(fid,sprintf("    endcase\n"));
fprintf(fid,sprintf("end\nendmodule\n"));
fclose(fid);
