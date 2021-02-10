`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.02.2021 07:19:01
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
parameter Wcbits = 5;//2**5 =32
parameter LAYERS=2;
parameter ADDRESSWIDTH = 5;//2^5 = 32 > 20
parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
parameter EMEMDEPTH=ADDRDEPTH*LAYERS; //for LUT RAM //512;//for BRAM ineffcient//
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
parameter RCU_PIPESTAGES=13;

//Agen controller
//configurable
parameter MAXITRS = 10;
parameter ITRWIDTH = 4;//2**4 = 16 > 9
//non-configurable
parameter Z=511;
parameter P=26;
parameter PIPESTAGES = RCU_PIPESTAGES+2;//memrd+RCU_PIPESTAGES+memwr
parameter PIPECOUNTWIDTH = 4;//2**4= 16 > 14
parameter ROWDEPTH=ADDRDEPTH;//20;//Z/P; //Z/P = 73
parameter ROWWIDTH = ADDRESSWIDTH;//5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17

//bitnodemem (Lmem)
//Configurable
//parameter W=6;//6;
parameter maxVal = 6'b011111;
//non-configurable parameters
//parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
//parameter Nb=16;//16;//circulant blocks per layer
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
//parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;

//Dmem
//parameter W=6;//6;//configurable by user
//non-configurable parameters
//parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
//parameter Nb=16;//16;//circulant blocks per layer
//parameter Wt=2; //circulant weight
//parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.
//parameter r=P*Wt;
//parameter w=W;

wire decoder_ready;
wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;//output
reg unload_en;
reg [ADDRESSWIDTH-1:0] unloadAddress;
reg [(32*Nb*W)-1:0] load_data;
reg loaden;
reg start;
reg clk,rst;

ne_rowcomputer_pipeV3_SRQ_p26 dut(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);

integer counter;
integer i;
initial begin
    unloadAddress = 0;
    load_data = 0;
    loaden = 0;
    start = 0;
    rst = 0; // Reset decoder at next posedge
    #0.01;
    clk = 1;
    #0.01;
    clk = 0;
    rst = 1;
    counter = 0;
    
    // START Decoder
    loaden = 1;
    load_data = 0;
    
    for(i=0;i<17;i=i+1)@(posedge clk); // wait for 17 clock cycles
    
    #0.01;
    start = 1;
    loaden = 0;
    @(posedge clk) #0.01 start = 0;
end
always #10 clk = ~clk;
always @(posedge clk) #0.01 counter = counter + 1;

always @(posedge clk)begin
    $display(" clk %d", counter);
    $display(" loaden = %b, start = %b ", loaden, start);
    $display(" rd_address = %d ", dut.rd_address);
    $display(" rd_data_regout = %d ", dut.rd_address);
end
endmodule
