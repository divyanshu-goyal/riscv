`timescale 1ns/1ps

module branch_unit (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic        branch_enable,
    input  logic [1:0]  branch_type,

    output logic        branch_taken
);

    localparam BR_BEQ = 2'b00;
    localparam BR_BNE = 2'b01;

    always_comb begin

        branch_taken = 1'b0;

        if (branch_enable) begin

            case (branch_type)

                BR_BEQ:
                    branch_taken = (rs1_data == rs2_data);

                BR_BNE:
                    branch_taken = (rs1_data != rs2_data);

                default:
                    branch_taken = 1'b0;

            endcase

        end

    end

endmodule
