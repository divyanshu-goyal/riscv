`timescale 1ns/1ps

module if_id_tb;

    logic clk;
    logic rst;
    logic enable;
    logic flush;

    logic [31:0] pc_in;
    logic [31:0] pc4_in;
    logic [31:0] instr_in;

    logic [31:0] pc_out;
    logic [31:0] pc4_out;
    logic [31:0] instr_out;

    if_id dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .flush(flush),
        .pc_in(pc_in),
        .pc4_in(pc4_in),
        .instr_in(instr_in),
        .pc_out(pc_out),
        .pc4_out(pc4_out),
        .instr_out(instr_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        enable = 1;
        flush = 0;

        pc_in = 32'h1000;
        pc4_in = 32'h1004;
        instr_in = 32'h12345678;

        #10;

        if (pc_out != 0 || pc4_out != 0 || instr_out != 0)
            $fatal("RESET TEST FAILED");

        rst = 0;

        #10;

        if (pc_out != 32'h1000 ||
            pc4_out != 32'h1004 ||
            instr_out != 32'h12345678)
            $fatal("LOAD TEST FAILED");

        pc_in = 32'h2000;
        pc4_in = 32'h2004;
        instr_in = 32'hAAAAAAAA;

        enable = 0;

        #10;

        if (pc_out != 32'h1000 ||
            instr_out != 32'h12345678)
            $fatal("ENABLE TEST FAILED");

        enable = 1;
        flush = 1;

        #10;

        if (pc_out != 0 ||
            pc4_out != 0 ||
            instr_out != 0)
            $fatal("FLUSH TEST FAILED");

        $display("IF/ID TEST PASSED");
        $finish;
    end

endmodule
