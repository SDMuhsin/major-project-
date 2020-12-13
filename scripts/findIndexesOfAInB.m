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
## @deftypefn {} {@var{retval} =} findIndexesOfAInB (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2020-11-14

function indexes = findIndexesOfAInB (A, B)
  %A is 1xd
  %B is dxk
  %indexes should be dx2
  
  indexes = zeros(length(A),2);
  indexes(indexes==0) = -1;
  for i = 1:1:length(A)
    for column = 1:1:size(B)(2)
      for row = 1:1:size(B)(1)
        row;
        column;
        if(A(i) == B(row,column))
          %row
          %column
          %A(i)
          indexes(i,1:end) = [row,column] ;
        endif
      endfor
    endfor
  endfor
endfunction