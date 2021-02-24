Cuurent testbench for iteration 2 only.
Change the path (lines 110-118) and give itr==0 in all the if statements(currently, itr==1 (for iteration 2)) to modify for first iteration.
Uncomment lines 183-237 for displaying Ecomp read and write data.
Modification to be made in verilog files - change the depth of emem(in ne_rowcomputer_pipeV3_SRQ_p26.v and SISONorm_withD_pipeV3_ne.v) to 52( previously 40).
Note - print linit to text files may be reached halfway through the running of the script, leading to incomplete printing of expected values in lines 19-20( values expected at aslice address 19,20). fflush() command maybe added to avoid this. Alternative is to run the script in a sequential manner for each layer and each iteration instead of using for loop. Take random input for layer 1 iteration 1, use the updated LLR,E and D matrices from this processing as input for layer 2, iteration 1 and so on.
Random value generation can be done by running the file value_c1_save.m/ uncomment the lines corresponding to random value generation in rowcomputer_verif.m.
All the generated files are added in outputs folder; can be used directly qwithout running the script.
