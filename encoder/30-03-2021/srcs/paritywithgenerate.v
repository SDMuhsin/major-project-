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


module parityshift2(parityout,u,ce,clk,rst);


parameter Z=5;

parameter cycle=3;//z/Lm
parameter pa=2;//Lm

input [Z-1:0]u;
input clk,rst,ce;
output reg [Z-1:0]parityout;
reg  fifoOut[Z-1:0];
wire uf[Z-1:0];

genvar count,j;
generate
for(count=1;count<=Z;count=count+1)begin

always @(posedge clk) 
    begin
    if (rst) begin    
                fifoOut[(pa*count)%Z] <= 0;

    end
    else if(ce==1)
            begin
                fifoOut[(pa*count)%Z] <=  fifoOut[(pa*(count-1))%Z]^u[(pa*count)%Z];//remove the u xor part to visualize parity shift portion 
            end
    else
        begin
         fifoOut[(pa*count)%Z] <= fifoOut[(pa*count)%Z]; 
         end   
  
    end 
end
endgenerate

genvar i;
generate
for(i=0;i<Z;i=i+1)begin
always@(*)
    begin
         parityout[i]=fifoOut[i];
    end
end
endgenerate
endmodule
