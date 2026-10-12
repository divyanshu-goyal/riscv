`timescale 1ns/1ps

module imm_gen (
    input  logic [31:0] instr,
    input  logic [2:0]  imm_type,
    output logic [31:0] imm
);

    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_J = 3'b011;

    always_comb begin
        case (imm_type)

            IMM_I: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end

            IMM_S: begin
                imm = {{20{instr[31]}},
                       instr[31:25],
                       instr[11:7]};
            end

            IMM_B: begin
                imm = {{19{instr[31]}},
                       instr[31],
                       instr[7],
                       instr[30:25],
                       instr[11:8],
                      1'b0};
            end

            IMM_J: begin
                imm = {{11{instr[31]}},
                       instr[31],
                       instr[19:12],
                       instr[20],
                       instr[30:21],
                      1'b0};
            end

            default: begin
                imm = 32'b0;
            end

        endcase
    end

endmodule
