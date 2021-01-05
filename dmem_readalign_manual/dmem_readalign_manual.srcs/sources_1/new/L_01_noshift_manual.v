`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2021 08:13:37
// Design Name: 
// Module Name: L_01_noshift_manual
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


module L_01_noshift_manual(
        muxOut,
        ly0In,
        sliceAddress,
        chipEn,
        clk,
        rst 
);
parameter w = 6; // Width 
parameter r = 52; 
parameter c = 17; 
parameter muxOutSymbols = 26 * 2;
parameter maxVal = 6'b011111;

input [ r * w - 1 : 0 ]ly0In; // Change #3
wire [w-1:0]ly0InConnector[r-1:0]; // Change #5
input [4:0]sliceAddress;
input clk,rst,chipEn; // #C

output wire [ muxOutSymbols * w - 1 : 0]muxOut;
reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];
reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs

genvar k;
generate
    for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output
        assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];
    end
endgenerate
generate
    for (k=0;k<r;k=k+1)begin:assign_input
        assign ly0InConnector[k] = ly0In[(k+1)*w-1:k*w];
    end
endgenerate

integer i;
integer j;
always@(posedge clk)begin
    if (rst) begin    
        for(i=0;i<r;i=i+1)begin
            for(j=0;j<c;j=j+1)begin
                fifoOut[i][j] <= 0;
            end
        end
    end
    else if(chipEn) begin
        // Shift
        for(i = r-1; i > -1; i=i-1) begin
            for(j= c-1; j > 0; j=j-1)begin
                fifoOut[i][j] <=  fifoOut[i][j-1];
            end
        end
        // Input
        for(i = r-1; i > -1; i=i-1) begin
            fifoOut[i][0] <= ly0InConnector[i];
        end
    end
    else begin
        for(i=0;i<r;i=i+1)begin
           for(j=0;j<c;j=j+1)begin
                fifoOut[i][j] <= fifoOut[i][j];
           end
        end
    end
end
endmodule
