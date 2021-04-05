`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2020 15:20:23
// Design Name: 
// Module Name: test_bench
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


//module test_bench();
//parameter K=32;
//parameter M=8;
////wire [M-1:0]msg_out; // insteaded of Lm-1,Lm for generating sequence
////wire q21;
//wire y;
//wire [M-1:0]p;
//reg msg;
//reg rst,clk,clk_in;
////reg[K:0]msg1='b01;
//reg [K:0]msg1='h12345678;//_51324678_87654231_32154584_24242515_51324678_87654231_32154584;
//integer  i;
//parallel_RCE_Row_par DUT0(y,p,msg,rst,clk_in,clk);
//initial
//clk=1'b0;
//always #5 clk=~clk;
//initial
//clk_in=1'b0;
//always #5 clk_in=~clk_in;
//initial
//begin 
//rst=1'b1;
//#15
//rst=1'b0;
// for(i=0;i<K;i=i+1)begin
//    @ (posedge clk) msg=msg1[i];
//    end
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b0;
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b0;
////@(posedge clk)
////in=1'b0;
////@(posedge clk)
////in=1'b0;
////@(posedge clk)
////in=1'b1;
////@(posedge clk)
////in=1'b0;
////@(posedge clk)
////in=1'b1;

//# 1000 $stop;
//end
//endmodule



module test_bench();
//Ts2p=11, c_s2p=1056//1.815
//Tenc=24, c_enc=484// 1.92
//Tp2s = 8, c_p2s=1452//adjusted to 1.32 from 1.28
 
parameter N = 32;
parameter M=256;
parameter KMEM = 32;
wire y;
wire p;
reg msg;
reg datavalid,rst,clk_in,clk;

 parallel_RCE_Lm pararcelm_DUT(y,p,msg,datavalid,~rst,clk_in,clk);

reg[N-1:0] samplemsg;
reg[N-1:0] msgmem[0:KMEM-1];//0 is MSB, N-1 is LSB, feed LSB first , MSB last.
integer i, j, clkcounts2penc, clkcountp2s;    
integer msgcount;

// always #2.5 clk=~clk; //clk is fast clk for codeword out p2s.
  always #1.8 clk=~clk; 
 

// always #5 clk_in=~clk_in; //clk_in is slow clk for processing and msg s2p
always #2.25 clk_in=~clk_in;

initial
begin
clk=0;clk_in=0;

msgmem[0] = 32'hD9DA7BEA;
msgmem[1] = 32'h1A31D8AB;
msgmem[2] = 32'hE2A27B4E;
msgmem[3] = 32'h855C5C5C;
msgmem[4] = 32'h50ED00C4;
msgmem[5] = 32'h8388EA9B;
msgmem[6] = 32'h0FB7C204;
msgmem[7] = 32'hC2C12D39;
msgmem[8] = 32'h97157A6F;
msgmem[9] = 32'hC8E4BBE4;
msgmem[10] = 32'h32C40D35;
msgmem[11] = 32'hF2716092;
msgmem[12] = 32'hEBA02E37;
msgmem[13] = 32'h9817D636;
msgmem[14] = 32'hA144551D;
msgmem[15] = 32'hF49ADE37;
msgmem[16] = 32'hF01F2E72;
msgmem[17] = 32'h4AC0AB35;
msgmem[18] = 32'hBE3A20FF;
msgmem[19] = 32'h7A7D7FCA;
msgmem[20] = 32'hD005A332;
msgmem[21] = 32'h1BBF085C;
msgmem[22] = 32'h2BC611AE;
msgmem[23] = 32'h8820839D;
msgmem[24] = 32'h27ECB2E3;
msgmem[25] = 32'hA5EE3894;
msgmem[26] = 32'h885B5289;
msgmem[27] = 32'h307400E3;
msgmem[28] = 32'h98546B83;
msgmem[29] = 32'h039E89EE;
msgmem[30] = 32'hD41DC9E5;
msgmem[31] = 32'hF9AC1751;

  @(posedge clk_in) msg=0;rst=0;samplemsg = 0; datavalid=0;
  
    @(posedge clk_in) rst = 1;
  //first set of msg
  for(j=0;j<=31;j=j+1)
  begin
   samplemsg = msgmem[j]; msgcount=1;
  for(i=0;i<=N-1;i=i+1) //Feed MSB first thn LSB.
  begin
    @(posedge  clk_in)   datavalid=1; msg = samplemsg[N-1-i];
  end
  end
  //Second set of msg
  for(j=0;j<=31;j=j+1)
  begin
  rst = 1; samplemsg = msgmem[j] ^ 32'd1; msgcount=2;
  for(i=0;i<=N-1;i=i+1) //Feed MSB first thn LSB.
  begin
    @(posedge  clk_in)    msg = samplemsg[N-1-i];
  end
  end
  //Third set of msg
  for(j=0;j<=31;j=j+1)
  begin
   rst = 1; samplemsg = msgmem[j] ^ 32'd3; msgcount=3;
  for(i=0;i<=N-1;i=i+1) //Feed MSB first thn LSB.
  begin
    @(posedge  clk_in)   msg = samplemsg[N-1-i];
  end
  end
//    //fourth set of msg
//  for(j=0;j<=31;j=j+1)
//  begin
//   rst = 1; samplemsg = msgmem[j] ^ 32'd7; msgcount=4;
//  for(i=0;i<=N-1;i=i+1) //Feed MSB first thn LSB.
//  begin
//    @(posedge  clk_in)  msg = samplemsg[N-1-i];
//  end
//  end
  @(posedge  clk_in) ;
   repeat(1500) @(posedge  clk_in) ;
  #5000 $stop;
end

//input and encoding slow clk
always@(posedge  clk_in)
begin
  clkcounts2penc<= rst ? clkcounts2penc+1 : 0;
end

//output fast clk
always@(posedge clk)
begin
  clkcountp2s<= rst ? clkcountp2s+1 : 0;
end
//always@(posedge p2s_clk or negedge rst)
//begin
//  clkcountp2s<= rst ? clkcountp2s+1 : 0;
//end

//always@(posedge p2s_clk or posedge enc_clk or negedge rst)
//begin
//  clkcountor<= rst ? clkcountor+1 : 0;
//end

initial
begin
  $monitor ("cycle = %6d, dut0.pr1 first 8 = %h, dut0.pr1 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr1[255:255-31],pararcelm_DUT.pr1[31:0]);
  $monitor ("cycle = %6d, dut0.pr2 first 8 = %h, dut0.pr2 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr2[255:255-31],pararcelm_DUT.pr2[31:0]);
  $monitor ("cycle = %6d, dut0.pr3 first 8 = %h, dut0.pr3 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr3[255:255-31],pararcelm_DUT.pr3[31:0]);
  $monitor ("cycle = %6d, dut0.pr4 first 8 = %h, dut0.pr4 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr4[255:255-31],pararcelm_DUT.pr4[31:0]);
  $monitor ("cycle = %6d, dut0.pr5 first 8 = %h, dut0.pr5 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr5[255:255-31],pararcelm_DUT.pr5[31:0]);
  $monitor ("cycle = %6d, dut0.pr6 first 8 = %h, dut0.pr6 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr6[255:255-31],pararcelm_DUT.pr6[31:0]);
  $monitor ("cycle = %6d, dut0.pr7 first 8 = %h, dut0.pr7 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr7[255:255-31],pararcelm_DUT.pr7[31:0]);
  $monitor ("cycle = %6d, dut0.pr8 first 8 = %h, dut0.pr8 last 8 = %h", clkcounts2penc, pararcelm_DUT.pr8[255:255-31],pararcelm_DUT.pr8[31:0]);
  $monitor ("cycle = %6d, LayerXOR result dut0.pr first 8 = %h, dut0.pr last 8 = %h", clkcounts2penc, pararcelm_DUT.pr[255:255-31],pararcelm_DUT.pr[31:0]);
  $monitor ("cycle = %6d, 4CycleXOR result dut0.q12 first 8 = %h, dut0.q12 last 8 = %h", clkcounts2penc, pararcelm_DUT.q12[255:255-31],pararcelm_DUT.q12[31:0]);

end
endmodule