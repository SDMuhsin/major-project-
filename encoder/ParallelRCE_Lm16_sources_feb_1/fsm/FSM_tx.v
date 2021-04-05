`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2020 13:15:33
// Design Name: 
// Module Name: exor_0
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


module FSM_tx(t_en,str_en,rst,clk);
parameter K=32; // number of message bit1024
parameter N_K=8; // number of parity bit256
parameter s0=2'b00,s1=2'b01,s2=2'b10;
output reg t_en;
input str_en;
input rst;
input clk;
reg [10:0]count_t_en,count_next;
reg [1:0]n_s,p_s;

always@(posedge clk)
begin
if(rst) begin
 count_t_en<=11'd0;
  p_s<=s0; 
  end
  else
 begin
 count_t_en<=count_next;
 p_s<=n_s;
 end
end
 
always@( str_en,count_t_en,p_s)
begin
  case(p_s)
    s0 : if(str_en==1'b0)
            begin 
              n_s=s0;
              t_en=1'b0;
              count_next=11'd0;
            end
            else 
            begin 
              n_s=s1;
              t_en=1'b0;
              count_next=11'd0; 
            end
    s1:  begin
              t_en=1'b0;
                if(count_t_en==K-1)    //counter for msg out, t_en 0 state          
                begin       
                  count_next=11'd0;
                  n_s=s2; 
                end
                else
                begin 
                  count_next=count_t_en+1'b1; 
                 // t_en=1'b0;
                  n_s=s1;
                end   
            end          
     s2: begin
              t_en=1'b1;
                if(count_t_en==N_K-1) // the t_en 1 state
                begin // counter for parity out
                    //t_en=1'b0;
                    count_next=11'd0;
                    n_s=s0; 
                end
                else begin
                    n_s=s2;
                    //t_en=1'b1;
                    count_next=count_t_en+1'b1; 
                end         
            end
      default :  begin n_s=s0;
                 t_en=1'b0;
                 count_next=11'd0;                              
                 end   
     endcase            
     end               
endmodule

