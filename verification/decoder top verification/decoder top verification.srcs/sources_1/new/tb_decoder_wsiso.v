`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2021 13:57:14
// Design Name: 
// Module Name: tb_decoder_wsiso
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


module tb_decoder_wsiso(

    );
    
    parameter W=6;
    parameter Nb=16;
    parameter Wc=32;
    parameter Wcbits = 5;//2**5 =32
    parameter LAYERS=2;
    parameter ADDRESSWIDTH = 5;//2^5 = 32 > 20
    parameter ADDRDEPTH = 20;//ceil(Z/P) = ceil(511/26)
    parameter EMEMDEPTH=ADDRDEPTH*LAYERS; //for LUT RAM //512;//for BRAM ineffcient//
    parameter Wabs=W-1;
    parameter ECOMPSIZE = (2*Wabs)+Wcbits+Wc;
    parameter RCU_PIPESTAGES=13;//11;
    //configurable
    parameter MAXITRS = 10;
    parameter ITRWIDTH = 4;//2**4 = 16 > 9
    parameter Z=511;
    parameter P=26;
    parameter PIPESTAGES = RCU_PIPESTAGES+2;//memrd+RCU_PIPESTAGES+memwr
    parameter PIPECOUNTWIDTH = 4;//2**4= 16 > 14
    parameter ROWDEPTH=ADDRDEPTH;//20;//Z/P; //Z/P = 73
    parameter ROWWIDTH = ADDRESSWIDTH;//5;//7;//2**7 = 128 > 72, 2**5 = 32 > 20.
    parameter P_LAST = Z-(P*(ROWDEPTH-1));//511-(26*19)=511-494=17
    parameter maxVal = 6'b011111;
    parameter Kb=14;//first 14 circulant columns correspond to systematic part
    parameter HDWIDTH=32;//taking 32 bits at a time
    parameter Wt=2; //circulant weight
    parameter r=P*Wt;//r is predefined to be 52. non configurable.
    parameter w=W; 
    parameter FIFODEPTH=32;//17
    parameter DW=32*W;
    parameter NB=Nb;//
    parameter KB=Kb;// message blocks
    parameter HDDW=HDWIDTH;
    parameter UNLOADCOUNT=17;//size(unloadrequestmap2(:,:,2)=[17,32], UNLOADCOUNT=rows=17.

    wire datavalid;//output
    wire [(HDDW)-1:0] HD_out;//output//dout is 1 bit
    reg [DW-1:0] Codeword_in;
    reg code_valid;
    reg in_clk;
    reg clk;
    reg out_clk;
    reg rst;
    
    ne_decoder_top_pipeV3 dut(datavalid, HD_out, Codeword_in, code_valid, in_clk, clk, out_clk, rst);
    
    integer counter_in,counter;
    parameter Tby2_inclk = 5, Tby2_clk = 0.5, Tby2_outclk = 4;
    
    always #Tby2_inclk in_clk = ~in_clk; 
    always #Tby2_outclk out_clk = ~out_clk; 
    always #Tby2_clk clk = ~clk; 
    
    always @(posedge in_clk) #2 counter_in = counter_in + 1;
    always @(posedge clk) #0.4 counter = counter + 1;
    
    parameter input_lines = 257;
    parameter input_width = 32*W;
    
    parameter inp_intf_out_lines = 17;
    
    reg [input_width-1:0]inp_257x32[input_lines-1:0];
    reg [16*32*W-1:0]inp_17x512[inp_intf_out_lines-1:0];
    
    integer i1;
    initial begin
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\outputs\\input_257x32.txt",inp_257x32);
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\outputs\\input_codeword_17x32x16.txt",inp_17x512);
        #0.1;
        Codeword_in = 0;
        code_valid = 0;
        in_clk = 0;
        out_clk = 0;
        clk = 0;
        rst = 0;
        #0.1;
        
        @(posedge in_clk); // Reset
        #0.002;
        rst = 1;
        code_valid = 1;
        
        counter_in= 0;
        counter = 0;
        
        for(i1 = 0; i1 < input_lines; i1 = i1+1)begin
            Codeword_in = inp_257x32[i1];
            @(posedge in_clk);
            #0.01;    
        end
        
        code_valid = 0;
        
        
    end
    
    // Displays
    always@(posedge in_clk)begin
        #0.001;
        
        if(counter_in == 257)begin
            code_valid = 0;
        end
        $display("\n\n IN_CLK = %d", counter_in);
        $display(" start = %b | loaden = %b | inputintf.inputfifo.ps = %b | inputintf.inputfifo.wr_en = %b", dut.start, dut.loaden, dut.inputintf.inputfifo.ps, dut.inputintf.inputfifo.wr_en);
         $display("      dut.cdwrd_in  = %b", dut.Codeword_in);
        //$display(" loader.ps = %b ( 1 for counting) ", dut.inputintf.loader.ps);
        //$display(" loader.addr_count = %d( should start coutning to 17 ) ", dut.inputintf.loader.addr_count);
    end
    
    integer load_counter ;
    integer check_load;
    initial begin
        check_load = 0;
    end
    always@(posedge dut.loaden)begin
        load_counter = 0;
        check_load = 1;
        $display(" LOADEN SET");
        $display("      dut.load_data = %b", dut.load_data);
        $display("      [0] RA %b", dut.inputintf.inputfifo.nb_loop[2].submem.RA);
    end
    always@(negedge dut.loaden)begin
        check_load = 0;
    end
    always @(posedge clk)begin
        
        if(counter_in == 256)begin
            counter = 0;
        end
        if(check_load && counter_in < 260 )begin
            $display("\n      CLK = %d", counter);
            $display("      loader.addr_count = %d( should start coutning to 17 ) ", dut.inputintf.loader.addr_count);
            $display("      loader_counter ", load_counter);
            $display("      dut.load_data = %b", dut.load_data);
            $display("      reference[2]  = %b", inp_17x512[load_counter ]);
            $display("      xor           = %b", inp_17x512[ load_counter ] ^ dut.load_data);
            if( inp_17x512[ load_counter ] == dut.load_data)begin
                $display(" MATCH on address count" , load_counter);
            end
            else begin $display(" NO MATCH on address count" , load_counter); end
            $display("      start = %b | loaden = %b | inputintf.inputfifo.ps = %b | inputintf.inputfifo.wr_en = %b", dut.start, dut.loaden, dut.inputintf.inputfifo.ps, dut.inputintf.inputfifo.wr_en);
            $display("      loader.ps = %b ( 1 for counting) ", dut.inputintf.loader.ps);
            $display("[0] RA %b", dut.inputintf.inputfifo.nb_loop[2].submem.RA);
            #0.001;
            load_counter = load_counter + 1;
        end
    end
    
endmodule
