
`timescale 1ns/1ps

module regfile (
    input  logic        clk,
    input  logic        rst,

    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,

    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data,
    input  logic        rd_we,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] regs [31:0];

    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else begin
            if (rd_we && (rd_addr != 5'd0))
                regs[rd_addr] <= rd_data;
        end
    end

    assign rs1_data =
    (rs1_addr == 5'd0) ? 32'd0 :
    (rd_we && (rd_addr == rs1_addr) && (rd_addr != 5'd0)) ?
        rd_data :
        regs[rs1_addr];

assign rs2_data =
    (rs2_addr == 5'd0) ? 32'd0 :
    (rd_we && (rd_addr == rs2_addr) && (rd_addr != 5'd0)) ?
        rd_data :
        regs[rs2_addr];
endmodule
