`timescale 1ns / 1ps

module tf_sin_gen_tb;
    parameter CLK_PERIOD = 20;
    parameter SIM_CLK_CYCLES = 100;

    reg clk;
    reg rst_n;
    integer u;
    wire real u_real;
    wire real y;

    tf_sin_gen dut (
        .i_clk (clk),
        .i_rst_n (rst_n),
        .i_u (u_real),
        .o_y (y)
    );

    assign u_real = $itor(u);

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $dumpfile("tf_sin_gen_tb.vcd");
        $dumpvars();
    end

    initial begin
        rst_n = 0;
        u = 0;
        repeat (5) @(negedge clk); 
        rst_n = 1;  

        // Apply one clock cycle wide delta function
        repeat (2) @(negedge clk); 
        u = 1;
        @(negedge clk); 
        u = 0;
        
        repeat (SIM_CLK_CYCLES) @(negedge clk);
        $finish;
    end

endmodule

