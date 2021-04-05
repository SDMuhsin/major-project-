`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2020 15:34:20
// Design Name: 
// Module Name: counter_load
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


module counter_load(en,parity_parload_en, f_sel, m_en,sm,start,rst,clk);
parameter K=1024;//1024
parameter Lm = 16;
parameter La=8;
parameter MSEL_BITSIZE = 3;//log2(K/(Lm*La))

parameter s0=1'b0,s1=1'b1;
output reg en;
output reg parity_parload_en;
output reg [1:0] f_sel;
output reg [MSEL_BITSIZE-1:0]m_en;
output reg sm;//after 4 clock message will zero other parity bit will ex-or with default value
input start; //to control count1
input rst;
input clk;
reg [10:0]count1;
//reg [1:0]count_mux;
reg p_s,n_s,sm1, p_en_next;
reg [MSEL_BITSIZE-1:0]m_en_next;

reg[3:0] en_delay;

//always @(posedge clk) begin
//  if(rst) 
//  begin
//    en<=1'b0;
//    count1<='d0;
//  end
//  else if(count1==K-1)
//  begin 
//    en<=1'b1;
//    count1<='d0;
//  end
//  else if(start==1) 
//  begin
//    count1<= count1+1;
//    en<=1'b0; 
//  end 
//  else 
//  begin
//    count1<= count1;
//    en<=1'b0; 
//  end    
//end

always @(posedge clk) begin
  if(rst) 
  begin
    count1<=0;
  end
  else if(count1==K-1)
  begin 
    count1<=0;
  end
  else if(start==1) 
  begin
    count1<= count1+1;
  end 
  else 
  begin
    count1<= count1;
  end    
end

always@(posedge clk)
begin
  if(rst)
    en_delay<=4'b0;
  else if(count1==K-1)
  begin
    en_delay[0]<=1'b1;
    en_delay[1]<=en_delay[0];
    en_delay[2]<=en_delay[1];
    en_delay[3]<=en_delay[2];
  end
  else
    begin
      en_delay[0]<=1'b0;
      en_delay[1]<=en_delay[0];
      en_delay[2]<=en_delay[1];
      en_delay[3]<=en_delay[2];      
    end
end

always@(en_delay)
  en = en_delay[0] | en_delay[1] | en_delay[2] | en_delay[3];

always@(posedge clk)
if(rst) begin
  p_s<=s0;
  m_en<=0;
  f_sel<=0;
  sm<=1'b0; 
  parity_parload_en<=0;
  end
else begin
  p_s<=n_s;
  m_en<=m_en_next;
  f_sel<=m_en_next[MSEL_BITSIZE-1:1];//if m_en bitsize is more than 2.
  sm<=sm1; 
  parity_parload_en<=p_en_next;
end

always@(p_s,en,m_en)
case(p_s)
 s0: if(en==1'b0)
     begin
         m_en_next=0;
         n_s=s0;
         sm1=1'b0;
         p_en_next=0;//
     end
     else 
     begin
         m_en_next=0;
         n_s=s1;
         sm1=1'b1; 
         p_en_next=0;//
      end
 s1 : if(m_en==(K/(Lm*La))-1) //corr: was m_en_next
      begin 
        n_s=s0;
        m_en_next=0;
        sm1=1'b0;
        p_en_next=1;//
      end
      else
      begin
        m_en_next=m_en+1;//corr: was m_en_next
        n_s=s1;
        sm1=1'b1;
        p_en_next=0;//
      end
   default : begin
         p_s=s0;
         m_en_next=0;
         sm1=1'b0; 
         p_en_next=0;
         end
         endcase     
endmodule
