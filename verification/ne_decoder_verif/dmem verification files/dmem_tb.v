`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2021 09:27:04
// Design Name: 
// Module Name: rowcomputer_tb
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


module dmem_tb(

    );
    
    //RCU
    //Configurable
    parameter W=6;
    //non-configurable parameters
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;                           //2**5 =32
    parameter LAYERS=2;
    parameter ADDRESSWIDTH = 5;                     //2^5 = 32 > 20
    parameter ADDRDEPTH = 20;                       //ceil(Z/P) = ceil(511/26)
    parameter EMEMDEPTH=ADDRDEPTH*LAYERS;           //for LUT RAM //512;//for BRAM ineffcient//
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
    parameter PIPESTAGES = RCU_PIPESTAGES+1;    //memrd+RCU_PIPESTAGES//+memwr
    parameter PIPECOUNTWIDTH = 4;               //2**4= 16 > 13
    parameter ROWDEPTH=ADDRDEPTH;               //20=Z/P; //Z/P = 73
    parameter ROWWIDTH = ADDRESSWIDTH;          // 2**5 = 32 > 20; //2**7 = 128 > 72
    //last_p rowdepth and pipestages.
    parameter P_LAST = Z-(P*(ROWDEPTH-1));       //511-(26*19)=511-494=17=valid lines in address 20
    
    //bitnodemem (Lmem)
    //Configurable
    parameter maxVal = 6'b011111;
    //non-configurable parameters
    parameter Kb=14;                            //first 14 circulant columns correspond to systematic part
    parameter HDWIDTH=32;                       //taking 32 hard decision bits at a time
    parameter Wt=2;                             //circulant weight
    parameter r=P*Wt;                           //r is predefined to be 52. non configurable.(26x2)
    parameter w=W;
    
    wire [(P*Nb*Wt*W)-1:0] rd_data_regout;
    reg [(P*Nb*Wt*W)-1:0] reference;
    //output [(P*Nb*Wt*W)-1:0] rd_data;
    reg rd_en;
    reg [ADDRESSWIDTH-1:0] rd_address;
    reg rd_layer;
    reg [(P*Nb*Wt*W)-1:0] wr_data;
    reg wr_en;
    reg clk,rst;
    
    parameter nofb=4992;
    parameter lines=19;
    reg [nofb-1:0]membb[lines-1:0];
    reg [nofb-1:0]membb_1[lines:0];
   

  //  ne_rowcomputer_SRQ_p26 rc(decoder_ready,unload_HDout_vec_regout, unload_en, unloadAddress, load_data, loaden, start, clk,rst);
    Dmem_SRQtype_regout dmem(rd_data_regout,rd_en,rd_address,rd_layer,wr_data,wr_en,clk,rst);
    integer i;
    initial begin
    
    clk=1'b0;
    rst = 1'b0;
    rd_en=1'b0;
    rd_address=0;
    rd_layer=1'b0;
    wr_en=1'b0;
    
    $readmemb("C:\\Users\\mani\\Downloads\\ne_decoder_verif\\DMem_write_Scripted.txt",membb);
    $readmemb("C:\\Users\\mani\\Downloads\\ne_decoder_verif\\DMem_read_Scripted.txt",membb_1);
    
    #4
        clk=1'b0;
        rst = 1'b1;
        rd_en=1'b1;
        rd_address=0;
        rd_layer=1'b0;  //change to 1 for checking layer 1; changes to be made in script too
        wr_en=1'b0;
        reference=membb_1[0];
        #10
        rd_address=5'b00001;
        reference=membb_1[1];
        //#10
        //rd_address=5'b00010;
        //reference=membb_1[2];
        #10
        //rd_address=5'b00010;
        wr_en=1'b1;
    for(i=0;i<17;i=i+1)
        begin
        wr_data=membb[i];
        rd_address=i+2;
        reference=membb_1[i+1];
        #10;
        end
            #30;
        $finish;
    end
    always #5 clk = ~clk;
    
    always@(posedge clk) begin
    
    $display("rdaddress = %b",rd_address);
    $display("writedata = %b",wr_data);
    $display("read_data = %b",rd_data_regout);
    $display("reference = %bn",reference);
    if(rd_data_regout==reference) begin
    $display("Success");
    end
    
    //assign lin_data_display
    end
    
    /*always@(negedge clk) begin
    #1
    
    end*/
endmodule