module region_decoder (
    input  [15:0] address,
    output reg [1:0] required_mode,
    output reg       allow_read,
    output reg       allow_write,
    output reg       allow_execute
);

    always @(*) begin
        // Default
        allow_read    = 0;
        allow_write   = 0;
        allow_execute = 0;

        if (address <= 16'h1FFF) begin
            // CODE
            required_mode = 2'b00;
            allow_read    = 1;
            allow_execute = 1;
        end
        else if (address <= 16'h3FFF) begin
            // DATA
            required_mode = 2'b00;
            allow_read    = 1;
            allow_write   = 1;
        end
        else if (address <= 16'h5FFF) begin
            // OS
            required_mode = 2'b01;
            allow_read    = 1;
            allow_write   = 1;
        end
        else begin
            // KERNEL
            required_mode = 2'b10;
            allow_read    = 1;
            allow_write   = 1;
            allow_execute = 1;
        end
    end
endmodule

