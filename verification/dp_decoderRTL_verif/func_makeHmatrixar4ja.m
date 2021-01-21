%Main function for making AR4JA H matrix
%Uses subfunctions
% theta, phi : table functions
% pmatvec : expression to find nonzero col indices
% getpermsubmat: construction of submatrices composed of M/4 circulants.

function h = func_makeHmatrixar4ja(submatrixsize,coderate)
  %M values
  %k =  1024, 4096, 16384.
  %r=4/5: 128, 512, 2048.
  %r=2/3: 256,1024,4096
  %r=1/2: 512, 2048, 8192
  
  %circulant size is M/4
  
  M = submatrixsize;
  zeromat = zeros(M,M);
idmat = eye(M,M);

hmat1by2 = [zeromat, zeromat, idmat, zeromat, xor(idmat,getpermsubmat(1,M)); 
        idmat, idmat, zeromat, idmat, xor(getpermsubmat(2,M),getpermsubmat(3,M),getpermsubmat(4,M));
        idmat, xor(getpermsubmat(5,M),getpermsubmat(6,M)),zeromat, xor(getpermsubmat(7,M),getpermsubmat(8,M)), idmat];
  

hmat2by3sub = [zeromat, zeromat; xor(getpermsubmat(9,M),getpermsubmat(10,M),getpermsubmat(11,M)), idmat; idmat, xor(getpermsubmat(12,M),getpermsubmat(13,M),getpermsubmat(14,M))];
  
hmat2by3 = [hmat2by3sub , hmat1by2];

hmat3by4sub = [zeromat, zeromat; xor(getpermsubmat(15,M),getpermsubmat(16,M),getpermsubmat(17,M)), idmat; idmat, xor(getpermsubmat(18,M),getpermsubmat(19,M),getpermsubmat(20,M))];
hmat3by4 = [hmat3by4sub, hmat2by3];

hmat4by5sub = [zeromat, zeromat; xor(getpermsubmat(21,M),getpermsubmat(22,M),getpermsubmat(23,M)), idmat; idmat, xor(getpermsubmat(24,M),getpermsubmat(25,M),getpermsubmat(26,M))];
hmat4by5 = [hmat4by5sub, hmat3by4];

   if(coderate == "1by2")
      h = hmat1by2;
   elseif(coderate == "2by3")
      h = hmat2by3;
   elseif(coderate == "3by4")
      h = hmat3by4;
   elseif(coderate == "4by5")
      h = hmat4by5;      
  end
endfunction