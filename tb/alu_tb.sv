`timescale 1ns/1ps

module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_op;
    logic [31:0] result;

    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result)
    );

    initial begin

        // ADD
        a = 10;
        b = 5;
        alu_op = 4'b0000;
        #10;

        if (result != 15)
            $fatal("ADD failed");

        // SUB
        a = 10;
        b = 5;
        alu_op = 4'b0001;
        #10;

        if (result != 5)
            $fatal("SUB failed");

        // AND
        a = 32'hF0F0;
        b = 32'h0FF0;
        alu_op = 4'b0010;
        #10;

        if (result != 32'h00F0)
            $fatal("AND failed");

        // OR
        a = 32'hF000;
        b = 32'h000F;
        alu_op = 4'b0011;
        #10;

        if (result != 32'hF00F)
            $fatal("OR failed");

        // XOR
        a = 32'hFF00;
        b = 32'h0F0F;
        alu_op = 4'b0100;
        #10;

        if (result != 32'hF00F)
            $fatal("XOR failed");

        // SLT
        a = 32'hFFFFFFFF; // -1
        b = 32'd1;
        alu_op = 4'b0101;
        #10;

        if (result != 32'd1)
            $fatal("SLT failed");

        $display("ALU TEST PASSED");

        $finish;

    end

endmodule
