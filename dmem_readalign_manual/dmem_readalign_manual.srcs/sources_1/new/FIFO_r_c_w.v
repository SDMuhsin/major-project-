`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2020 18:49:55
// Design Name: 
// Module Name: FIFO_r_c_w
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


module DMem(
        muxOut,
        dMemIn,
        reaccessAddress,
        clk,
        rst
    );
parameter cycles = 8; // How many mux inputs/ how many access cycles
    
parameter w = 6; // Width 
parameter r = 4; // Rows of FIFO 
parameter c = 2; // Columns of FIFO

parameter reaccessAddressWidth = 3;
parameter muxInCount = 8;

input [reaccessAddressWidth-1:0]reaccessAddress;
input clk,rst;
input [r*w-1:0]dMemIn;
wire [w-1:0]dMemInDummy[r-1:0];


output wire [r*w -1 : 0]muxOut;// r numbers of w bits
reg [w-1:0]muxOutWire[r-1:0];
// Make FIFO
// Needs c stages, and r parallel fifos, intermediate values must be accessible

// FIFO Input : r inputs w bits each
// FIFO Output : r * c outputs, w bits each

reg [w-1:0] fifoOut[r-1:0][c-1:0]; // FIFO Outputs
reg [w-1:0] fifoIn[r-1:0];


genvar k;
generate
    for (k=0;k<r;k=k+1)begin:assign_output
        assign muxOut[ (k+1)*w-1:k*w] = muxOutWire[k];
        assign dMemInDummy[k] = dMemIn[ (k+1)*w-1:k*w];
    end
endgenerate

integer i;
integer j;
always @(posedge clk) begin
    
    if (rst) begin          
    
        for(i=0;i<r;i=i+1)begin
           for(j=0;j<c;j=j+1)begin
                fifoOut[i][j] <= 0;
           end  
        end
        
    end
    else begin
        
        // Set (i,j)th value = (i,j-1)th value
        for(i = r-1; i > -1; i=i-1) begin
            for(j= c-1; j > 0; j=j-1)begin
                fifoOut[i][j] <=  fifoOut[i][j-1];       
            end
        end
        
        // Load Inputs
        for(i = r-1; i > -1; i=i-1) begin
            fifoOut[i][0] <=  dMemInDummy[i];       
        end
        
    end
    
    
end

// The manual mux config
always@(*)begin
    case(reaccessAddress)
        0,1,2:begin
            for(i=0;i<r;i=i+1)begin
                muxOutWire[i] = 0;
            end
        end
        3:begin
            muxOutWire[0] = fifoOut[0][0];
            for(i=1;i<r;i=i+1)begin
                muxOutWire[i] = 0;
            end          
        end
        7:begin
            muxOutWire[0] = 0;
            muxOutWire[2] = 0;
            muxOutWire[1] = fifoOut[1][1];
            muxOutWire[3] = fifoOut[2][1];
        end
        default:begin
        
            muxOutWire[0] = fifoOut[0][0];
            muxOutWire[1] = fifoOut[1][1];
            muxOutWire[2] = fifoOut[3][1];
            muxOutWire[3] = fifoOut[2][1];
        end
    endcase
end 
endmodule
