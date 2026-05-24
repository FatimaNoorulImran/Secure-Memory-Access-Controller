module fault_logger (
    input        clk,
    input        fault,
    input [15:0] address,
    output reg [15:0] last_fault_addr,
    output reg        fault_valid
);
    always @(posedge clk) begin
        if (fault) begin
            last_fault_addr <= address;
            fault_valid <= 1;
        end
    end
endmodule

