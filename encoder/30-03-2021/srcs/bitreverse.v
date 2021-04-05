`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2019 09:48:24 AM
// Design Name: 
// Module Name: bitreverse
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


module bitreverse(yrev,y);
parameter N =32;
output[N-1:0] yrev;
input[N-1:0] y;
genvar i;

generate for(i=N-1;i>=0;i=i-1) begin:bitrevloop
 assign yrev[i] = y[N-1-i];
end
endgenerate


//always@(*)
//begin
//   yrev[N-1:0] = {y[0:N-1]};
//end

endmodule
