`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2021 09:50:14
// Design Name: 
// Module Name: tb_rcu_1
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


module tb_rcu_1(

    );

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
   
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\L_in_iter2_ly1.txt",L_in);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\D_in_iter2_ly1.txt",D_in);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\E_in_iter2_ly1.txt",E_in);//if less no of bits are specified it will pad 0 at begining
    
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\L_out_iter2_ly1.txt",L_out);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\D_out_iter2_ly1.txt",D_out);//if less no of bits are specified it will pad 0 at begining
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\outputs\\E_out_iter2_ly1.txt",E_out);//if less no of bits are specified it will pad 0 at begining
    
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
    
    parameter W = 6;
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

integer cnt = 0;
parameter test_row = 0; // which line of txt files to test
initial begin
    cnt = 0;
    
    rst = 0;
    clk = 0;


    
    rdlayer_regin = 0;
    rdaddress_regin = 0;
    rden_LLR_regin = 1;
    rden_E_regin = 1;
    Lmemout_regin = 0;
    D_reaccess_in_regin = 0;

    // First inputs


end

always #10 clk = ~clk;
always @(posedge clk) cnt = cnt + 1'b1;
always @(posedge clk)begin
    #0.1;
    if( cnt == 1)begin
        rst = 1;
        $display("Reset lifted");
    end 
    else if(cnt == 4)begin 
        // Decoder has been reset
        // Some input is to be fed
        // Put all inputs to zero
        
        $display("clk %d : Feeding input #0", cnt);
        D_reaccess_in_regin = D_in[test_row];
        Lmemout_regin = L_in[test_row];        
            
    end
    else if (cnt == 5)begin
        $display("clk %d : Closing inputs", cnt);
        rdlayer_regin = 0;
        rdaddress_regin = 0;
        rden_LLR_regin = 0;
        rden_E_regin = 0;
        Lmemout_regin = 0;
        D_reaccess_in_regin = 0;    
    end
    if(cnt == 12)begin
        D_reaccess_in_regin = D_in[test_row];
        
        // E_COMP comparison with referece
        if(rcu.E_COMP != E_out[test_row] )begin
            $display("[ASSERTION ERROR] E_COMP Not as expected");
            $display("%b \n%b \n%b",rcu.E_COMP, E_out[test_row],rcu.E_COMP != E_out[test_row]);
        end
        else begin
            $display("[ASSERTION SUCCESS] E_COMP as expected");
        end
        
        // Check whether wr_E for emem has been set
        if(rcu.wr_E != 1'b1)begin
            $display("[ASSERTION ERROR] wr_E = %b, should be 1",rcu.wr_E);
        end
    end
    else if (cnt == 10) begin
        D_reaccess_in_regin = 0;
        

    end
    else if( cnt == 14) begin
        #1;
        // ASSERT L_out and D_out
        if(rcu.updLLR_out != L_out[test_row] )begin
            $display("[ASSERTION ERROR] L_out Not as expected");
            $display("%b\n%b\n%b", rcu.updLLR_out, L_out[test_row], rcu.updLLR_out != L_out[test_row]);
        end
        else begin $display("[ASSERTION SUCCESS] L_out as expected"); end
        if(rcu.D_out != D_out[test_row] )begin
            $display("[ASSERTION ERROR] D_out Not as expected");
            $display("%b\n%b\n%b", rcu.D_out, D_out[test_row], rcu.D_out != D_out[test_row]);
        end
        else begin $display("[ASSERTION SUCCESS] D_out as expected"); end
    end
    if( cnt < 20)begin
        // Display all relevant signals
        $display("-------------------------------------------------------");
        $display("clk %d \n",cnt);
        $display("[Enable signals] wr_E = %b, rd_E = %b  rden_E_regin = %b", rcu.wr_E, rcu.rd_E, rden_E_regin);
        
        //0
        $display("Emem_rd_dataout       0 %b",rcu.Emem_rd_dataout);

        
        // 1
        $write("Lmemout                 1 ");
        display_integers(rcu.Lmemout);
        $write("REC_1_OUT_REG[0]        1 ");
        display_integers(rcu.REC_1_OUT_REG[0]);
        
        //2
        $write("SUB_OUT                 2 ");
        display_integers(rcu.SUB_OUT);
        
        
        $display("SUB_OUT->absSign      2 %b",rcu.absmin.signbit);
        $display("SUB_OUT->abs          2 %b",rcu.absmin.abs);
        
        //3
        $write("SUB_OUT_REG[0]          3 ");
        display_integers(rcu.SUB_OUT_REG[0]);
        
        $display("SUB_OUT->absNorm      3 %b",rcu.absmin.absnormL);
        $display("minfinder_stage_1     3 %b",rcu.absmin.signbit);
        
        //8
        $display("ECOMP                 8 %b", rcu.E_COMP); 
        $display("ECOMP  reference      8 %b", E_out[test_row]);
        
        $write("REC_2_OUT               8 ");
        display_integers(rcu.REC_2_OUT);
        
        
        //9
        $write("updLLROUT               9 ");
        display_integers(rcu.updLLR_out);
        $write("updLLROUT reference     9 ");
        display_integers(L_out[test_row]);
        
        $write("Dout                   9 ");
        display_integers(rcu.D_out);
        $write("Dout reference         9 ");
        display_integers(D_out[test_row]);
        
        
        $display("-------------------------------------------------------"); 
        
    end
    

end


endmodule
