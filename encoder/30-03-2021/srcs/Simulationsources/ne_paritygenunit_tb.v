`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2021 04:09:28 PM
// Design Name: 
// Module Name: ne_paritygenunit_tb
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


module ne_paritygenunit_tb();
parameter Lm=2;// number of message bit
parameter Z=5; // size of circulant sub matrix of generator matrix//change thhis to 2 or 3 to visualize in elaborated design
//parameter Logsize=30;//16+8+4+2

parameter cycle=3;//Ceil(Z/Lm)



wire [Z-1:0]u_reg;
wire [Z-1:0] u;
//output u0,u1,u2,u3,u4;
reg [Lm-1:0]msg_inp;
reg [Z-1:0]f_inp;//
//input [Lm-1:0]fnext;//
reg rst,clk;    

//parityshift using generate and parity shift seq rule:
reg ce;
wire[Z-1:0]parityout;

//parity shift using add rule
//wire [Z-1:0]u; //in
reg clr; //in
//wire [Z-1:0] parityout; //out

    
    defparam dut.M=Z, dut.Lm=Lm;
 Parity_generation_unit_chaintree dut(u_reg,msg_inp,f_inp,rst,clk);//processing unit

 assign u = dut.u;

//parity shift using generate and parity shift seq Rule: 
//     defparam d2.Z=Z, d2.r=Z, d2.c=Z, d2.pa=Lm, d2.cycle=cycle;
// parityshift2 d2(parityout,u,ce,clk,rst);

//always
//#0.5 clk=~clk;

//initial begin
//  f_inp=0; msg_inp=0; rst=1; clk=0; ce=0;
//  @(posedge clk);
//  @(posedge clk);
//  rst=0; ce=1;
//  @(posedge clk);
//  //f = [0,0,1,0,1] given bitrev. mZ=[0,1,1,1,1,0] ->bitrev: [0,1,1,1,1,0]: 
//  //fed without bitrev in Lm bits {0,1} -> {1,1} -> {1,0}
//  @(negedge clk) f_inp={5'b10100}; msg_inp=2'b01; //cycle1
//  @(negedge clk) f_inp={5'b10100}; msg_inp=2'b11; //cycle2
//  @(negedge clk) f_inp={5'b10100}; msg_inp=2'b10; //cycle3
//  //
//  @(posedge clk);@(negedge clk) f_inp={5'b00000}; msg_inp=2'b00;//cycle4 
//  @(posedge clk);//cycle5
//  @(posedge clk);//cycle6 : parity ready in parityout
  
//  @(posedge clk);
//  @(negedge clk) f_inp={5'b11001}; msg_inp=2'b01;
//  @(negedge clk) f_inp={5'b00000}; msg_inp=2'b01;
//  repeat(4) @(posedge clk);
//  @(negedge clk) f_inp={5'b11001}; msg_inp=2'b10;
//  @(negedge clk) f_inp={5'b11001}; msg_inp=2'b11;
  
//  repeat(10) @(posedge clk);
//  $finish;
//end

defparam d2.Z=Z, d2.Lm=Lm;
ne_parityshifter d2(parityout,u,clk,clr,rst);

always #0.5 clk=~clk;

initial begin
  f_inp=0; msg_inp=0; rst=1; clk=0; clr=0;
  @(posedge clk);
  @(posedge clk);
  rst=0;
  @(posedge clk);
  //f = [0,1,1,0,0] fed with bitrev as [0,0,1,1,0]. 
  // mZ=[1,1,0,1,0, 0] ->bitrev: [0, 0,1,0,1,1]: 
  //msg bitrev is fed with bitrev for each Lm sections, ie in Lm bits {0,0} -> {0,1} -> {1,1}
  @(negedge clk) f_inp={5'b00110}; msg_inp=2'b10; //cycle1
  @(negedge clk) f_inp={5'b00110}; msg_inp=2'b00; //cycle2
  @(negedge clk) f_inp={5'b00110}; msg_inp=2'b01; //cycle3
  //
  @(negedge clk) f_inp={5'b00000}; msg_inp=2'b00;//cycle4 
  @(posedge clk);//cycle5
  @(posedge clk);//cycle6 : parity ready in parityout
  
  @(negedge clk) clr=1;
  @(negedge clk) clr=0;
  repeat(10) @(posedge clk);
  $finish;
end



endmodule
