`timescale 1ns/1ps

module hazard_unit_tb;

    logic [4:0] if_id_rs1;
    logic [4:0] if_id_rs2;

    logic [4:0] id_ex_rd;
    logic        id_ex_mem_read;

    logic        pc_write;
    logic        if_id_write;
    logic        id_ex_flush;

    hazard_unit dut (
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),

        .id_ex_rd(id_ex_rd),
        .id_ex_mem_read(id_ex_mem_read),

        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .id_ex_flush(id_ex_flush)
    );

    initial begin

        // Normal operation
        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;

        id_ex_rd = 5'd5;
        id_ex_mem_read = 0;

        #10;

        if (pc_write != 1 ||
            if_id_write != 1 ||
            id_ex_flush != 0)
            $fatal("NORMAL TEST FAILED");


        // Load-use hazard through rs1
        id_ex_mem_read = 1;
        id_ex_rd = 5'd1;

        #10;

        if (pc_write != 0 ||
            if_id_write != 0 ||
            id_ex_flush != 1)
            $fatal("RS1 HAZARD TEST FAILED");


        // Load-use hazard through rs2
        id_ex_rd = 5'd2;

        #10;

        if (pc_write != 0 ||
            if_id_write != 0 ||
            id_ex_flush != 1)
            $fatal("RS2 HAZARD TEST FAILED");


        // No hazard when destination is x0
        id_ex_rd = 5'd0;

        #10;

        if (pc_write != 1 ||
            if_id_write != 1 ||
            id_ex_flush != 0)
            $fatal("X0 TEST FAILED");


        // No hazard when different registers
        id_ex_rd = 5'd10;
        id_ex_mem_read = 1;

        #10;

        if (pc_write != 1 ||
            if_id_write != 1 ||
            id_ex_flush != 0)
            $fatal("NO HAZARD TEST FAILED");


        $display("HAZARD UNIT TEST PASSED");
        $finish;

    end

endmodule
