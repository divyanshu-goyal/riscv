`timescale 1ns/1ps

module forwarding_unit_tb;

    logic [4:0] id_ex_rs1;
    logic [4:0] id_ex_rs2;

    logic [4:0] ex_mem_rd;
    logic        ex_mem_reg_write;

    logic [4:0] mem_wb_rd;
    logic        mem_wb_reg_write;

    logic [1:0] forward_a;
    logic [1:0] forward_b;

    forwarding_unit dut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin

        // No forwarding
        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;

        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 0;

        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 0;

        #10;

        if (forward_a != 2'b00 ||
            forward_b != 2'b00)
            $fatal("NO FORWARD TEST FAILED");


        // EX/MEM → rs1
        ex_mem_rd = 5'd1;
        ex_mem_reg_write = 1;

        #10;

        if (forward_a != 2'b01)
            $fatal("EX FORWARD A TEST FAILED");


        // EX/MEM → rs2
        id_ex_rs2 = 5'd1;

        #10;

        if (forward_b != 2'b01)
            $fatal("EX FORWARD B TEST FAILED");


        // MEM/WB → rs1
        ex_mem_reg_write = 0;
        mem_wb_rd = 5'd1;
        mem_wb_reg_write = 1;

        #10;

        if (forward_a != 2'b10)
            $fatal("WB FORWARD A TEST FAILED");


        // EX/MEM has priority over MEM/WB
        ex_mem_rd = 5'd1;
        ex_mem_reg_write = 1;

        #10;

        if (forward_a != 2'b01)
            $fatal("FORWARD PRIORITY TEST FAILED");


        // x0 must never be forwarded
        id_ex_rs1 = 5'd0;
        ex_mem_rd = 5'd0;
        mem_wb_rd = 5'd0;

        #10;

        if (forward_a != 2'b00)
            $fatal("X0 FORWARD TEST FAILED");


        $display("FORWARDING UNIT TEST PASSED");
        $finish;

    end

endmodule
