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
## @deftypefn {} {@var{retval} =} generateIsolatedAddressTables (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function [address_table] = generateIsolatedAddressTables (offsets,circ_size,p)
  address_table = zeros(ceil(circ_size/p),p,size(offsets)(2)); #20 x 26 x 2
  offsets = offsets.+1;
  
  for o = 1:1:size(offsets)(2)
    for i = 1:1:size(address_table)(1)
      for j = 1:1:size(address_table)(2)
        address_table(i,j,o) = mod( offsets(o), circ_size);
        offsets(o) += 1;
      endfor
    endfor
  endfor
  address_table(address_table == 0) = 511;
  
  #The last few values will be repetition, the last 17
  last_row = ceil(circ_size/p);
  address_table( last_row, (end - (last_row*p - 511) + 1):end, 1:2) = -1;
  
endfunction
