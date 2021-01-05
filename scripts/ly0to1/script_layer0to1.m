
block = 1;
shiftEn = 0;
addressTable = layerAddressMap(block);

# Define FIFO dimensions r x c
# r = 52, c = 20 - first re-access row

reIndices = getReaccessIndices(addressTable);
fifoRows = size(addressTable)(2);
fifoColumns = size(addressTable)(1) - reIndices(1,1) + 1; 

#Initialise FIFO : FIFO will be filled with rows of addressTable(:,:,1) starting from reaccess
fifo = zeros(fifoRows,fifoColumns);
fifo = transpose(addressTable(reIndices(1,1):end,:,1));
fifoTemp = zeros(size(fifo));
for i = 1:1:size(fifo)(2)
  fifoTemp(:,i) = fifo(:,size(fifo)(2) - i + 1);
endfor
fifo = fifoTemp;

#Generate Mux Pattern

#Shift ON
if(shiftEn)

else
  muxPattern = -1 * ones( fifoRows, 2, size(addressTable)(1));
  for slice = 1:1:size(muxPattern)(3)
    muxPattern(:,:,slice) = findIndexesOfAInB( addressTable(slice,:,2), fifo);
  end  
endif