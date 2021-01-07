## Copyright (C) 2021 sayed
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
## @deftypefn {} {@var{retval} =} getReaccessIndices (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-04

function reaccessIndices = getReaccessIndices_mymod(layer0AddressMap)
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
endfunction
