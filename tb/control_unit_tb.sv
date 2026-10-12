`timescale 1ns/1ps

module control_unit_tb;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic alu_src;
    logic branch;
    logic [1:0] branch_type;
    logic jump;

    logic [2:0] imm_type;
    logic [3:0] alu_op;
    logic [1:0] wb_sel;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .branch(branch),
	.branch_type(branch_type),
        .jump(jump),

        .imm_type(imm_type),
        .alu_op(alu_op),
        .wb_sel(wb_sel)
    );

    initial begin

        // ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        if (!reg_write || alu_op != 4'b0000)
            $fatal("ADD decode failed");

        // SUB
        funct7 = 7'b0100000;

        #10;

        if (!reg_write || alu_op != 4'b0001)
            $fatal("SUB decode failed");

        // ADDI
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;

        #10;

        if (!reg_write || !alu_src || alu_op != 4'b0000)
            $fatal("ADDI decode failed");

        // LW
        opcode = 7'b0000011;
        funct3 = 3'b010;

        #10;

        if (!reg_write || !mem_read || !alu_src ||
            wb_sel != 2'b01)
            $fatal("LW decode failed");

        // SW
        opcode = 7'b0100011;
        funct3 = 3'b010;

        #10;

        if (!mem_write || !alu_src ||
            imm_type != 3'b001)
            $fatal("SW decode failed");

        // BEQ
        opcode = 7'b1100011;
        funct3 = 3'b000;

        #10;

        if (!branch || imm_type != 3'b010)
            $fatal("BEQ decode failed");

        // JAL
        opcode = 7'b1101111;

        #10;

        if (!jump || !reg_write ||
            wb_sel != 2'b10)
            $fatal("JAL decode failed");

        $display("CONTROL UNIT TEST PASSED");

        $finish;

    end

endmodule
