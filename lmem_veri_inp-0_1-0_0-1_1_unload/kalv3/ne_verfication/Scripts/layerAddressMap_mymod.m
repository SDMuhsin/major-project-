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
## @deftypefn {} {@var{retval} =} layer0AddressMap (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-29

function addressTable = layerAddressMap_mymod(block)

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

circulantsLUTClipped = circulantsLUT(1:end,1:2);
topHalf = circulantsLUTClipped(1:16,1:end);
bottomHalf = circulantsLUTClipped(17:end,1:end);

stackedLUT = zeros(2,32);
j = 1;
for i = 1:2:size(stackedLUT)(2)
  stackedLUT(1,i:i+1) = topHalf(j,1:end);
  stackedLUT(2,i:i+1) = bottomHalf(j,1:end);
  j=j+1;
endfor

offsets = stackedLUT(1:end, 2*block - 1:2*block)
circSize = 511;
offsets = stackedLUT(1:2,2*block-1:2*block)
%offsets = [0 4; 5 7];
p = 26; %Rows per slice
lys = size(offsets);
lys = lys(1);
offsets=offsets.+1;
onesTable = zeros(2*circSize,length(offsets));
% ADDRESS OF 1s
for ly = 1:1:lys
  for i=1:1:circSize
      
      %I called this variable slice but its actually row
      slice = (ly-1)*circSize + i;
      onesTable(slice,1:end) = mod(offsets(ly,1:end),circSize);
      
      % Replace 0 with circSize
      if(onesTable(slice,1) == 0)
        onesTable(slice,1) = circSize;
      endif
      if(onesTable(slice,2) == 0)
        onesTable(slice,2) = circSize;
      endif
      offsets(ly,1:end) = offsets(ly,1:end).+1;
  endfor
endfor
% ADDRESS TABLE
addressTable = zeros( ceil(circSize/p), p*length(offsets), lys);
for ly = 1:1:lys
  normIndex = 1;
  for i = 1:p:circSize
    %printf(" %d to %d",i,i+p-1)
    startIndex = (ly-1)*circSize + i;
    endIndex = (ly-1)*circSize + i+p-1;
    
    rowLimit = (ly-1)*circSize + circSize;
    if(endIndex  > rowLimit)
      addressTable( normIndex, 1:end, ly) = [ [transpose(onesTable(startIndex:rowLimit,1)), zeros(1, endIndex - rowLimit) ], [transpose(onesTable(startIndex:rowLimit,2)), zeros(1, endIndex - rowLimit) ] ] ;
    else
      addressTable( normIndex, 1:end,ly) = [ transpose(onesTable(startIndex:endIndex,1)), transpose(onesTable(startIndex:endIndex,2)) ] ;
    endif
    
    normIndex+=1;
  endfor
endfor


endfunction
