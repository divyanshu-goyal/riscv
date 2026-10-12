`timescale 1ns/1ps

module pc_tb;

    logic clk;
    logic rst;
    logic enable;

    logic [31:0] next_pc;
    logic [31:0] pc_out;

    pc dut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        enable = 1;
        next_pc = 32'h1000;

        #10;

        if (pc_out != 32'b0)
            $fatal("RESET TEST FAILED");

        rst = 0;

        #10;

        if (pc_out != 32'h1000)
            $fatal("PC LOAD TEST FAILED");

        next_pc = 32'h1004;

        #10;

        if (pc_out != 32'h1004)
            $fatal("PC UPDATE TEST FAILED");

        enable = 0;
        next_pc = 32'h2000;

        #10;

        if (pc_out != 32'h1004)
            $fatal("PC ENABLE TEST FAILED");

        $display("PC TEST PASSED");
        $finish;
    end

endmodule
