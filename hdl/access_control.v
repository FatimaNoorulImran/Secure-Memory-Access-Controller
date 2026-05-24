
module access_control (
    input  [1:0] privilege_level,
    input  [1:0] required_mode,
    input        mem_read,
    input        mem_write,
    input        mem_execute,
    input        allow_read,
    input        allow_write,
    input        allow_execute,
    output reg   allow,
    output reg   fault
);

    always @(*) begin
        allow = 0;
        fault = 0;

        // Privilege check
        if (privilege_level < required_mode) begin
            fault = 1;
        end
        else begin
            if (mem_read && !allow_read)
                fault = 1;
            else if (mem_write && !allow_write)
                fault = 1;
            else if (mem_execute && !allow_execute)
                fault = 1;
            else
                allow = 1;
        end
    end
endmodule
