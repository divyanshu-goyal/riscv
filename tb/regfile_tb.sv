`timescale 1ns/1ps

module regfile_tb;

    logic clk;
    logic rst;

    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;

    logic [4:0] rd_addr;
    logic [31:0] rd_data;
    logic rd_we;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;

    regfile dut (
        .clk(clk),
        .rst(rst),

        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),

        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rd_we(rd_we),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

       rs1_addr = 0;
        rs2_addr = 0;
        rd_addr  = 0;
        rd_data  = 0;
        rd_we    = 0;

        #20;
        rst = 0;

        // Write x5 = 123
        rd_addr = 5;
        rd_data = 32'd123;
        rd_we   = 1;

        #10;

        rd_we = 0;

        rs1_addr = 5;

        #10;

        if (rs1_data != 32'd123)
            $fatal("Write/Read test failed");

        // Attempt write to x0
        rd_addr = 0;
        rd_data = 32'hFFFFFFFF;
        rd_we   = 1;

        #10;

        rd_we = 0;

        rs1_addr = 0;
	#10;

        if (rs1_data != 32'd0)
            $fatal("x0 protection failed");

        $display("REGFILE TEST PASSED");
        $finish;

    end

endmodule
