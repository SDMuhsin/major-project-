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
## @deftypefn {} {@var{retval} =} getReIndicesFromMask (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function ly_1_reaccess_starts = getReIndicesFromMask (access_mask_ly1)
ly_1_reaccess_starts = -1 * ones(2,2); # row1 for ly_1a, row2 for ly1b
f1 = 0;
f2 = 0;
for r = 1:1:size(access_mask_ly1)(1)
    for c = 1:1:size(access_mask_ly1)(2)
      if(~f1 && access_mask_ly1(r,c,1) == 2)
        ly_1_reaccess_starts(1,1:end) = [r,c];
        f1 = 1;
      endif
      if(~f2 && access_mask_ly1(r,c,2) == 2)
        ly_1_reaccess_starts(2,1:end) = [r,c];
        f2 = 1;
      endif
    endfor
endfor

endfunction
