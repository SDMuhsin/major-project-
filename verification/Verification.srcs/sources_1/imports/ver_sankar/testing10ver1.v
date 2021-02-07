`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.02.2021 00:01:41
// Design Name: 
// Module Name: testing10ver1
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


module testing10ver1( );
    
    
    
    //RCU
//Configurable
parameter W=6;
//non-configurable parameters
parameter Nb=16;
parameter Wc=32;
parameter Wcbits = 5;//2**5 =32
parameter LAYERS=2;
parameter ADDRESSWIDTH = 5;//2^5 = 32 > 20
parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
parameter EMEMDEPTH=ADDRDEPTH*LAYERS; //for LUT RAM //512;//for BRAM ineffcient//
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
parameter RCU_PIPESTAGES=13;

//Agen controller
//configurable
parameter MAXITRS = 10;
parameter ITRWIDTH = 4;//2**4 = 16 > 9
//non-configurable
parameter Z=511;
parameter P=26;
parameter PIPESTAGES = RCU_PIPESTAGES+2;//memrd+RCU_PIPESTAGES+memwr
parameter PIPECOUNTWIDTH = 4;//2**4= 16 > 14
parameter ROWDEPTH=ADDRDEPTH;//20;//Z/P; //Z/P = 73
parameter ROWWIDTH = ADDRESSWIDTH;//5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
//last_p rowdepth and pipestages.
parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17

//bitnodemem (Lmem)
//Configurable
//parameter W=6;//6;
parameter maxVal = 6'b011111;
//non-configurable parameters
//parameter P=26;//rows per cycle
//parameter Z=511;//circulant size
//parameter Nb=16;//16;//circulant blocks per layer
parameter Kb=14;//first 14 circulant columns correspond to systematic part
parameter HDWIDTH=32;//taking 32 bits at a time
parameter Wt=2; //circulant weight
//parameter ADDRESSWIDTH = 5;//to address 20 locations correspondin to ceil(Z/P)=20 cycles.
parameter r=P*Wt;//r is predefined to be 52. non configurable.
parameter w=W;
wire [(Kb*HDWIDTH)-1:0] unload_HDout_vec_regout;
wire [(P*Nb*Wt*W)-1:0] rd_data_regout;
reg unload_en;
reg [ADDRESSWIDTH-1:0] unloadAddress;
reg rd_en;
reg [ADDRESSWIDTH-1:0] rd_address;
reg rd_layer;
reg [(32*Nb*W)-1:0] load_data;
reg loaden;
reg [(P*Nb*Wt*W)-1:0] wr_data;
reg wr_en;
reg wr_layer;
reg firstprocessing_indicate; //from controller send after fsm start, iff (itr==0), first iter=1.
reg clk,rst;

parameter nofb=3072;
parameter lines=17;
reg [nofb-1:0]membb[lines-1:0];
reg [4992-1:0]membout[20-1:0];
  
    
    
    //Bit Node Memory or LLR memory (Lmem) instance
defparam bitnodemem.W=W, bitnodemem.maxVal=maxVal;
//Lmem_SRQtype_withfedbackshift_reginout bitnodemem(unload_HDout_vec_regout,rd_data_regout,unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstprocessing_indicate, clk,rst);
Lmem_SRQtype_combined_ns_reginout_pipeV1 bitnodemem(unload_HDout_vec_regout,rd_data_regout, unload_en,unloadAddress,rd_en,rd_address,rd_layer, load_data,loaden, wr_data,wr_en,wr_layer, firstprocessing_indicate, clk,rst);


 integer i,j,f1,f2;
 parameter test_line = 0;
    initial begin
    clk=1'b0;
    rst = 1'b0;
    loaden=1'b0;
    load_data=0;
    rd_en=0;
    rd_address=1;
    rd_layer=0;
    unload_en=1'b0;
    unloadAddress=0;
    wr_data=0;
    wr_en=0;
    wr_layer=0;
    firstprocessing_indicate=0;
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\ver_sankar\\ne_decoder_verif\\outputs\\input_codeword_17x32x16.txt",membb);
    $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\ver_sankar\\ne_decoder_verif\\outputs\\output_codeword_20x26x2x16.txt",membout);
    
  #20
    rst = 1'b1;
    loaden=1'b1;
firstprocessing_indicate=1'b1;
    
    for(i=0;i<17;i=i+1)
        begin
        
        load_data=membb[i];
        #20;
        end


 rd_address=test_line;
  loaden=1'b0;
   rd_en=1'b1;
#200
$display("%h",membout[test_line]);
$display("%h",rd_data_regout);
$display("%b",rd_data_regout^membout[test_line ]);


f1 = $fopen("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\ver_sankar\\ne_decoder_verif\\outputs\\from_tb_codeword_32x16.txt","w");
f2 = $fopen("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\ver_sankar\\ne_decoder_verif\\outputs\\from_script_codeword_32x16.txt","w");
$fwrite(f1,"%b",rd_data_regout);
$fwrite(f2,"%b",membout[test_line]);


$fclose(f1);
$fclose(f2);
if(rd_data_regout==membout[test_line ])
$display("success");


 end   
    
    always #10 clk = ~clk;






endmodule
