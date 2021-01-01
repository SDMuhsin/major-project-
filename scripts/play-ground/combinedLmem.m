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
## @deftypefn {} {@var{retval} =} combinedLmem (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-12-30

clear all;
layer0AddressMap = layer0AddressMap(1);


#Where does the first reaccess begin
reaccessIndices = -1*ones(2,2);
for ly = 1:1:2
  accessed = zeros(1,511);
  flag = 0;
  for r = 1:1:size(layer0AddressMap(:,:,ly))(1)
    for c = 1:1:size(layer0AddressMap(:,:,ly))(2)
     
      if( ~flag && layer0AddressMap(r,c,ly)>0)
       
        if(  accessed(layer0AddressMap(r,c,ly)) )
          reaccessIndices(ly,1:end) = [r,c];
          flag = 1;
        else 
          accessed(layer0AddressMap(r,c,ly)) += 1;
        endif
        
      endif
    endfor
  endfor
endfor

#Where does the last first access end
lastFirstAccessIndices = zeros(2,2);
for ly = 1:1:2
  accessed = zeros(1,511);
  for r = 1:1:size(layer0AddressMap(:,:,ly))(1)
    for c = 1:1:size(layer0AddressMap(:,:,ly))(2)
     
      if(layer0AddressMap(r,c,ly)>0)
        if( ~accessed(layer0AddressMap(r,c,ly)) )
          lastFirstAccessIndices(ly,1:end) = [r,c];
          accessed(layer0AddressMap(r,c,ly)) += 1;
        endif        
      endif
      
    endfor
  endfor
endfor


#Post Reaccess symbols of ly0 and pre reaccess symbols of ly1

ly0PostRe = layer0AddressMap(reaccessIndices(1,1):end,1:end,1);
ly1PreRe = layer0AddressMap(1:lastFirstAccessIndices(2,1),1:end,2);

# ly0PostRe transposed, can be thought of as FIFO at cycle 0, just after ly0 is over
# Assuming ly1's first slice is processed in clock cycle 1,
# At what cycle are each of the symbols in ly0PostRe accessed -> reqCycles
# Subtract the number of fifo stages in front of each symbol from reqCycles to get number of buffer stages required
stagesRequired = zeros(size(ly0PostRe)); 

for i1 = 1:1:size(ly0PostRe)(1)
  for j1 = 1:1:size(ly0PostRe)(2)
        
    for i2 = 1:1:size(ly1PreRe)(1)
      for j2 = 1:1:size(ly1PreRe)(2)
        if(ly0PostRe(i1,j1) == ly1PreRe(i2,j2))
          stagesRequired(i1,j1) = i2 - (i1 - 1); 
        endif
      endfor
    endfor
      
  endfor
endfor
