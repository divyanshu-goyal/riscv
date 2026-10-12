`timescale 1ns/1ps

module riscv_core (
    input logic clk,
    input logic rst,
    output logic [31:0] debug_x1,
    output logic [31:0] debug_x2,
    output logic [31:0] debug_x3
);
    



// ============================================================
// MEM stage
// ============================================================

logic [31:0] mem_read_data;


// ============================================================
// MEM/WB pipeline
// ============================================================

logic [31:0] mem_wb_alu_result;
logic [31:0] mem_wb_mem_data;
logic [31:0] mem_wb_pc4;

logic [4:0]  mem_wb_rd;

logic        mem_wb_reg_write;
logic [1:0]  mem_wb_wb_sel;




// ============================================================
// Hazard detection
// ============================================================

logic pc_write;
logic if_id_write;
logic id_ex_flush;


// ============================================================
// Pipeline control
// ============================================================

logic pc_enable;
logic id_ex_flush_combined;

    // =========================
// EX/MEM pipeline signals
// =========================

logic [31:0] ex_mem_alu_result;
logic [31:0] ex_mem_rs2_data;
logic [31:0] ex_mem_pc4;

logic        ex_mem_branch_taken;
logic [31:0] ex_mem_branch_target;

logic [4:0]  ex_mem_rd;

logic        ex_mem_reg_write;
logic        ex_mem_mem_read;
logic        ex_mem_mem_write;

logic [1:0]  ex_mem_wb_sel;
    
    // =========================================================
    // PC
    // =========================================================

    logic [31:0] pc;
    logic [31:0] next_pc;
    logic [31:0] pc4;
    assign pc_enable = ex_taken ? 1'b1 : pc_write;;

    assign pc4 = pc + 32'd4;

    pc pc_unit (
        .clk(clk),
        .rst(rst),
        .enable(pc_enable),
        .next_pc(next_pc),
        .pc_out(pc)
    );

    always_comb begin
    if (ex_taken)
        next_pc = ex_target;
    else
        next_pc = pc4;
end


    // =========================================================
    // Instruction Memory
    // =========================================================

    logic [31:0] instruction;

    instruction_mem imem (
        .addr(pc),
        .instr(instruction)
    );


    // =========================================================
    // IF / ID Pipeline Register
    // =========================================================

    logic [31:0] if_id_pc;
    logic [31:0] if_id_pc4;
    logic [31:0] if_id_instr;

    if_id if_id_reg (
        .clk(clk),
        .rst(rst),

        .enable(if_id_write),
        .flush(ex_taken),

        .pc_in(pc),
        .pc4_in(pc4),
        .instr_in(instruction),

        .pc_out(if_id_pc),
        .pc4_out(if_id_pc4),
        .instr_out(if_id_instr)
    );


    // =========================================================
    // Instruction Decode
    // =========================================================

    logic [6:0] opcode;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = if_id_instr[6:0];
    assign rd     = if_id_instr[11:7];
    assign funct3 = if_id_instr[14:12];
    assign rs1    = if_id_instr[19:15];
    assign rs2    = if_id_instr[24:20];
    assign funct7 = if_id_instr[31:25];


    // =========================================================
    // Register File
    // =========================================================

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    // WB is not connected yet
    logic [31:0] wb_data;

    regfile regs (
        .clk(clk),
        .rst(rst),

        .rs1_addr(rs1),
        .rs2_addr(rs2),

        .rd_addr(mem_wb_rd),
        .rd_data(wb_data),
        .rd_we(mem_wb_reg_write),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    


    // =========================================================
    // Control Unit
    // =========================================================

    logic       reg_write;
    logic       mem_read;
    logic       mem_write;
    logic       alu_src;
    logic       branch;
    logic       jump;

    logic [2:0] imm_type;
    logic [3:0] alu_op;
    logic [1:0] wb_sel;
    logic [1:0] branch_type;

    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),

        .imm_type(imm_type),
        .alu_op(alu_op),
        .wb_sel(wb_sel),
        .branch_type(branch_type)
    );


    // =========================================================
    // Immediate Generator
    // =========================================================

    logic [31:0] immediate;

    imm_gen imm_generator (
        .instr(if_id_instr),
        .imm_type(imm_type),
        .imm(immediate)
    );


    // =========================================================
    // ID / EX Pipeline Register
    // =========================================================

    logic [31:0] id_ex_pc;
    logic [31:0] id_ex_pc4;
    logic [31:0] id_ex_rs1_data;
    logic [31:0] id_ex_rs2_data;
    logic [31:0] id_ex_imm;

    logic [4:0] id_ex_rs1;
    logic [4:0] id_ex_rs2;
    logic [4:0] id_ex_rd;

    logic       id_ex_reg_write;
    logic       id_ex_mem_read;
    logic       id_ex_mem_write;
    logic       id_ex_alu_src;
    logic       id_ex_branch;
    logic       id_ex_jump;

    logic [3:0] id_ex_alu_op;
    logic [1:0] id_ex_wb_sel;
    logic [1:0] id_ex_branch_type;
    assign id_ex_flush_combined = id_ex_flush | ex_taken;
    id_ex id_ex_reg (
        .clk(clk),
        .rst(rst),
        .flush(id_ex_flush_combined),

        .pc_in(if_id_pc),
        .pc4_in(if_id_pc4),
        .rs1_data_in(rs1_data),
        .rs2_data_in(rs2_data),
        .imm_in(immediate),

        .rs1_addr_in(rs1),
        .rs2_addr_in(rs2),
        .rd_addr_in(rd),

        .reg_write_in(reg_write),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .alu_src_in(alu_src),
        .branch_in(branch),
        .jump_in(jump),

        .alu_op_in(alu_op),
        .wb_sel_in(wb_sel),
        .branch_type_in(branch_type),

        .pc_out(id_ex_pc),
        .pc4_out(id_ex_pc4),
        .rs1_data_out(id_ex_rs1_data),
        .rs2_data_out(id_ex_rs2_data),
        .imm_out(id_ex_imm),

        .rs1_addr_out(id_ex_rs1),
        .rs2_addr_out(id_ex_rs2),
        .rd_addr_out(id_ex_rd),

        .reg_write_out(id_ex_reg_write),
        .mem_read_out(id_ex_mem_read),
        .mem_write_out(id_ex_mem_write),
        .alu_src_out(id_ex_alu_src),
        .branch_out(id_ex_branch),
        .jump_out(id_ex_jump),

        .alu_op_out(id_ex_alu_op),
        .wb_sel_out(id_ex_wb_sel),
        .branch_type_out(id_ex_branch_type)
    );
    // =========================================================
    // EX STAGE
    // =========================================================

    // ---------------------------------------------------------
    // Forwarding Unit
    // ---------------------------------------------------------

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    forwarding_unit forwarding (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );


    // ---------------------------------------------------------
    // Forwarded operands
    // ---------------------------------------------------------

    logic [31:0] forwarded_a;
    logic [31:0] forwarded_b;

    always_comb begin

        case (forward_a)
            2'b00:
                forwarded_a = id_ex_rs1_data;

            2'b01:
                forwarded_a = ex_mem_alu_result;

            2'b10:
                forwarded_a = wb_data;

            default:
                forwarded_a = id_ex_rs1_data;
        endcase

        case (forward_b)
            2'b00:
                forwarded_b = id_ex_rs2_data;

            2'b01:
                forwarded_b = ex_mem_alu_result;

            2'b10:
                forwarded_b = wb_data;

            default:
                forwarded_b = id_ex_rs2_data;
        endcase

    end


    // ---------------------------------------------------------
    // ALU operand B selection
    // ---------------------------------------------------------

    logic [31:0] alu_b;

    assign alu_b =
        id_ex_alu_src ? id_ex_imm : forwarded_b;


    // ---------------------------------------------------------
    // ALU
    // ---------------------------------------------------------

    logic [31:0] alu_result;

    alu alu_unit (
        .a(forwarded_a),
        .b(alu_b),
        .alu_op(id_ex_alu_op),
        .result(alu_result)
    );


    // ---------------------------------------------------------
    // Branch Unit
    // ---------------------------------------------------------

    logic branch_taken;

    branch_unit branch_unit_inst (
        .rs1_data(forwarded_a),
        .rs2_data(forwarded_b),

        .branch_enable(id_ex_branch),
        .branch_type(id_ex_branch_type),

        .branch_taken(branch_taken)
    );


    // ---------------------------------------------------------
    // Branch / Jump target
    // ---------------------------------------------------------

    logic [31:0] branch_target;

    assign branch_target =
        id_ex_pc + id_ex_imm;


    // JAL is always taken
    logic ex_taken;

    assign ex_taken =
        id_ex_jump | branch_taken;


    // Target address
    logic [31:0] ex_target;

    assign ex_target = branch_target;
//ex_mem_reg
    
    ex_mem ex_mem_reg (
    .clk(clk),
    .rst(rst),
    .flush(1'b0),

    .alu_result_in(alu_result),
    .rs2_data_in(forwarded_b),
    .pc4_in(id_ex_pc4),

    .branch_taken_in(ex_taken),
    .branch_target_in(ex_target),

    .rd_addr_in(id_ex_rd),

    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .wb_sel_in(id_ex_wb_sel),

    .alu_result_out(ex_mem_alu_result),
    .rs2_data_out(ex_mem_rs2_data),
    .pc4_out(ex_mem_pc4),

    .branch_taken_out(ex_mem_branch_taken),
    .branch_target_out(ex_mem_branch_target),

    .rd_addr_out(ex_mem_rd),

    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .wb_sel_out(ex_mem_wb_sel)
);
//data mem
    data_mem data_memory (
    .clk(clk),
    .rst(rst),

    .addr(ex_mem_alu_result),
    .write_data(ex_mem_rs2_data),

    .mem_read(ex_mem_mem_read),
    .mem_write(ex_mem_mem_write),

    .read_data(mem_read_data)
);
//mem_wb reg
   mem_wb mem_wb_reg (
    .clk(clk),
    .rst(rst),
    .flush(1'b0),

    .alu_result_in(ex_mem_alu_result),
    .mem_data_in(mem_read_data),
    .pc4_in(ex_mem_pc4),

    .rd_addr_in(ex_mem_rd),

    .reg_write_in(ex_mem_reg_write),
    .wb_sel_in(ex_mem_wb_sel),

    .alu_result_out(mem_wb_alu_result),
    .mem_data_out(mem_wb_mem_data),
    .pc4_out(mem_wb_pc4),

    .rd_addr_out(mem_wb_rd),

    .reg_write_out(mem_wb_reg_write),
    .wb_sel_out(mem_wb_wb_sel)
);
//wb
   always_comb begin
    case (mem_wb_wb_sel)
        2'b00: wb_data = mem_wb_alu_result;
        2'b01: wb_data = mem_wb_mem_data;
        2'b10: wb_data = mem_wb_pc4;
        default: wb_data = 32'b0;
    endcase
end
//hazard unit
   hazard_unit hazard (
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),

    .id_ex_rd(id_ex_rd),
    .id_ex_mem_read(id_ex_mem_read),

    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .id_ex_flush(id_ex_flush)
);
assign debug_x1 = regs.regs[1];
assign debug_x2 = regs.regs[2];
assign debug_x3 = regs.regs[3];
endmodule
