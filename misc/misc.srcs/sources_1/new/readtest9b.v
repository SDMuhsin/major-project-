`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2021 12:00:12
// Design Name: 
// Module Name: readtest9b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module readtest9b( );

parameter nofb=192;
parameter nofb_ecomp = 47;
parameter lines=511;

reg [nofb-1:0]L_in[lines-1:0];
reg [nofb-1:0]D_in[lines-1:0];
reg [nofb_ecomp-1:0]E_in[lines-1:0];

reg [nofb-1:0]L_out[lines-1:0];
reg [nofb-1:0]D_out[lines-1:0];
reg [nofb_ecomp-1:0]E_out[lines-1:0];

integer i;


initial 
begin
   
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\L_in_iter1_ly1.txt",L_in);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\D_in_iter1_ly1.txt",D_in);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\E_in_iter1_ly1.txt",E_in);//if less no of bits are specified it will pad 0 at begining
    
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\L_out_iter1_ly1.txt",L_out);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\D_out_iter1_ly1.txt",D_out);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\E_out_iter1_ly1.txt",E_out);//if less no of bits are specified it will pad 0 at begining
    
end

// Instantiate module
    
parameter Nb=16;
parameter Wc=32;
parameter Wcbits = 5;//2**5 =32
parameter W=6;
parameter LAYERS=2;
parameter ADDRWIDTH = 5;//2^5 = 32 > 20
parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
parameter PIPESTAGES=11;
    
wire [(Wc*(W))-1:0] updLLR_regout;
wire [(Wc*(W))-1:0] Dout_regout;
wire [(ADDRWIDTH+1+1)-1:0] Dmem_rden_layer_address;
wire wrlayer;
wire [ADDRWIDTH-1:0]wraddress;
wire wren;

reg rdlayer_regin;
reg [ADDRWIDTH-1:0]rdaddress_regin;
reg rden_LLR_regin;
reg rden_E_regin;
reg [(Wc*(W))-1:0] Lmemout_regin;
reg [(Wc*(W))-1:0] D_reaccess_in_regin;
reg clk,rst;

task display_integers;
    input [Wc*W-1:0]inp;
    begin:stuff
    
    
    integer i;
    integer j;
    real t;
    reg [W-1:0]one;
    
    
    $write("LIST : ");
    for(i=0;i<Wc;i=i+1)begin:display_loop
       one = inp[ (i+1)*W - 1 -: W];
       
       t = 0;
       $write(" | ");//, one);
       for(j = 0; j < W; j = j + 1)begin
        if(j == W - 1)begin
            t = t - (2 ** (j-2) ) * one[j];
        end
        else if(j == 0)begin
            t = t + 0.25 * one[j];
        end
        else if(j == 1)begin
            t = t + 0.5 * one[j];
        end
        else begin
            t = t + (2 ** (j-2) ) * one[j];
        end
       end 
       $write("  %2.2f| ",t);
        
    end
    $write("\n");
    end
endtask

SISO_rowunit_pipe rcu(updLLR_regout,Dout_regout,wrlayer,wraddress,wren,Dmem_rden_layer_address, 
rdlayer_regin,rdaddress_regin,rden_LLR_regin,rden_E_regin, 
Lmemout_regin,
D_reaccess_in_regin,
clk,rst);     

integer cnt;
initial begin
    cnt = 0;
    
    rst = 0;
    clk = 0;
    #1;
    clk = 1;
    #1;
    clk = 0;
    rst = 1;
    
    rdlayer_regin = 0;
    rdaddress_regin = 0;
    rden_LLR_regin = 1;
    rden_E_regin = 1;
    Lmemout_regin = 0;
    D_reaccess_in_regin = 0;
    
    #10;
    // First inputs
    D_reaccess_in_regin = D_in[0];
    Lmemout_regin = L_in[0];

end

always #10 clk = ~clk;
always @(posedge clk) cnt = cnt + 1'b1;
always @(posedge clk)begin
    if( updLLR_regout == L_out[0] )begin
        
        $display("clk %d DING \n",cnt);
        
    end
    else begin
        $display(" clk %d \n",cnt );
        
        //$display(" Into RCU L_in %b", Lmemout_regin);
        //$display(" RCU L_in after one FF %b", rcu.Lmemout);
        //$display(" RCU SUB_OUT %b", rcu.SUB_OUT);
        //$display(" RCU SUB_OUT_REG[6] %b", rcu.SUB_OUT_REG[6]);
        //$display(" updLLROut %b", rcu.updLLR_out);
        //$display(" from RCU %b", updLLR_regout);
        //$display(" from txt %b", L_out[0]);
        $write("L_in from txt, into RCU :");
        display_integers(L_in[0]);
        //$display("%b",L_in[0]);
        $write("L_in taken from     RCU :");
        display_integers(rcu.Lmemout);
        $write("ECOMP taken from    RCU : %b \n", rcu.E_COMP);
        
        $write("REC_1_out from      RCU :");
        display_integers(rcu.REC_1_OUT);  
        $write("Q            , from RCU :");
        display_integers(rcu.SUB_OUT); 
        $write("REC_2_out from      RCU :");
        display_integers(rcu.REC_2_OUT); 
        
        $write(" L_out from txt : ");
        display_integers(L_out[0]);
        $write(" L_out from RCU : "); 
        display_integers(updLLR_regout);
    end
end

// Test subtractor
reg [Wc*W - 1:0]s_a,s_b;
wire [Wc*W - 1:0]s_out;
subtractor_32 s(s_out,s_a,s_b,clk,rst);

reg [W-1:0]s_a_w,s_b_w;
wire [W-1:0]s_out_w;
subtract_2 s1(s_out_w,s_a_w,s_b_w);

initial begin
    s_a = 0;
    s_b = 0;
    s_a_w = 0;
    s_b_w = 6'b111111;
end
always@(posedge clk)begin
    /*$display("SUBTRACTOR START");
    $display("%b \n %b \n %b",s_a,s_b,s_out);
    $write("Input to subtractor a :");
    display_integers(s_a);
    
    $write("Input to subtractor b :");
    display_integers(s_b);
    
    $write("Output from subtractor:");
    display_integers(s_out);
    
    //$display(" a = %b",s_a_w);
    //$display(" b = %b",s_b_w);
    //$display(" o = %b",s_out_w);
    
    $display("SUBTRACTOR END");
    
    s_a = s_a + $random;
    s_b = s_b + $random;
    
    s_a_w = s_a_w + $random;
    s_b_w = s_b_w + $random;*/
end
endmodule

