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
## @deftypefn {} {@var{retval} =} getLastFirstIndicesFromMask (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function ly_first_access_ends = getLastFirstIndicesFromMask (access_mask)
ly_first_access_ends = -1 * ones(2,2); # row1 for ly_2a, row2 for ly_2b
for r = 1:1:size(access_mask)(1)
    for c = 1:1:size(access_mask)(2)
      if( access_mask(r,c,1) == 1)
        ly_first_access_ends(1,1:end) = [r,c];
      endif
      if( access_mask(r,c,2) == 1)
        ly_first_access_ends(2,1:end) = [r,c];
      endif
    endfor
endfor
endfunction
