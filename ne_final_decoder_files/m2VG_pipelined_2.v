`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2020 13:44:28
// Design Name: 
// Module Name: m2VG_pipelined_2
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


module m2VG_pipelined_2(
     min1_1,
     min2_1,
     cp_1,
     x,
     clk,rst
    );
    
    parameter W=6;
    parameter Wc=2;
        
    output reg [W-2:0]min1_1;
    output reg [W-2:0]min2_1;
    output reg cp_1;
    input [(W-1)*Wc-1:0]x;
    input clk;
    input rst;
    
    wire [W-2:0]min1_wire;
    wire [W-2:0]min2_wire;
    wire cp_wire;
    
    always@(posedge clk) begin
            if(rst)begin
                min1_1 <= 0;
                min2_1 <= 0;
                cp_1 <= 0;
            end
            else begin
                min1_1 <= min1_wire;
                min2_1 <= min2_wire;
                cp_1 <= cp_wire;
            end
        end
        
        assign min1_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?x[W-2:0]:x[Wc*(W-1)-1:W-1];
        assign min2_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?x[Wc*(W-1)-1:W-1]:x[W-2:0];
        assign cp_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?0:1;
        
endmodule