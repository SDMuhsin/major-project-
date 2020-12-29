`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2020 10:21:20
// Design Name: 
// Module Name: InputQueue
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


module InputQueue(
        muxOut,
        rxIn,
        sliceAddress,
        wrEn,
        chipEn,
        clk,
        rst
);

parameter w = 6; // Width 
parameter r = 32; // Rows of FIFO and input symbol count 
parameter c = 17; // Columns of FIFO
parameter muxOutSymbols = 26 * 2;

input [ r * w - 1 : 0 ]rxIn;
wire [w-1:0]rxInConnector[r-1:0];

output wire [ muxOutSymbols * w - 1 : 0]muxOut;
reg [w-1:0]muxOutConnector[ muxOutSymbols  - 1 : 0];

input [4:0]sliceAddress;
input chipEn,wrEn;
input clk,rst;

reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs

genvar k;

generate
    for (k=0;k<muxOutSymbols;k=k+1)begin:assign_output
        assign muxOut[ (k+1)*w-1:k*w] = muxOutConnector[k];
    end
endgenerate

generate
    for (k=0;k<r;k=k+1)begin:assign_input
        assign rxInConnector[k] = rxIn[(k+1)*w-1:k*w];
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
    else if(chipEn) begin // Chip enable, shift
    
        //LOAD inputs
        if(wrEn)begin // Whether to accept input or not
            //Accept input
            for(i = r-1; i > -1; i=i-1) begin
                fifoOut[i][0] <= rxInConnector[i];       
            end
        end
        else begin
            // If input is not to be accepted, fifo's first row keeps the same values 
            for(i = r-1; i > -1; i=i-1) begin
                fifoOut[i][0] <= fifoOut[i][0];       
            end
        end
        //Shifting process
        // Set (i,j)th value = (i,j-1)th value (except column 0)
        for(i = r-1; i > -1; i=i-1) begin
            for(j= c-1; j > 0; j=j-1)begin
                fifoOut[i][j] <=  fifoOut[i][j-1];       
            end
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

// MUX WIRING
always@(*)begin
    
    // Stuff
    case(sliceAddress)
       default: begin
             for(i=0;i<muxOutSymbols;i=i+1)begin
              muxOutConnector[i] = 1;
             end
       end
    endcase
end
endmodule
