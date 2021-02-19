ly = 2;
p = layerAddressMap_mymod(1)(:,:,ly);
size(p)
offset_indices=func_makeaddtable();

#layerAddressMap_mymod(layerAddressMap_mymod<0)=-8176;
for i = 2:1:blocks
  f=layerAddressMap_mymod(i)(:,:,ly);
  
  f(f<=0)=-8176;
  p = [p, f+(i-1)*511];
endfor

pattern = [];
  for i=1:1:26
  for j=0:1:31
    pattern=[pattern p(:,i+j*26)];
  endfor
endfor





