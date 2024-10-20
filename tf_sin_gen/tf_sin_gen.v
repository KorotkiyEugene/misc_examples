// The code is not synthesizable due to the use of the real data type, which was applied for 
// clarity (the code would be more complex for fixed-point or hardware-synthesizable float point). 
// In all other aspects, author used a synthesizable design structure

module tf_sin_gen(
    input  wire i_clk,
    input  wire i_rst_n,
    input  wire real i_u,
    output wire real o_y
);

    localparam PI = 3.141592653589793;
    parameter real W = PI / 10; // Sin argument (phase) increment for each subsequent k
                                // So the 2*PI/W is the number of points in the sin() period 
    
    // Coefficients for the transfer function
    real a0 = 0;
    real a1 = $sin(W);
    real b1 = -2 * $cos(W);
    real b2 = 1;

    // Internal states (delay elements)
    real z[0:1];

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            z[1] <= 0;
            z[0] <= 0;
        end else begin
            z[1] <= i_u * a1 + z[0] - b1 * z[1];
            z[0] <= - b2 * z[1];
        end
    end

    assign o_y = z[1]; 

endmodule
