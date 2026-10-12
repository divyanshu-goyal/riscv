`timescale 1ns/1ps

module imm_gen_tb;

    logic [31:0] instr;
    logic [2:0]  imm_type;
    logic [31:0] imm;

    imm_gen dut (
        .instr(instr),
        .imm_type(imm_type),
        .imm(imm)
    );

    initial begin

        // I-type: immediate = 10
        instr = 32'b0;
        instr[31:20] = 12'd10;
        imm_type = 3'b000;

        #10;

        if (imm != 32'd10)
            $fatal("I-type test failed");

        // I-type negative: immediate = -1
        instr = 32'b0;
        instr[31:20] = 12'hFFF;
        imm_type = 3'b000;

        #10;

        if (imm != 32'hFFFFFFFF)
            $fatal("I-type negative test failed");

        // S-type: immediate = 20
        instr = 32'b0;
        instr[31:25] = 7'd0;
        instr[11:7]  = 5'd20;
        imm_type = 3'b001;

        #10;

        if (imm != 32'd20)
            $fatal("S-type test failed");

        // B-type: offset = 4
        instr = 32'b0;
        instr[11:8] = 4'b0010;
        imm_type = 3'b010;

       #10;

        if (imm != 32'd4)
            $fatal("B-type test failed");

        // J-type: offset = 8
        instr = 32'b0;
        instr[30:21] = 10'b0000000100;
        imm_type = 3'b011;

        #10;

        if (imm != 32'd8)
            $fatal("J-type test failed");

        $display("IMM_GEN TEST PASSED");

        $finish;

    end

endmodule
