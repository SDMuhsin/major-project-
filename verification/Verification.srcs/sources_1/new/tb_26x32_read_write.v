`timescale 1ns / 1ps

module tb_26x32_read_write();

parameter Wc = 32;
parameter W = 6;
parameter blocks = 16;
parameter P = 26;

reg L_in[Wc*P*W - 1:0];
reg E_in[Wc*P*W - 1:0];
reg D_in[Wc*P*W - 1:0];

initial begin
    $readmemh("C:\\Users\\sayed\\Desktop\\Programing\\major project\\major-project-\\verification\\scripts\\ne_decoderRTL_verif\\outputs\\Lwclist_itr1_lyr1_slice1.txt",L_in);
end
endmodule
