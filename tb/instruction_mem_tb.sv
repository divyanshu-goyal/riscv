`timescale 1ns/1ps

module instruction_mem_tb;

    logic [31:0] addr;
    logic [31:0] instr;

    instruction_mem dut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        addr = 32'h00000000;
        #10;

        if (instr != 32'h00000013)
            $fatal("ADDRESS 0 TEST FAILED");

        addr = 32'h00000004;
        #10;

        if (instr != 32'h00000013)
            $fatal("ADDRESS 4 TEST FAILED");

        addr = 32'h00000008;
        #10;

        if (instr != 32'h00000013)
            $fatal("ADDRESS 8 TEST FAILED");

        $display("INSTRUCTION MEMORY TEST PASSED");
        $finish;
    end

endmodule
