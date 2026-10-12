`timescale 1ns/1ps

module if_id (
    input  logic        clk,
    input  logic        rst,

    input  logic        enable,
    input  logic        flush,

    input  logic [31:0] pc_in,
    input  logic [31:0] pc4_in,
    input  logic [31:0] instr_in,

    output logic [31:0] pc_out,
    output logic [31:0] pc4_out,
    output logic [31:0] instr_out
);

    always_ff @(posedge clk) begin
        if (rst) begin
            pc_out    <= 32'b0;
            pc4_out   <= 32'b0;
            instr_out <= 32'b0;
        end
        else if (flush) begin
            pc_out    <= 32'b0;
            pc4_out   <= 32'b0;
            instr_out <= 32'b0;
        end
        else if (enable) begin
            pc_out    <= pc_in;
            pc4_out   <= pc4_in;
            instr_out <= instr_in;
        end
    end

endmodule
