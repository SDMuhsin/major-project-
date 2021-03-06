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

function pattern = unloadMuxPattern (fifo,unloadRequests,shiftEn)
  pattern = -1 * ones( size(unloadRequests)(2), 2, size(unloadRequests)(1));
  for i = 1:1:size(unloadRequests)(1)
      pattern(:,:,i) = findIndexesOfAInB(unloadRequests(i,:),fifo);
      if (shiftEn)
        fprintf("UNLOAD SHIFTING \n");
        fifo = shiftFifo(fifo);
      endif
      fifo(1:10);
  endfor
endfunction
8