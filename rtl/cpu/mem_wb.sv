`timescale 1ns/1ps

module mem_wb (
    input  logic        clk,
    input  logic        rst,
    input  logic        flush,

    // Data from MEM stage
    input  logic [31:0] alu_result_in,
    input  logic [31:0] mem_data_in,
    input  logic [31:0] pc4_in,

    // Destination register
    input  logic [4:0]  rd_addr_in,

    // Control signals
    input  logic        reg_write_in,
    input  logic [1:0]  wb_sel_in,

    // Outputs
    output logic [31:0] alu_result_out,
    output logic [31:0] mem_data_out,
    output logic [31:0] pc4_out,

    output logic [4:0]  rd_addr_out,

    output logic        reg_write_out,
    output logic [1:0]  wb_sel_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            alu_result_out <= 32'b0;
            mem_data_out   <= 32'b0;
            pc4_out        <= 32'b0;

            rd_addr_out    <= 5'b0;

            reg_write_out  <= 1'b0;
            wb_sel_out     <= 2'b0;
        end
        else if (flush) begin
            alu_result_out <= 32'b0;
            mem_data_out   <= 32'b0;
            pc4_out        <= 32'b0;

            rd_addr_out    <= 5'b0;

            reg_write_out  <= 1'b0;
            wb_sel_out     <= 2'b0;
        end
        else begin
            alu_result_out <= alu_result_in;
            mem_data_out   <= mem_data_in;
            pc4_out        <= pc4_in;

            rd_addr_out    <= rd_addr_in;

            reg_write_out  <= reg_write_in;
            wb_sel_out     <= wb_sel_in;
        end
    end

endmodule
