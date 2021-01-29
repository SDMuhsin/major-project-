`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2021 12:45:57
// Design Name: 
// Module Name: abt_minfinder_cover
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


module abt_minfinder_cover(
        min1_reg,
        min2_reg,
        index_reg,
        
        inp_wire,
        clk,
        rst
    );
    parameter w = 5;
    parameter Wc = 32;
    
    output reg [w-1:0]min1_reg;
    output reg [w-1:0]min2_reg;
    output reg[ $clog2(Wc) - 1 : 0]index_reg;
    wire [w-1:0]min1_wire;
    wire [w-1:0]min2_wire;
    wire [$clog2(Wc) - 1:0]index_wire;
    
    input wire [ Wc*w - 1: 0]inp_wire;
    reg [Wc*w - 1:0]inp_reg;
    
    input clk,rst;
    always@(posedge clk)begin
        if(rst)begin
            min1_reg <= 0;
            min2_reg <= 0;
            index_reg <= 0;
            
            inp_reg <= 0;
        end
        else begin
            min1_reg <= min1_wire;
            min2_reg <= min2_wire;
            index_reg <= index_wire;
            
            inp_reg <= inp_wire;
        end
    end
    
    defparam mf.w = w;
    defparam mf.Wc = Wc;
    abt_minfinder mf( min1_wire, min2_wire, index_wire, inp_reg);
endmodule
