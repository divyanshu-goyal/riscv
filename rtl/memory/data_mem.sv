`timescale 1ns/1ps

module data_mem (
    input  logic        clk,
    input  logic        rst,

    input  logic [31:0] addr,
    input  logic [31:0] write_data,

    input  logic        mem_read,
    input  logic        mem_write,

    output logic [31:0] read_data
);

    logic [31:0] mem [0:255];

    integer i;

    // Combinational read
    always_comb begin
        if (mem_read)
            read_data = mem[addr[9:2]];
        else
            read_data = 32'b0;
    end

    // Synchronous write
    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1)
                mem[i] = 32'b0;
	    
        end
        else if (mem_write) begin
            mem[addr[9:2]] <= write_data;
        end
    end

endmodule
