`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2021 16:27:48
// Design Name: 
// Module Name: tb_full_decoder
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


module tb_full_decoder(

    );
    
    parameter W=6;
    //non-configurable parameters
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;                           //2**5 =32
    parameter LAYERS=2;
    parameter ADDRESSWIDTH = 5;                     //2^5 = 32 > 20
    parameter ADDRDEPTH = 20;                       //ceil(Z/P) = ceil(511/26)
    parameter EMEMDEPTH=ADDRDEPTH*LAYERS;           //for LUT RAM //512;//for BRAM ineffcient//
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
    parameter RCU_PIPESTAGES=12;
    parameter MAXITRS = 10;
    parameter ITRWIDTH = 4;//2**4 = 16 > 9
    //non-configurable
    parameter Z=511;
    parameter P=26;
    parameter PIPESTAGES = RCU_PIPESTAGES+1;    //memrd+RCU_PIPESTAGES//+memwr
    parameter PIPECOUNTWIDTH = 4;               //2**4= 16 > 13
    parameter ROWDEPTH=ADDRDEPTH;               //20=Z/P; //Z/P = 73
    parameter ROWWIDTH = ADDRESSWIDTH;          // 2**5 = 32 > 20; //2**7 = 128 > 72
    //last_p rowdepth and pipestages.
    parameter P_LAST = Z-(P*(ROWDEPTH-1));       //511-(26*19)=511-494=17=valid lines in address 20
    
    //bitnodemem (Lmem)
    //Configurable
    parameter maxVal = 6'b011111;
    //non-configurable parameters
    parameter Kb=14;                            //first 14 circulant columns correspond to systematic part
    parameter HDWIDTH=32;                       //taking 32 hard decision bits at a time
    parameter Wt=2;                             //circulant weight
    parameter r=P*Wt;                           //r is predefined to be 52. non configurable.(26x2)
    parameter w=W;
    
    //inout declarations
    wire decoder_ready;                                       //from controller
    wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;          //output from lmem
    reg unload_en;                                            //from output if
    reg [ADDRESSWIDTH-1:0] unloadAddress;                     //from output if
    reg [(32*Nb*W)-1:0] load_data;                            //from input if
    reg loaden;                                               //from ip if
    reg start;                                                //from ip if
    reg clk,rst;
    
    ne_rowcomputer_SRQ_p26 dut(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
    
    always #10 clk = ~clk;
    integer counter = 0;
    always @(posedge clk) counter = counter + 1;
    
    initial begin
        #0.1;
        // Initialize and reset system
        clk = 0;
        rst = 0;
        start = 0;
        loaden = 0; 
        unloadAddress = 0;
        unload_en = 0;
        
        @(posedge clk) begin #0.2;  rst = 1; loaden = 1;end
        
        
        
        
        @(posedge clk) #0.2 start = 0;
    end
    
    // --- LOAD DATA --- //
    parameter input_lines = 17;
    parameter input_test_line = 5;
    parameter slices = 20;
    parameter q = 100;
    reg [(32*Nb*W)-1:0]L_in_32x16[input_lines-1:0];
    reg [P*Wc*W-1:0]L_in_26x32[slices-1:0];
    initial begin
       $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\v3\\outputs\\input_codeword_17x32x16.txt", L_in_32x16);
       $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\v3\\outputs\\input_codeword_26x2x16.txt", L_in_26x32);
       load_data = L_in_32x16[input_test_line];
    end
    
    // --- DISPLAY DATA --- //
    always@(posedge clk)begin
        $display(" -- clk = %d -- rst = %b -- start = %b -- ", counter, rst, start);
        
        $display("rd_data_regout %b",dut.bitnodemem.rd_data_regout[q:0]);
        $display("reference      %b",L_in_26x32[input_test_line][q:0]);
        $display("rd_en %b, loaden %b, wr_en %b, wr_layer %b, firstprocessing_indicate %b", dut.rd_en, dut.loaden,  dut.wr_en, dut.wr_layer, dut.firstprocessing_indicate);
        $display("rd_address     %b",dut.bitnodemem.rd_address);
        //$display("load_data           %b", load_data[10:0]);
        //$display("l10  rd_data_regout %b", dut.rd_data_regout[10:0]);
        //$display("l10  L_in_26x32[%d] %b",input_test_line, L_in_26x32[input_test_line][10:0]);
        
        if(counter == 17 + 3)begin
            loaden = 0;
            start = 1;
            
            @(posedge clk) #0.1 start = 0;
        end
    end
    
endmodule
