module SMAC_TOP (
    input        clk,
    input [15:0] address,
    input [1:0]  current_mode,
    input        mem_read,
    input        mem_write,
    input        mem_execute,
    output       mem_enable,
    output       access_fault,
    output [15:0] fault_address
);

    wire [1:0] privilege_level;
    wire [1:0] required_mode;
    wire allow_read, allow_write, allow_execute;
    wire allow, fault;

    privilege_decoder U1 (
        .current_mode(current_mode),
        .privilege_level(privilege_level)
    );

    region_decoder U2 (
        .address(address),
        .required_mode(required_mode),
        .allow_read(allow_read),
        .allow_write(allow_write),
        .allow_execute(allow_execute)
    );

    access_control U3 (
        .privilege_level(privilege_level),
        .required_mode(required_mode),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_execute(mem_execute),
        .allow_read(allow_read),
        .allow_write(allow_write),
        .allow_execute(allow_execute),
        .allow(allow),
        .fault(fault)
    );

    fault_logger U4 (
        .clk(clk),
        .fault(fault),
        .address(address),
        .last_fault_addr(fault_address),
        .fault_valid()
    );

    assign mem_enable   = allow;
    assign access_fault = fault;

endmodule

