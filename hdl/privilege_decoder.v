
module privilege_decoder (
    input  [1:0] current_mode,
    output reg [1:0] privilege_level
);
    always @(*) begin
        privilege_level = current_mode;
    end
endmodule
