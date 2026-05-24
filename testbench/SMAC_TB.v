module SMAC_TB;

    reg clk;
    reg [15:0] address;
    reg [1:0] current_mode;
    reg mem_read, mem_write, mem_execute;

    wire mem_enable, access_fault;
    wire [15:0] fault_address;

    // DUT
    SMAC_TOP dut (
        .clk(clk),
        .address(address),
        .current_mode(current_mode),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_execute(mem_execute),
        .mem_enable(mem_enable),
        .access_fault(access_fault),
        .fault_address(fault_address)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Header
    initial begin
        $display("---------------------------------------------------------------");
        $display(" Time | Mode | Address | R W X | Enable | Fault | Fault Address ");
        $display("---------------------------------------------------------------");
    end

    // Live monitor (optional but professional)
    initial begin
        $monitor("%4t |  %b   | 0x%h | %b %b %b |   %b    |   %b   | 0x%h",
                 $time, current_mode, address,
                 mem_read, mem_write, mem_execute,
                 mem_enable, access_fault, fault_address);
    end

    // Test stimulus
    initial begin
        clk = 0;

        // -------------------------------
        // USER execute CODE (ALLOW)
        // -------------------------------
        address = 16'h1000;
        current_mode = 2'b00;   // USER
        mem_read = 0;
        mem_write = 0;
        mem_execute = 1;
        #10;

        // -------------------------------
        // USER execute DATA (FAULT)
        // -------------------------------
        address = 16'h3000;
        current_mode = 2'b00;
        mem_execute = 1;
        #10;

        // -------------------------------
        // SUPERVISOR execute OS (FAULT)
        // -------------------------------
        address = 16'h5000;
        current_mode = 2'b01;   // SUPERVISOR
        mem_execute = 1;
        #10;

        // -------------------------------
        // KERNEL execute KERNEL (ALLOW)
        // -------------------------------
        address = 16'h7000;
        current_mode = 2'b10;   // KERNEL
        mem_execute = 1;
        #10;

        $display("---------------------------------------------------------------");
        $display("Simulation Completed");
        $stop;
    end

endmodule
