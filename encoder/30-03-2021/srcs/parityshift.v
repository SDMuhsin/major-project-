`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2021 12:00:09
// Design Name: 
// Module Name: parityshift
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


module parityshift(parityout,u,clk,rst);


parameter Z=511;
parameter r=511;
parameter c=511;
parameter cycle=32;
parameter pa=16;

input [Z-1:0]u;
input clk,rst;
output reg [Z-1:0]parityout;
reg  [Z-1:0]fifoOut;
wire uf[Z-1:0];
integer i;
integer j;
integer count; 

always @(posedge clk) begin
    if (rst) begin
         
           for(j=0;j<Z;j=j+1)begin
                fifoOut[j] <= 0;
           end
        
    end
    else begin

           j=0;
           count=0;
           while(count<Z)
            begin
                fifoOut[(j+pa)%Z] <=  fifoOut[j]^u[(j+pa)%Z];//remove the u xor part to visualize parity shift portion
                j=(j+pa)%Z;
                count=count+1;
           end   
         
    end
    
end  

always@(*)

         for(i=0;i<r;i=i+1)begin
         parityout[i]=fifoOut[i];
         end

endmodule
