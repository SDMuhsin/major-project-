`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2020 21:16:02
// Design Name: 
// Module Name: m2VG_pipelined
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


module m2VG_pipelined(
     min1_4,
     min2_4,
     cp_4,
     x,
     clk,rst
    );
    
    parameter W=6;
    parameter Wc=2;
    
        output reg [W-2:0]min1_4;
        output reg [W-2:0]min2_4;
        output reg cp_4;
        input [(W-1)*Wc-1:0]x;
        input clk;
        input rst;
    wire [W-2:0]min1_wire;
    wire [W-2:0]min2_wire;
    wire cp_wire;
    
    reg [W-2:0]min1_1,min1_2,min1_3;
    reg [W-2:0]min2_1,min2_2,min2_3;
    reg cp_1,cp_2,cp_3;
    always@(posedge clk) begin
        if(rst)begin
            min1_1 <= 0;
            min2_1 <= 0;
            cp_1 <= 0;
            
            min1_2 <= 0;
            min2_2 <= 0;
            cp_2 <= 0;
            
            min1_3 <= 0;
            min2_3 <= 0;
            cp_3 <= 0;
            
            min1_4 <= 0;
            min2_4 <= 0;
            cp_4 <= 0;
        end
        else begin
            min1_1 <= min1_wire;
            min2_1 <= min2_wire;
            cp_1 <= cp_wire;
            
            min1_2 <= min1_1;
            min2_2 <= min2_1;
            cp_2 <= cp_1;
            
            min1_3 <= min1_2;
            min2_3 <= min2_2;
            cp_3 <= cp_2;
            
            min1_4 <= min1_3;
            min2_4 <= min2_3;
            cp_4 <= cp_3;
        end
    end
    
    assign min1_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?x[W-2:0]:x[Wc*(W-1)-1:W-1];
    assign min2_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?x[Wc*(W-1)-1:W-1]:x[W-2:0];
    assign cp_wire = x[W-2:0]<x[Wc*(W-1)-1:W-1]?0:1;
endmodule