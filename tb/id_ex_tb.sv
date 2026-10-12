`timescale 1ns/1ps

module id_ex_tb;

    logic clk;
    logic rst;
    logic flush;

    logic [31:0] pc_in, pc4_in;
    logic [31:0] rs1_data_in, rs2_data_in, imm_in;

    logic [4:0] rs1_addr_in, rs2_addr_in, rd_addr_in;

    logic reg_write_in;
    logic mem_read_in;
    logic mem_write_in;
    logic alu_src_in;
    logic branch_in;
    logic jump_in;

    logic [3:0] alu_op_in;
    logic [1:0] wb_sel_in;
    logic [1:0] branch_type_in;

    logic [31:0] pc_out, pc4_out;
    logic [31:0] rs1_data_out, rs2_data_out, imm_out;

    logic [4:0] rs1_addr_out, rs2_addr_out, rd_addr_out;

    logic reg_write_out;
    logic mem_read_out;
    logic mem_write_out;
    logic alu_src_out;
    logic branch_out;
    logic jump_out;

    logic [3:0] alu_op_out;
    logic [1:0] wb_sel_out;
    logic [1:0] branch_type_out;

    id_ex dut (
        .clk(clk),
        .rst(rst),
        .flush(flush),

        .pc_in(pc_in),
        .pc4_in(pc4_in),
        .rs1_data_in(rs1_data_in),
        .rs2_data_in(rs2_data_in),
        .imm_in(imm_in),

        .rs1_addr_in(rs1_addr_in),
        .rs2_addr_in(rs2_addr_in),
        .rd_addr_in(rd_addr_in),

        .reg_write_in(reg_write_in),
        .mem_read_in(mem_read_in),
        .mem_write_in(mem_write_in),
        .alu_src_in(alu_src_in),
        .branch_in(branch_in),
        .jump_in(jump_in),

        .alu_op_in(alu_op_in),
        .wb_sel_in(wb_sel_in),
        .branch_type_in(branch_type_in),

        .pc_out(pc_out),
        .pc4_out(pc4_out),
        .rs1_data_out(rs1_data_out),
        .rs2_data_out(rs2_data_out),
        .imm_out(imm_out),

        .rs1_addr_out(rs1_addr_out),
        .rs2_addr_out(rs2_addr_out),
        .rd_addr_out(rd_addr_out),

        .reg_write_out(reg_write_out),
        .mem_read_out(mem_read_out),
        .mem_write_out(mem_write_out),
        .alu_src_out(alu_src_out),
        .branch_out(branch_out),
        .jump_out(jump_out),

        .alu_op_out(alu_op_out),
        .wb_sel_out(wb_sel_out),
        .branch_type_out(branch_type_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        flush = 0;

        pc_in = 32'h1000;
        pc4_in = 32'h1004;
        rs1_data_in = 32'h10;
        rs2_data_in = 32'h20;
        imm_in = 32'h30;

        rs1_addr_in = 5'd1;
        rs2_addr_in = 5'd2;
        rd_addr_in = 5'd5;

        reg_write_in = 1;
        mem_read_in = 0;
        mem_write_in = 0;
        alu_src_in = 1;
        branch_in = 0;
        jump_in = 0;

        alu_op_in = 4'b0000;
        wb_sel_in = 2'b00;
        branch_type_in = 2'b00;

        #10;

        if (pc_out != 0 || reg_write_out != 0)
            $fatal("RESET TEST FAILED");

        rst = 0;

        #10;

        if (pc_out != 32'h1000 ||
            rs1_data_out != 32'h10 ||
            rs2_data_out != 32'h20 ||
            imm_out != 32'h30 ||
            rd_addr_out != 5'd5 ||
            reg_write_out != 1'b1)
            $fatal("DATA/control LOAD TEST FAILED");

        flush = 1;

        #10;

        if (reg_write_out != 0 ||
            mem_read_out != 0 ||
            mem_write_out != 0 ||
            branch_out != 0 ||
            jump_out != 0)
            $fatal("FLUSH TEST FAILED");

        $display("ID/EX TEST PASSED");
        $finish;
    end

endmodule
