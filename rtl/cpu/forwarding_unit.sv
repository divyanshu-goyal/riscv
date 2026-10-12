`timescale 1ns/1ps

module forwarding_unit (
    input  logic [4:0] id_ex_rs1,
    input  logic [4:0] id_ex_rs2,

    input  logic [4:0] ex_mem_rd,
    input  logic        ex_mem_reg_write,

    input  logic [4:0] mem_wb_rd,
    input  logic        mem_wb_reg_write,

    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    localparam FWD_REG = 2'b00;
    localparam FWD_EX  = 2'b01;
    localparam FWD_WB  = 2'b10;

    always_comb begin

        forward_a = FWD_REG;
        forward_b = FWD_REG;

        // Forward to ALU input A
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs1)) begin

            forward_a = FWD_EX;
        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) &&
                 (mem_wb_rd == id_ex_rs1)) begin

            forward_a = FWD_WB;
        end

        // Forward to ALU input B
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs2)) begin

            forward_b = FWD_EX;
        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) &&
                 (mem_wb_rd == id_ex_rs2)) begin

            forward_b = FWD_WB;
        end

    end

endmodule
