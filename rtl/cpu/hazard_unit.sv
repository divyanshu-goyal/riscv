`timescale 1ns/1ps

module hazard_unit (
    input  logic [4:0] if_id_rs1,
    input  logic [4:0] if_id_rs2,

    input  logic [4:0] id_ex_rd,
    input  logic        id_ex_mem_read,

    output logic        pc_write,
    output logic        if_id_write,
    output logic        id_ex_flush
);

    always_comb begin

        // Normal operation
        pc_write    = 1'b1;
        if_id_write = 1'b1;
        id_ex_flush = 1'b0;

        // Load-use hazard
        if (id_ex_mem_read &&
            (id_ex_rd != 5'd0) &&
            ((id_ex_rd == if_id_rs1) ||
             (id_ex_rd == if_id_rs2))) begin

            pc_write    = 1'b0;
            if_id_write = 1'b0;
            id_ex_flush = 1'b1;

        end

    end

endmodule
