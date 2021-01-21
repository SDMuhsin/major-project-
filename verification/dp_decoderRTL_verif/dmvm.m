function dmvmout = dmvm(mat2,vec2)
   %"Dense matrix vector multiplier"
   dmvmout = transpose(mat2*transpose(vec2));
end