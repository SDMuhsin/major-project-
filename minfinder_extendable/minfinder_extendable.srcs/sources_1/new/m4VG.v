`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2020 21:21:01
// Design Name: 
// Module Name: m4VG_pipelined
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


module m4VG_pipelined(
    min1,
    min2,
    q1q0,
    
    x,
    clk,
    rst
);

    parameter W=6;
    parameter Wc=4;
        output reg [W-2:0]min1;
        output reg [W-2:0]min2;
        output reg [1:0]q1q0;
        
        input [Wc*(W-1)-1:0]x;
        input clk;
        input rst;
    
    wire [W-2:0]m1A,m1B,m2A,m2B;
    wire cp1,cp2;
    
    wire [W-2:0]min1_wire;
    wire [W-2:0]min2_wire;
    wire [1:0]q1q0_wire;
    
    always@(posedge clk)begin
        if(rst)begin
            min1 <= 0;
            min2 <= 0;
            q1q0 <= 0;
        end
        else begin
            min1 <= min1_wire;
            min2 <= min2_wire;
            q1q0 <= q1q0_wire;          
        end
    end    
    m2VG_pipelined m1(m1A,m1B,cp1,x[2*(W-1)-1:0],clk,rst);
    m2VG_pipelined m2(m2A,m2B,cp2,x[4*(W-1)-1:2*(W-1)],clk,rst);
    
    
    assign min1_wire = m1A > m2A ?  m2A :m1A ;
    assign q1q0_wire[1] = m1A > m2A ?  1 : 0;
    //assign min2 = q1q0[1] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;   
    assign min2_wire = m1A > m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;   
    //assign q1q0[0] = q1q0[1] ? cp2 : cp1;
    assign q1q0_wire[0] = m1A > m2A ? cp2 : cp1;
endmodule