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
    parameter MAXITRS = 2;
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
    reg [32-1:0]op_223x32[223-1:0];
    reg [Kb*HDWIDTH-1:0]unload_17x448[17-1:0];
    
    integer i1;
    integer op_counter;
    initial begin
        op_counter = 0;
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\input_257x32.txt",inp_257x32);
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\input_codeword_17x32x16.txt",inp_17x512);
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\op_223x32.txt",op_223x32);
        $readmemb("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\ne_decoder_verif\\rowcomputer_p26 verification\\scripts\\outputs\\unload_17x448.txt",unload_17x448);
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
    
    /*always@(dut.inputintf.inputfifo.nb_loop[15].submem.WA)begin
        $display("|WA|      %d",dut.inputintf.inputfifo.nb_loop[15].submem.WA);
    end*/
    always@(dut.inputintf.inputfifo.cyclecount)begin
        $display("|CC| %d",dut.inputintf.inputfifo.cyclecount);
        $display("|CCWA|      %d",dut.inputintf.inputfifo.nb_loop[15].submem.WA);
    end
    
    // Displays
    always@(posedge in_clk)begin
        #0.001;
        
        if(counter_in == 259)begin
            code_valid = 0;
        end
        $display("\n\n IN_CLK = %d", counter_in);
        /*
        $display(" start = %b | loaden = %b | inputintf.inputfifo.ps = %b | inputintf.inputfifo.wr_en = %b", dut.start, dut.loaden, dut.inputintf.inputfifo.ps, dut.inputintf.inputfifo.wr_en);
         $display("      dut.cdwrd_in  = %b", dut.Codeword_in);
         $display("      EMEM [12] %d", dut.inputintf.inputfifo.nb_loop[12].submem.WA);
         $display("      EMEM [13] %d", dut.inputintf.inputfifo.nb_loop[13].submem.WA);
         $display("      EMEM [14] %d", dut.inputintf.inputfifo.nb_loop[14].submem.WA);
         $display("      EMEM [15] %d", dut.inputintf.inputfifo.nb_loop[15].submem.WA);
        //$display(" loader.ps = %b ( 1 for counting) ", dut.inputintf.loader.ps);
        //$display(" loader.addr_count = %d( should start coutning to 17 ) ", dut.inputintf.loader.addr_count);*/
    end
    
    integer load_counter ;
    integer check_load;
    integer f;
    reg [1200:0]fn;
    integer i3;
    integer display_op;
    initial begin
        check_load = 0;
    end
    always@(posedge dut.loaden)begin
        display_op = 0;
        load_counter = 0;
        check_load = 1;
        $display(" LOADEN SET");
        /*$display("      dut.load_data = %b", dut.load_data);
        
        $write("%b", dut.inputintf.inputfifo.nb_loop[15].submem.Lmemreg[16]);
        $write("%b", dut.inputintf.inputfifo.nb_loop[14].submem.Lmemreg[16]);
        $write("%b", dut.inputintf.inputfifo.nb_loop[13].submem.Lmemreg[16]);
        $write("\n");*/
    end
    always@(negedge dut.loaden)begin
        $display("LOADEN DISABLED");
        check_load = 0;
    end
    always @(posedge clk)begin
        //$display("\n      CLK = %d , load_en %b, dut.controller.ps %d, ns %d, controller.start %b, dut.start %b", counter, dut.decodecore.loaden, dut.decodecore.controller.ps,dut.decodecore.controller.ps, dut.decodecore.controller.start, dut.start);
        #0.1
        //$display("controller.ps %b, controller.ns %b,  controller.loaden %b, controller.rst %b, controller.clk %b, controller.start", dut.decodecore.controller.ps, dut.decodecore.controller.ns, dut.decodecore.controller.loaden, dut.decodecore.controller.rst, dut.decodecore.controller.clk, dut.decodecore.controller.start);
        if(counter_in == 256)begin
            counter = 0;
        end
        if(check_load && counter_in < 262 )begin
            /*$display("\n      CLK = %d", counter);
            $display("      loader.addr_count = %d( should start coutning to 17 ) ", dut.inputintf.loader.addr_count);
            $display("      loader_counter ", load_counter);
            $display("      dut.load_data = %b", dut.load_data);
            $display("      reference[2]  = %b", inp_17x512[load_counter ]);
            $display("      xor           = %b", inp_17x512[ load_counter ] ^ dut.load_data);*/
            if( inp_17x512[ load_counter ] == dut.load_data)begin
                $display(" MATCH on address count" , load_counter);
            end
            else begin 
                $display(" NO MATCH on address count" , load_counter);
                
                // Write these cases to file for analysis
                if(load_counter < 17)begin
                    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\outputs\\from_tb_load17x32_%0d_ref.txt", load_counter  );
                    f = $fopen(fn ,"w");
                    $fwrite(f,"%b",inp_17x512[ load_counter ]);
                    $fclose(f);
                    
                    $sformat(fn,"C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\lmem_veri_inp-0_1-0_0-1_1_unload\\outputs\\from_tb_load17x32_%0d_op.txt", load_counter  );
                    f = $fopen(fn ,"w");
                    $fwrite(f,"%b",dut.load_data);
                    $fclose(f);
                end
                                 
            end
            //$display("      start = %b | loaden = %b | inputintf.inputfifo.ps = %b | inputintf.inputfifo.wr_en = %b", dut.start, dut.loaden, dut.inputintf.inputfifo.ps, dut.inputintf.inputfifo.wr_en);
            //$display("      loader.ps = %b ( 1 for counting) ", dut.inputintf.loader.ps);
            //$display("[0] RA %b", dut.inputintf.inputfifo.nb_loop[2].submem.RA);
            #0.001;
            load_counter = load_counter + 1;
            

        end
    end
    
    
    
    always @(dut.unload_en, dut.decoder_ready)begin
        $display("decoder_ready = %b, unload_en = %b", dut.decoder_ready, dut.unload_en);
    end

    
    integer i4;
    always @(posedge out_clk)begin
        if(datavalid && op_counter < 223)begin
            
            //$display("%d DATAVALID %b HDOUT %b", $time, datavalid, HD_out);
            if(HD_out == op_223x32[op_counter])begin
                $display("Final 32 bit output SUCCESS on count (%3d/222)",op_counter);
            end
            else begin
                $display("Final 32 bit output FAIL    on count (%3d/222)",op_counter);
                $display("%b\n%b\n%b", op_223x32[op_counter], HD_out, op_223x32[op_counter] ^ HD_out);
                
                for(i4=0; i4 < 16; i4 = i4+1)begin  
                    $display("BRAM 0 Lmemreg %d %b", i4, dut.outintf.outputfifo.kb_loop[0].submem.Lmemreg[i4]);
                end 
                for(i4=0; i4 < 16; i4 = i4+1)begin  
                    $display("BRAM 1 Lmemreg %d %b", i4, dut.outintf.outputfifo.kb_loop[1].submem.Lmemreg[i4]);
                end 
            end
            op_counter = op_counter + 1;
        end
    end
    
    integer check_unload;
    integer check_unload_counter;
    initial begin        check_unload = 0;    check_unload_counter = 0;end
    
    always@(posedge clk)begin
        if(dut.decoder_ready && check_unload == 0)begin
            $display("%d Decoder ready, checking unload out", $time);
            check_unload = 1;
        end
        
        if(check_unload)begin
            #0.1
            //$display("%d UNLOAD OUT %b", dut.unloadAddress, dut.unload_HDout_vec_regout);
            if( check_unload_counter < 18 && check_unload_counter > 0)begin
                if(dut.unload_HDout_vec_regout == unload_17x448[check_unload_counter-1])begin
                    $display("SUCCESS on count %d",check_unload_counter-1);
                    $display("%d BRAM ALL WA %d, wr_en", $time,dut.outintf.WA_regout,dut.outintf.wr_en);
                end
                else begin
                    $display("FAIL on count %d",check_unload_counter-1);
                    
                end
                
            end
            check_unload_counter = check_unload_counter + 1;
        end
    end
    
endmodule
