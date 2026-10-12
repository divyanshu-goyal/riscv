`timescale 1ns/1ps

module instruction_mem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] mem [0:255];

    always_comb begin
        instr = mem[addr[9:2]];
    end

    initial begin
        for (integer i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013;

        $readmemh("program.hex", mem);
    end

endmodule
