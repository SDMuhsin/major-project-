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
## @deftypefn {} {@var{retval} =} covertRowsToFifo (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: sayed <sayed@SDMUHSIN>
## Created: 2021-01-10

function fifo = covertRowsToFifo (table, start_row, fifo_row_dim)
  #The name fifo_row_dim is confusing, its address_table_rows, which will be fifo COLUMNS
  #start_row + fifo_row_dim - 1
  if( start_row + fifo_row_dim - 1 <= size(table)(1))
    fifo = table(start_row:start_row + fifo_row_dim -1 , :);
    fifo = transpose(fifo);
    t = zeros(size(fifo));
    for i = 1:1:size(fifo)(2)
      t(:,i) = fifo(:,  size(fifo)(2) - i + 1);
    endfor
    fifo = t;
  else
    start_row
    fprintf("FIFO start_row + row_dim out of table bounds,");
    fifo = zeros(  fifo_row_dim, size(table)(2));
    
    fifo( 1:end - ( size(table)(1) - start_row + 1)  , :) = table( start_row:end, :)
    fifo = transpose(fifo);
    t = zeros(size(fifo));
    for i = 1:1:size(fifo)(2)
      t(:,i) = fifo(:,  size(fifo)(2) - i + 1);
    endfor
    fifo = t;
  end  
  fifo(fifo == -1) = 0; # Address table invalid = -1, fifo invalid = 0
endfunction
