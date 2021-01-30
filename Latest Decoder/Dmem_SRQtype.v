`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2020 12:01:25
// Design Name: 
// Module Name: Dmem_SRQtype
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
// Intermediate value(D) = Relative difference btw extrinsic messages of a row of different iterations
// Shift register queue type memory for storing D for all circulants of both layers
// Configurable parameter: W only
// Internal Dmem instances of each circulants are generated using script.
//////////////////////////////////////////////////////////////////////////////////


//module Dmem_SRQtype(rd_data,rd_en,rd_address,rd_layer,wr_data,wr_en,clk,rst);
module Dmem_SRQtype_regout(rd_data_regout,rd_en,rd_address,rd_layer,wr_data,wr_en,clk,rst);
parameter W=6;//6;//configurable by user

//non-configurable parameters
parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
parameter Nb=16;//16;//circulant blocks per layer
parameter Wt=2; //circulant weight
parameter ADDRESSWIDTH = 5;//to address 20 locations corresponding to ceil(Z/P)=20 cycles.
parameter r=P*Wt;
parameter w=W;

output reg[(P*Nb*Wt*W)-1:0] rd_data_regout;
input rd_en;
input [ADDRESSWIDTH-1:0] rd_address;
input rd_layer;
input [(P*Nb*Wt*W)-1:0] wr_data;
input wr_en;
input clk,rst;
//--------registered outputs-------------//
wire [(P*Nb*Wt*W)-1:0] rd_data;
always@(posedge clk)
begin
  if(!rst)
    rd_data_regout<=0;
  else
    rd_data_regout<=rd_data;
end
//--------------------//


//wire [W-1:0] wr_data_arr[P-1:0][Nb-1:0][Wt-1:0];
//wire [W-1:0] rd_data_arr[P-1:0][Nb-1:0][Wt-1:0];
wire [r*w-1:0]dmem_data_in[Nb-1:0];
wire [r*w-1:0]dmem_data_out[Nb-1:0];// r numbers of w bits
wire [ADDRESSWIDTH-1:0] reaccess_address;
wire reaccess_layer;

//aligning according to row calculation unit
//D to Row Calculation Unit = {D_rpu25, D_rpu24, ...., D_rpu2, D_rpu1, D_rpu0}.
// D_rpu# is of width= NbxWtxW = 16x2xW=32xW.
wire [(Nb*Wt*W)-1:0] wr_data_arr[P-1:0];
wire [(Nb*Wt*W)-1:0] rd_data_arr[P-1:0];

assign reaccess_address = rd_address;
assign reaccess_layer = rd_layer;

//Splitting bit vector data to individual data to be fed to each circulant
genvar j_p, i_nb;
generate 
  for(j_p=0;j_p<=P-1;j_p=j_p+1) begin: p26_loop
    assign wr_data_arr[j_p] = wr_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))];
    
    //aligning according to Mem circuits
    //D to/fro memciruits = D_circ15, D_circ14, ..., D_circ2, D_circ1, D_circ0
    // D_circ# is of width = PxWtxW = 26x2xW=52xW.
    for(i_nb=0;i_nb<=Nb-1;i_nb=i_nb+1) begin: Nb16_loop
      assign dmem_data_in[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)] = wr_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)];
      assign rd_data_arr[j_p][((i_nb+1)*Wt*W)-1:(i_nb*Wt*W)] = dmem_data_out[i_nb][((j_p+1)*Wt*W)-1:(j_p*Wt*W)];
    end
    
    assign rd_data[((j_p+1)*(Nb*Wt*W))-1:(j_p*(Nb*Wt*W))] = rd_data_arr[j_p];
    
  end
endgenerate

//genvar i,j,k;
//generate 
//for(i=0;i<=Nb-1;i=i+1) begin: Nb_loop
//  for(j=0;j<=P-1;j=j+1) begin: P26_loop
//    for(k=0;k<=Wt-1;k=k+1) begin: Wt_loop
////      assign wr_data_arr[j][i][k] = wr_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)];
////      assign rd_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)] = rd_data_arr[j][i][k];
      
////      assign lmem_data_in[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )] = wr_data_arr[j][i][k]; 
////      assign rd_data_arr[j][i][k] = lmem_data_out[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )]; 
      
//      assign lmem_data_in[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )] = wr_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)];
//      assign rd_data[ ( ( (i*Wt) + (j*Nb*Wt) + k +1)*W)-1: ( ( (i*Wt) + (j*Nb*Wt) + k )*W)] = lmem_data_out[i][( ( (j*Wt) + k + 1)*W )-1:( ( (j*Wt) + k )*W )];

//    end
//  end
//end
//endgenerate  


//D Shift reg Queue type mem instances

defparam dmemcirc0.w=W, dmemcirc0.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ0_scripted dmemcirc0(dmem_data_out[0],dmem_data_in[0],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc1.w=W, dmemcirc1.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ1_scripted dmemcirc1(dmem_data_out[1],dmem_data_in[1],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc2.w=W, dmemcirc2.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ2_scripted dmemcirc2(dmem_data_out[2],dmem_data_in[2],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc3.w=W, dmemcirc3.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ3_scripted dmemcirc3(dmem_data_out[3],dmem_data_in[3],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc4.w=W, dmemcirc4.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ4_scripted dmemcirc4(dmem_data_out[4],dmem_data_in[4],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc5.w=W, dmemcirc5.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ5_scripted dmemcirc5(dmem_data_out[5],dmem_data_in[5],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc6.w=W, dmemcirc6.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ6_scripted dmemcirc6(dmem_data_out[6],dmem_data_in[6],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc7.w=W, dmemcirc7.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ7_scripted dmemcirc7(dmem_data_out[7],dmem_data_in[7],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc8.w=W, dmemcirc8.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ8_scripted dmemcirc8(dmem_data_out[8],dmem_data_in[8],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc9.w=W, dmemcirc9.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ9_scripted dmemcirc9(dmem_data_out[9],dmem_data_in[9],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc10.w=W, dmemcirc10.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ10_scripted dmemcirc10(dmem_data_out[10],dmem_data_in[10],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc11.w=W, dmemcirc11.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ11_scripted dmemcirc11(dmem_data_out[11],dmem_data_in[11],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc12.w=W, dmemcirc12.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ12_scripted dmemcirc12(dmem_data_out[12],dmem_data_in[12],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc13.w=W, dmemcirc13.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ13_scripted dmemcirc13(dmem_data_out[13],dmem_data_in[13],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc14.w=W, dmemcirc14.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ14_scripted dmemcirc14(dmem_data_out[14],dmem_data_in[14],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);

defparam dmemcirc15.w=W, dmemcirc15.r=P*Wt; //addresswidth is constant at 5.
Dmem_circ15_scripted dmemcirc15(dmem_data_out[15],dmem_data_in[15],wr_en,reaccess_address,reaccess_layer,rd_en, clk, rst);


endmodule

