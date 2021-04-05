`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2021 10:46:46 AM
// Design Name: 
// Module Name: paritymat_genvar
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


module paritymat_genvar(parityout,u,clk,rst);

parameter Z=5;
parameter r=5;
parameter c=5;
parameter cycle=3;// cycle = ceil(Z/Lm)
parameter pa=2;

input [Z-1:0]u;
input clk,rst;
output reg [Z-1:0]parityout;
reg  fifoOut[Z-1:0][Z-1:0];
wire uf[Z-1:0];
integer i;
integer j;
integer count;
assign uf[0]=u[0];
assign uf[1]=u[1];
assign uf[2]=u[2];
assign uf[3]=u[3];
assign uf[4]=u[4];
always @(posedge clk) begin
    if (rst) begin
         for(i=0;i<r;i=i+1)begin
           for(j=0;j<c;j=j+1)begin
                fifoOut[i][j] <= 0;
           end
        end
    end
    else begin
    
         for(i=0;i<r;i=i+1)begin
           j=i;
           count=0;
           fifoOut[i][j]<=fifoOut[i][(j+pa*(cycle-1))%Z]^u[j];//remove the u xor part to visualize parity shift portion
           while(count<cycle-1)
            begin
                fifoOut[i][(j+pa)%Z] <=  fifoOut[i][j]^u[(j+pa)%Z];//remove the u xor part to visualize parity shift portion
                j=(j+pa)%Z;
                count=count+1;
           end   
         end
    end
    
end  

always@(*)
  for(i=0;i<r;i=i+1)begin
    parityout[i]=fifoOut[i][i];
  end

endmodule
