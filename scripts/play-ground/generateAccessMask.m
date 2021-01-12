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
## @deftypefn {} {@var{retval} =} generateAccessMask (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function access_mask = generateAccessMask (address_table,circ_size)

access_mask = zeros(size(address_table));
symbols = zeros(1,circ_size);

for r = 1:1:size(address_table)(1)
  for c = 1:1:size(address_table)(2)
    # For address_table(:,:, 1 ) only
    if(address_table(r,c,1) > 0 &&symbols( address_table(r,c,1)) == 0)
      access_mask(r,c,1) = 1;
      symbols( address_table(r,c,1)) = 1;
    elseif(address_table(r,c,1) > 0 && symbols( address_table(r,c,1)) == 1)
      access_mask(r,c,1) = 2;
      symbols( address_table(r,c,1)) = 2;      
    endif
    # For address_table(:,:, 2 ) only
    if(address_table(r,c,2) > 0 && symbols( address_table(r,c,2)) == 0)
      access_mask(r,c,2) = 1;
      symbols( address_table(r,c,2)) = 1;
    elseif(address_table(r,c,2) > 0 && symbols( address_table(r,c,2)) == 1)
      access_mask(r,c,2) = 2;
      symbols( address_table(r,c,2)) = 2;      
    endif
    
    
  endfor
endfor

endfunction
