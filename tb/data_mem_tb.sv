`timescale 1ns/1ps

module data_mem_tb;

    logic clk;
    logic rst;

    logic [31:0] addr;
    logic [31:0] write_data;

    logic mem_read;
    logic mem_write;

    logic [31:0] read_data;

    data_mem dut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        addr = 32'h00000000;
        write_data = 32'h0;
        mem_read = 0;
        mem_write = 0;

        #10;

        rst = 0;

        // Write 0x12345678 to address 0x100
        addr = 32'h00000100;
        write_data = 32'h12345678;
        mem_write = 1;

        #10;

        mem_write = 0;
        mem_read = 1;

        #1;

        if (read_data != 32'h12345678)
            $fatal("WRITE/READ TEST FAILED");

        // Test another location
        addr = 32'h00000104;
        write_data = 32'hAABBCCDD;
        mem_read = 0;
        mem_write = 1;

        #10;

        mem_write = 0;
        mem_read = 1;

        #1;

        if (read_data != 32'hAABBCCDD)
            $fatal("SECOND MEMORY TEST FAILED");

        $display("DATA MEMORY TEST PASSED");
        $finish;
    end

endmodule
