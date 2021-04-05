`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2020 18:13:42
// Design Name: 
// Module Name: parity_load
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


module parity_load(p_en,en,rst,clk_in);
parameter s0=1'b0,s1=1'b1;
output reg p_en;
input en;
input rst,clk_in;
reg p_s,n_s;
reg [2:0]count,count_next;

always@(posedge clk_in)
if(rst)
begin
p_s<=s0;
count<=3'd0;
end
else
begin
p_s<=n_s;
count<=count_next;
end

always@(p_s,en,count)
case(p_s)
    1'b0: if(en==1'b0)
            begin
              n_s=s0;
              count_next=3'd0;
              p_en=1'b0;
              end
              else
              begin
                     n_s=s1;
                       count_next=3'd0;
                            p_en=1'b0;
                            end
  1'b1: if(count==3'd5)        //corr: was count_next
         begin
         n_s=s0;
         p_en=1'b0;
         count_next=3'd0; end
        else begin
         p_en=1'b1;
         n_s=s1;
         count_next=count+1'b1; //corr: was count_next+1
         end
   default: begin
           n_s=s0;
           count_next=3'd0;
           p_en=1'b0;
           end
     endcase      
endmodule
