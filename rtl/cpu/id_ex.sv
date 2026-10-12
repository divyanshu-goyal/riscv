`timescale 1ns/1ps

module id_ex (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,

    // Data
    input  logic [31:0] pc_in,
    input  logic [31:0] pc4_in,
    input  logic [31:0] rs1_data_in,
    input  logic [31:0] rs2_data_in,
    input  logic [31:0] imm_in,

    // Register addresses
    input  logic [4:0]  rs1_addr_in,
    input  logic [4:0]  rs2_addr_in,
    input  logic [4:0]  rd_addr_in,

    // Control signals
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic        alu_src_in,
    input  logic        branch_in,
    input  logic        jump_in,

    input  logic [3:0]  alu_op_in,
    input  logic [1:0]  wb_sel_in,
    input  logic [1:0]  branch_type_in,

    // Outputs
    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] rs1_data_out,
    output logic [31:0] rs2_data_out,
    output logic [31:0] imm_out,

    output logic [4:0]  rs1_addr_out,
    output logic [4:0]  rs2_addr_out,
    output logic [4:0]  rd_addr_out,

    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic        alu_src_out,
    output logic        branch_out,
    output logic        jump_out,

    output logic [3:0]  alu_op_out,
    output logic [1:0]  wb_sel_out,
    output logic [1:0]  branch_type_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            pc_out         <= 32'b0;
            pc4_out        <= 32'b0;
            rs1_data_out   <= 32'b0;
            rs2_data_out   <= 32'b0;
            imm_out        <= 32'b0;

            rs1_addr_out   <= 5'b0;
            rs2_addr_out   <= 5'b0;
            rd_addr_out    <= 5'b0;

            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            alu_src_out    <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;

            alu_op_out     <= 4'b0;
            wb_sel_out     <= 2'b0;
            branch_type_out <= 2'b0;
        end
        else if (flush) begin
            // Insert bubble
            pc_out         <= 32'b0;
            pc4_out        <= 32'b0;
            rs1_data_out   <= 32'b0;
            rs2_data_out   <= 32'b0;
            imm_out        <= 32'b0;

            rs1_addr_out   <= 5'b0;
            rs2_addr_out   <= 5'b0;
            rd_addr_out    <= 5'b0;

            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            alu_src_out    <= 1'b0;
            branch_out     <= 1'b0;
            jump_out       <= 1'b0;

            alu_op_out     <= 4'b0;
            wb_sel_out     <= 2'b0;
            branch_type_out <= 2'b0;
        end
        else begin
            pc_out         <= pc_in;
            pc4_out        <= pc4_in;
            rs1_data_out   <= rs1_data_in;
            rs2_data_out   <= rs2_data_in;
            imm_out        <= imm_in;

            rs1_addr_out   <= rs1_addr_in;
            rs2_addr_out   <= rs2_addr_in;
            rd_addr_out    <= rd_addr_in;

            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
            alu_src_out    <= alu_src_in;
            branch_out     <= branch_in;
            jump_out       <= jump_in;

            alu_op_out     <= alu_op_in;
            wb_sel_out     <= wb_sel_in;
            branch_type_out <= branch_type_in;
        end
    end

endmodule
