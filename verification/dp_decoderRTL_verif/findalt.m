%************** FInding ALT submatrices **********%
function [a b t c d e] = findalt(givhmat)
length(chkapproxtriangle(givhmat));
trow = length(chkapproxtriangle(givhmat));
t = givhmat(1:trow,end-trow+1:end);
gap = rows(givhmat) - trow;
e = givhmat(trow+1:end,end-trow+1:end);
d = givhmat(trow+1:end, end-trow-gap+1:end-trow);
b = givhmat(1:trow, end-trow-gap+1:end-trow);
a = givhmat(1:trow, 1:end-trow-gap);
c = givhmat(trow+1:end,1:end-trow-gap); 
end