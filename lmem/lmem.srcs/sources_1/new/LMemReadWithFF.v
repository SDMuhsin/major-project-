`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.11.2020 19:12:50
// Design Name: 
// Module Name: LMemReadWithFF
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


module LMemReadWithFF(
    muxOut,
    memBlockInput,
    sel,
    clk,
    rst
    );
    
    input clk, rst;
parameter W = 6;
parameter p = 26;
parameter circSize = 511;
parameter blocksPerLayer = 16;
parameter symbolsPerAccessBits = 2 * W * p * blocksPerLayer; // Actually bits per access
parameter sliceAddressSize = 5;
parameter totalSlices = 20;

output wire [ symbolsPerAccessBits - 1: 0]muxOut; // 26 * 2 symbols per access 
input [ 1 + sliceAddressSize - 1 : 0 ]sel;
input wire [ circSize * blocksPerLayer * W - 1 : 0 ]memBlockInput;

// -- Instantiate FF Memory -- 
reg [ W*circSize * blocksPerLayer -1 :0]memBlock;
wire [ W*circSize * blocksPerLayer -1 :0]memBlockWire;

assign memBlockWire = memBlock;
LMemReadFF align(muxOut, memBlock, sel);

always@(posedge clk)begin
    
    if(rst)begin
        memBlock <= 0;        
    end
    else begin
        memBlock <= memBlockInput;
    end

end

endmodule
