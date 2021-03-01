`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2021 20:58:34
// Design Name: 
// Module Name: stimuluscontroller
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


module stimuluscontroller(rom_address, rd_en, start, clk, rst);
parameter DEPTH=10;
parameter ADDRESSWIDTH=4;

output [ADDRESSWIDTH-1:0] rom_address;
output rd_en;
input start;
input clk, rst;

reg ps,ns;
reg[ADDRESSWIDTH-1:0] count, nextcount;
reg en, next_en;
parameter INIT=1'd0, COUNTING=1'd1;

always@(*)
begin
  case(ps)
    INIT: begin
              ns=start ? COUNTING : INIT;
              nextcount=start ? 0 : count;
              next_en=start ? 1 : 0;            
          end
    COUNTING: begin
              ns=(count<DEPTH-1) ? ps : INIT;
              nextcount=(count<DEPTH-1) ? count+1 : count;
              next_en=(count<DEPTH-1) ? 1 : 0;    
              end
    default:begin
              ns=0;
              nextcount=0;
              next_en=0;
            end
  endcase
end

always@(posedge clk)
begin
  if(!rst)
  begin
    ps<=0;
    count<=0;
    en<=0;    
  end
  else
  begin
    ps<=ns;
    count<=nextcount;
    en<=next_en;     
  end
end

assign rom_address=count;
assign rd_en=en;

endmodule
