// clock module for PATTERN

module clk_gen(
    input   logic       clk_in1,      //system clock 100MHz
    input   logic       clk_sel,        //clock select
    output  logic       clk_out1,       //100MHz
    output  logic       dclk    );      //display clock  25MHz or 65MHz

//internal signal declare
logic   clk25MHz;
logic   clk65MHz;


// MMCM instance
clk_core i_clk_core   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1 100MHz
    .clk_out2(clk25MHz),     // output clk_out2 25MHz
    .clk_out3(clk65MHz),     // output clk_out3 65MHz
   // Clock in ports
    .clk_in1(clk_in1)      // input clk_in1
);

//clock select BUFG
BUFGMUX_CTRL i_BUFGMUX_CTRL (
    .O(dclk),   // 1-bit output: Clock output
    .I0(clk25MHz), // 1-bit input: Clock input (S=0)
    .I1(clk65MHz), // 1-bit input: Clock input (S=1)
    .S(clk_sel)    // 1-bit input: Clock select
);
    
endmodule 
