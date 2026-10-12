`timescale 1ns/1ps

module riscv_core_tb;

    logic clk;
    logic rst;

    logic [31:0] debug_x1;
    logic [31:0] debug_x2;
    logic [31:0] debug_x3;

    riscv_core dut (
        .clk(clk),
        .rst(rst),
        .debug_x1(debug_x1),
        .debug_x2(debug_x2),
        .debug_x3(debug_x3)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        // Reset
        #20;
        rst = 1'b0;

        // Let the pipeline execute
        #200;

        $display("================================");
        $display("x1 = %0d", dut.regs.regs[1]);
$display("x2 = %0d", dut.regs.regs[2]);
$display("x3 = %0d", dut.regs.regs[3]);

if ((dut.regs.regs[1] == 32'd5) &&
    (dut.regs.regs[2] == 32'd6) &&
    (dut.regs.regs[3] == 32'd42)) begin
    $display("BNE TAKEN TEST PASSED");
end
else begin
    $display("BNE TAKEN TEST FAILED");
end        $finish;
    end

endmodule
