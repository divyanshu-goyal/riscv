`timescale 1ns/1ps

module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       alu_src,
    output logic       branch,
    output logic       jump,
    output logic [1:0] branch_type,

    output logic [2:0] imm_type,
    output logic [3:0] alu_op,
    output logic [1:0] wb_sel
);

    // Opcodes
    localparam OP_RTYPE = 7'b0110011;
    localparam OP_ITYPE = 7'b0010011;
    localparam OP_LOAD  = 7'b0000011;
    localparam OP_STORE = 7'b0100011;
    localparam OP_BRANCH = 7'b1100011;
    localparam OP_JAL   = 7'b1101111;

    // Immediate types
    localparam IMM_I = 3'b000;
    localparam IMM_S = 3'b001;
    localparam IMM_B = 3'b010;
    localparam IMM_J = 3'b011;

    // ALU operations
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;

    // Write-back selection
    localparam WB_ALU = 2'b00;
    localparam WB_MEM = 2'b01;
    localparam WB_PC4 = 2'b10;
    localparam BR_BEQ = 2'b00;
    localparam BR_BNE = 2'b01;

    always_comb begin

        // Safe defaults
        reg_write = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        alu_src   = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;

        imm_type  = IMM_I;
        alu_op    = ALU_ADD;
        wb_sel    = WB_ALU;
	branch_type = BR_BEQ;

        case (opcode)

            // R-type
            OP_RTYPE: begin
                reg_write = 1'b1;

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_op = ALU_SUB;
                        else
                            alu_op = ALU_ADD;
                    end

                    3'b111: alu_op = ALU_AND;
                    3'b110: alu_op = ALU_OR;
                    3'b100: alu_op = ALU_XOR;
                    3'b010: alu_op = ALU_SLT;

                    default: begin
                        reg_write = 1'b0;
                        alu_op = ALU_ADD;
                    end

                endcase
            end

            // I-type arithmetic
            OP_ITYPE: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_I;

                case (funct3)
                    3'b000: alu_op = ALU_ADD;
                    3'b111: alu_op = ALU_AND;
                    3'b110: alu_op = ALU_OR;
                    3'b100: alu_op = ALU_XOR;

                    default: begin
                        reg_write = 1'b0;
                        alu_op = ALU_ADD;
                    end
                endcase
            end

            // Load
            OP_LOAD: begin
                reg_write = 1'b1;
                mem_read  = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_I;
                alu_op    = ALU_ADD;
                wb_sel    = WB_MEM;
            end

            // Store
            OP_STORE: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                imm_type  = IMM_S;
                alu_op    = ALU_ADD;
            end

            // Branch
            OP_BRANCH: begin
                branch   = 1'b1;
                imm_type = IMM_B;
                alu_op   = ALU_SUB;

    		case (funct3)
        	        3'b000: branch_type = BR_BEQ;
                        3'b001: branch_type = BR_BNE;

        	default: begin
            		branch = 1'b0;
        		end
    		endcase
	    end
            // JAL
            OP_JAL: begin
                jump      = 1'b1;
                reg_write = 1'b1;
                imm_type  = IMM_J;
                wb_sel    = WB_PC4;
            end

            default: begin
                // Keep safe defaults
            end

        endcase

    end

endmodule
