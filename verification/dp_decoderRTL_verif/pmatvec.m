%%subfunction for making AR4JA H matrix
%Expression given in CCSDS to get pik variable
%specifying column indices of nonzero values.
%M2 is M, i2 is i, k1 is k
%ccsds eqn:
%pik(i) = ((M/4)*( (thetak+floor4ibyM)mod4 ) ) + ( (phik(floor4ibyM,M) + i)mod(Mby4) )
%%Nonzero Colm Eqn: gives 0 to M-1 values in a vector corresponding to a row.

function  pvec= pmatvec(k,M)  
pvec = zeros(1,M);
    for i2=1:M
        i=i2-1;
%        floorvalmod(i2) = mod(floor(4*i/M2),4);
%        temod(i2) = mod(phi(k1,floorvalmod(i2),M2),M2/4); %
%        pmatk1(i2) = (floorvalmod(i2)+theta(k1))*(M2/4) + temod(i2);
%        pvec(i2) = mod(pmatk1(i2),M2); %Additional step not in CCSDS.
         
        %ccsds eqn:
        floorval = floor(4*i/M);
        thetaksum = floorval+theta(k);
        thetaksummod4xMby4 = (mod(thetaksum,4))*(M/4);
        
        phikvalsum = phi(k,floorval,M) + i;
        phikvalsum_modMby4 = mod(phikvalsum,M/4);
        
        pmatk1 = ( thetaksummod4xMby4 ) + phikvalsum_modMby4;
        pvec(i2) = pmatk1;
        %pvec(i2) = mod(pmatk1(i2),M2); %Additional step not in CCSDS
        prte=0;
        prte=0;
    end%fori2
end%function