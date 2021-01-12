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
## @deftypefn {} {@var{retval} =} checkIfElementInMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function retval = checkIfElementInMatrix (input1, input2)
  retval = 0;
  for i = 1:1:size(input2)(1)
    for j = 1:1:size(input2)(2)
      if( input1 == input2(i,j))
        retval = 1;
        break;
      endif
    endfor
  endfor
endfunction
