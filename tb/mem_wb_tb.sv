`timescale 1ns/1ps

module mem_wb_tb;

    logic clk;
    logic rst;
    logic flush;

    logic [31:0] alu_result_in;
    logic [31:0] mem_data_in;
    logic [31:0] pc4_in;

    logic [4:0] rd_addr_in;

    logic reg_write_in;
    logic [1:0] wb_sel_in;

    logic [31:0] alu_result_out;
    logic [31:0] mem_data_out;
    logic [31:0] pc4_out;

    logic [4:0] rd_addr_out;

    logic reg_write_out;
    logic [1:0] wb_sel_out;

    mem_wb dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),

        .alu_result_in(alu_result_in),
        .mem_data_in(mem_data_in),
        .pc4_in(pc4_in),

        .rd_addr_in(rd_addr_in),

        .reg_write_in(reg_write_in),
        .wb_sel_in(wb_sel_in),

        .alu_result_out(alu_result_out),
        .mem_data_out(mem_data_out),
        .pc4_out(pc4_out),

        .rd_addr_out(rd_addr_out),

        .reg_write_out(reg_write_out),
        .wb_sel_out(wb_sel_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        flush = 0;

        alu_result_in = 32'h1111;
        mem_data_in   = 32'h2222;
        pc4_in        = 32'h1004;

        rd_addr_in = 5'd10;

        reg_write_in = 1;
        wb_sel_in = 2'b01;

        #10;

        if (alu_result_out != 0 ||
            mem_data_out != 0 ||
            reg_write_out != 0)
            $fatal("RESET TEST FAILED");

        rst = 0;

        #10;

        if (alu_result_out != 32'h1111 ||
            mem_data_out != 32'h2222 ||
            pc4_out != 32'h1004 ||
            rd_addr_out != 5'd10 ||
            reg_write_out != 1'b1 ||
            wb_sel_out != 2'b01)
            $fatal("LOAD TEST FAILED");

        flush = 1;

        #10;

        if (reg_write_out != 0)
            $fatal("FLUSH TEST FAILED");

        $display("MEM/WB TEST PASSED");
        $finish;
    end

endmodule
