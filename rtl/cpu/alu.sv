`timescale 1ns/1ps

module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [3:0]  alu_op,
    output logic [31:0] result
);

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;

    always_comb begin
        case (alu_op)

            ALU_ADD:
                result = a + b;

            ALU_SUB:
                result = a - b;

            ALU_AND:
                result = a & b;

            ALU_OR:
                result = a | b;

            ALU_XOR:
                result = a ^ b;

            ALU_SLT:
                result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

            default:
                result = 32'b0;

        endcase
    end

endmodule
