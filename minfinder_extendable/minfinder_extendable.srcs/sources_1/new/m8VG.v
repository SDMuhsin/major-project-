`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2020 21:28:20
// Design Name: 
// Module Name: m8VG_pipelined
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


module m8VG_pipelined(
        min1,
        min2,
        q2q1q0,
        
        x,
        clk,
        rst
    );
    
    parameter W=6;
    parameter Wc=8;
    
            output reg [W-2:0]min1;
            output reg [W-2:0]min2;
            output reg [2:0]q2q1q0;
            
            input [Wc*(W-1)-1:0]x;
            input clk;
            input rst;
    
    wire [1:0]m1_q1q0;
    wire [1:0]m2_q1q0;
    wire [W-2:0]m1A,m1B,m2A,m2B;

    
    wire [W-2:0]min1_wire;
    wire [W-2:0]min2_wire;
    wire [2:0]q2q1q0_wire;
    
    always@(posedge clk)begin
        if(rst)begin
            min1 <= 0;
            min2 <= 0;
            q2q1q0 <= 0;
        end
        else begin
            min1 <= min1_wire;
            min2 <= min2_wire;
            q2q1q0 <= q2q1q0_wire;          
        end
    end    
      
    m4VG_pipelined m1(m1A,m1B,m1_q1q0,x[4*(W-1)-1:0],clk,rst);
    m4VG_pipelined m2(m2A,m2B,m2_q1q0,x[8*(W-1)-1:4*(W-1)],clk,rst);
    
    assign min1_wire = m1A > m2A ?  m2A :m1A ;
    assign q2q1q0_wire[2] = m1A > m2A ? 1:0;
    //assign min2 = q2q1q0[2] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign min2_wire = m1A > m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
   // assign q2q1q0[1:0] = q2q1q0[2] ? m2_q1q0 : m1_q1q0;
    assign q2q1q0_wire[1:0] = m1A > m2A ? m2_q1q0 : m1_q1q0;
endmodule