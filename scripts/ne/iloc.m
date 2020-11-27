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
## @deftypefn {} {@var{retval} =} iloc (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-11-27

function retval = iloc ( mat, p, blocks, i)
  s = size(mat);
  locs = [];
  
  for r = 1:1:s(1)
    for c= 1:1:s(2)
      if( mat(r,c) == i)
        locs = [locs, c];
      endif  
    endfor
  endfor
  remainder = 2 * p * blocks - length(locs);
  if(remainder ~= 0)
    %disp("Edge case");
    %disp(remainder);
  endif
  locs = [locs, zeros(1, remainder)];
  %disp("Size of locs");
  %disp(size(locs));
  retval = locs;
endfunction
