`timescale 1ns/1ps

module ex_mem (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,

    // Data from EX stage
    input  logic [31:0] alu_result_in,
    input  logic [31:0] rs2_data_in,
    input  logic [31:0] pc4_in,

    // Branch information
    input  logic        branch_taken_in,
    input  logic [31:0] branch_target_in,

    // Destination register
    input  logic [4:0]  rd_addr_in,

    // Control signals
    input  logic        reg_write_in,
    input  logic        mem_read_in,
    input  logic        mem_write_in,
    input  logic [1:0]  wb_sel_in,

    // Outputs
    output logic [31:0] alu_result_out,
    output logic [31:0] rs2_data_out,
    output logic [31:0] pc4_out,

    output logic        branch_taken_out,
    output logic [31:0] branch_target_out,

    output logic [4:0]  rd_addr_out,

    output logic        reg_write_out,
    output logic        mem_read_out,
    output logic        mem_write_out,
    output logic [1:0]  wb_sel_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            alu_result_out   <= 32'b0;
            rs2_data_out     <= 32'b0;
            pc4_out          <= 32'b0;

            branch_taken_out <= 1'b0;
            branch_target_out <= 32'b0;

            rd_addr_out      <= 5'b0;

            reg_write_out    <= 1'b0;
            mem_read_out     <= 1'b0;
            mem_write_out    <= 1'b0;
            wb_sel_out       <= 2'b0;
        end
        else if (flush) begin
            alu_result_out   <= 32'b0;
            rs2_data_out     <= 32'b0;
            pc4_out          <= 32'b0;

            branch_taken_out <= 1'b0;
            branch_target_out <= 32'b0;

            rd_addr_out      <= 5'b0;

            reg_write_out    <= 1'b0;
            mem_read_out     <= 1'b0;
            mem_write_out    <= 1'b0;
            wb_sel_out       <= 2'b0;
        end
        else begin
            alu_result_out   <= alu_result_in;
            rs2_data_out     <= rs2_data_in;
            pc4_out          <= pc4_in;

            branch_taken_out <= branch_taken_in;
            branch_target_out <= branch_target_in;

            rd_addr_out      <= rd_addr_in;

            reg_write_out    <= reg_write_in;
            mem_read_out     <= mem_read_in;
            mem_write_out    <= mem_write_in;
            wb_sel_out       <= wb_sel_in;
        end
    end

endmodule
