len=8176;

c= randi(16,1,len-18)-9;
c1=[7.75*ones(1,18),c];
func_write_l10_input_32x16 (c1);
func_write_rcu_output_52xn (c1);


