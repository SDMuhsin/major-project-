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
## @deftypefn {} {@var{retval} =} unloadMuxPattern (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-01

function pattern = unloadMuxPattern (block)
retval = 0;
#block = 1;
[fifoRows,fifoColumns,fifoLoadInputFilled,fifoLy1Filled,iter0MuxPattern,higherIterMuxPattern] = combinedFifoAndMuxPatterns(block);
unloadRequestMap = unloadRequestMap(block);
#we take these values from 

pattern = -1 * ones( size(unloadRequestMap)(2), 2, size(unloadRequestMap)(1));
for cycle = 1:1:size(unloadRequestMap)(1)
  requests = unloadRequestMap(cycle,:);
  pattern(:,:,cycle) = findIndexesOfAInB(requests,fifoLy1Filled);
endfor
endfunction
