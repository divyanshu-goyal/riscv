`timescale 1ns/1ps

module branch_unit_tb;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic        branch_enable;
    logic [1:0]  branch_type;

    logic branch_taken;

    branch_unit dut (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch_enable(branch_enable),
        .branch_type(branch_type),
        .branch_taken(branch_taken)
    );

    initial begin

        // BEQ: equal → taken
        rs1_data = 32'd10;
        rs2_data = 32'd10;
        branch_enable = 1'b1;
        branch_type = 2'b00;

        #10;

        if (!branch_taken)
            $fatal("BEQ equal test failed");

        // BEQ: not equal → not taken
        rs2_data = 32'd20;

        #10;

        if (branch_taken)
            $fatal("BEQ not-equal test failed");

        // BNE: not equal → taken
        branch_type = 2'b01;

        #10;

        if (!branch_taken)
            $fatal("BNE not-equal test failed");

        // BNE: equal → not taken
        rs2_data = 32'd10;

        #10;

        if (branch_taken)
            $fatal("BNE equal test failed");

        // Branch disabled
        branch_enable = 1'b0;

        #10;

        if (branch_taken)
            $fatal("Branch disable test failed");

        $display("BRANCH UNIT TEST PASSED");

        $finish;

    end

endmodule
