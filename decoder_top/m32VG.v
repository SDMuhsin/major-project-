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

module m32VG_pipelined(
    min1,
    min2,
    q4q3q2q1q0,
    x,
    clk,rst
    );
    parameter W=6;
    parameter Wc=32;
    
    output reg [W-2:0]min1;
    output reg [W-2:0]min2;
    output reg [4:0] q4q3q2q1q0;
    
     input [Wc*(W-1)-1:0]x;
     input clk,rst;
    
    wire [W-2:0]q4q3q2q1q0_wire;
    wire [W-2:0]min1_wire;
    wire [W-2:0]min2_wire;
    
    always@(posedge clk)begin
        if(!rst)begin
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
    wire [3:0]m2_q0;
    wire [4:0]m1A,m1B,m2A,m2B;
    //reg [4:0]min1_1,min2_1,cp_1,min1_2,min2_2,cp_2,min1_3,min2_3,cp_3,min1_4,min2_4,cp_4;
    
    m16VG_pipelined m1(m1A,m1B,m1_q3q2q1q0,x[16*(W-1)-1:0],clk,rst);
    m16VG_pipelined m2(m2A,m2B,m2_q0,x[32*(W-1)-1:16*(W-1)],clk,rst);
  
    //m2VG_pipelined_2 m2(m2A,m2B,m2_q0,x[18*(W-1)-1:16*(W-1)],clk,rst);
    
    /*always@(posedge clk) begin
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
                
                //min1_4 <= 0;
               // min2_4 <= 0;
                //cp_4 <= 0;
            end
            else begin
                min1_1 <= m2A;
                min2_1 <= m2B;
                cp_1 <= m2_q0;
                
                min1_2 <= min1_1;
                min2_2 <= min2_1;
                cp_2 <= cp_1;
                
                min1_3 <= min1_2;
                min2_3 <= min2_2;
                cp_3 <= cp_2;
                
                //min1_4 <= min1_3;
                //min2_4 <= min2_3;
                //cp_4 <= cp_3;
            end
        end
    */
    ////assign min1_wire = m1A > min1_4 ?  min1_4 : m1A ;
    ////assign q4q3q2q1q0_wire[4] = m1A > min1_4 ?  1 : 0;
    ////assign min2_wire = m1A > min1_4 ? m1A < min2_4 ? m1A : min2_4 : m1B < min1_4 ? m1B : min1_4;
   // assign min2 = q4q3q2q1q0[4] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    ////assign q4q3q2q1q0_wire[3:0] = m1A > min1_4 ? {1'b0,1'b0,1'b0,cp_4} : m1_q3q2q1q0;   
    //assign q4q3q2q1q0[3:0] = q4q3q2q1q0[4] ? {1'b0,1'b0,1'b0,m2_q0} : m1_q3q2q1q0;   
    assign min1_wire = m1A > m2A ?  m2A : m1A ;
    assign q4q3q2q1q0_wire[4] = m1A > m2A ? 1 : 0;
    assign min2_wire = m1A > m2A ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    //assign min2 = q3q2q1q0[3] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
    assign q4q3q2q1q0_wire[3:0] = m1A  > m2A ? m2_q0 : m1_q3q2q1q0;
        
   //assign min1_wire = m1A > min1_3 ?  min1_3 : m1A ;
   // assign q4q3q2q1q0_wire[4] = m1A > min1_3 ?  1 : 0;
   // assign min2_wire = m1A > min1_3 ? m1A < min2_3 ? m1A : min2_3 : m1B < min1_3 ? m1B : min1_3;
   // assign min2 = q4q3q2q1q0[4] ? m1A < m2B ? m1A : m2B : m1B < m2A ? m1B : m2A;
   // assign q4q3q2q1q0_wire[3:0] = m1A > min1_3 ? {1'b0,1'b0,1'b0,cp_3} : m1_q3q2q1q0;   
    //assign q4q3q2q1q0[3:0] = q4q3q2q1q0[4] ? {1'b0,1'b0,1'b0,m2_q0} : m1_q3q2q1q0;  
endmodule