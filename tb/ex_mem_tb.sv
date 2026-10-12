`timescale 1ns/1ps

module ex_mem_tb;

    logic clk;
    logic rst;
    logic flush;

    logic [31:0] alu_result_in;
    logic [31:0] rs2_data_in;
    logic [31:0] pc4_in;

    logic branch_taken_in;
    logic [31:0] branch_target_in;

    logic [4:0] rd_addr_in;

    logic reg_write_in;
    logic mem_read_in;
    logic mem_write_in;
    logic [1:0] wb_sel_in;

    logic [31:0] alu_result_out;
    logic [31:0] rs2_data_out;
    logic [31:0] pc4_out;

    logic branch_taken_out;
    logic [31:0] branch_target_out;

    logic [4:0] rd_addr_out;

    logic reg_write_out;
    logic mem_read_out;
    logic mem_write_out;
    logic [1:0] wb_sel_out;

    ex_mem dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),

        .alu_result_in(alu_result_in),
        .rs2_data_in(rs2_data_in),
        .pc4_in(pc4_in),

        .branch_taken_in(branch_taken_in),
        .branch_target_in(branch_target_in),

        .rd_addr_in(rd_addr_in),

        .reg_write_in(reg_write_in),
        .mem_read_in(mem_read_in),
        .mem_write_in(mem_write_in),
        .wb_sel_in(wb_sel_in),

        .alu_result_out(alu_result_out),
        .rs2_data_out(rs2_data_out),
        .pc4_out(pc4_out),

        .branch_taken_out(branch_taken_out),
        .branch_target_out(branch_target_out),

        .rd_addr_out(rd_addr_out),

        .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .wb_sel_out(wb_sel_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        flush = 0;

        alu_result_in = 32'h1234;
        rs2_data_in = 32'h5678;
        pc4_in = 32'h1004;

        branch_taken_in = 1;
        branch_target_in = 32'h2000;

        rd_addr_in = 5'd7;

        reg_write_in = 1;
        mem_read_in = 0;
        mem_write_in = 0;
        wb_sel_in = 2'b00;

        #10;

        if (alu_result_out != 0 ||
            reg_write_out != 0)
            $fatal("RESET TEST FAILED");

        rst = 0;

        #10;

        if (alu_result_out != 32'h1234 ||
            rs2_data_out != 32'h5678 ||
            pc4_out != 32'h1004 ||
            branch_taken_out != 1'b1 ||
            branch_target_out != 32'h2000 ||
            rd_addr_out != 5'd7 ||
            reg_write_out != 1'b1)
            $fatal("LOAD TEST FAILED");

        flush = 1;

        #10;

        if (reg_write_out != 0 ||
            mem_read_out != 0 ||
            mem_write_out != 0 ||
            branch_taken_out != 0)
            $fatal("FLUSH TEST FAILED");

        $display("EX/MEM TEST PASSED");
        $finish;
    end

endmodule
