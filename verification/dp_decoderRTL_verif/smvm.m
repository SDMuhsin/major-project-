function smvmout = smvm(mat1, vec1)
    %"sparse matrix vector multiplier"
    smvmout = transpose(mat1*transpose(vec1));
end