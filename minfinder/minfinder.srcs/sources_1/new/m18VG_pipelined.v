`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2020 19:38:07
// Design Name: 
// Module Name: m18VG_pipelined
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


module m18VG_pipelined(
    output reg [4:0]min1,
    output reg [4:0]min2,
    output reg [4:0]q4q3q2q1q0,

    input [4:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,
    input clk,rst
    );
    
    wire [4:0]q4q3q2q1q0_wire;
    wire [4:0]min1_wire;
    wire [4:0]min2_wire;
    
    always@(posedge clk)begin
        if(rst)begin
            min1 <= 0;
            min2 <= 0;
            q4q3q2q1q0 <= 0;
        end
        else begin
            min1 <= min1_wire;
            min2 <= min2_wire;
            q4q3q2q1q0 <= q4q3q2q1q0_wire;
        end
    end
    wire [3:0]m1_q3q2q1q0;
    wire m2_q0;
    wire [4:0]m1A,m1B,m2A,m2B;
    
    m16VG_pipelined m1(m1A,m1B,m1_q3q2q1q0,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,clk,rst);
    m2VG_pipelined m2(m2A,m2B,m2_q0,x16,x17,clk,rst);
    
    
    assign min1_wire = m1A > m2A ?  m2A : m1A ;
    assign q4q3q2q1q0_wire[4] = m1A > m2A ?  1 : 0;
    assign min2_wire = m1A > m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
   // assign min2 = q4q3q2q1q0[4] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign q4q3q2q1q0_wire[3:0] = m1A > m2A ? {1'b0,1'b0,1'b0,m2_q0} : m1_q3q2q1q0;   
    //assign q4q3q2q1q0[3:0] = q4q3q2q1q0[4] ? {1'b0,1'b0,1'b0,m2_q0} : m1_q3q2q1q0;   
endmodule
