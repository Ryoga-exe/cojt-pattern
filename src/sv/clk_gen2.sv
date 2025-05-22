// clock module for PATTERN

module clk_gen2(
    input   logic       clk_in1,      //system clock 100MHz
    input   logic [1:0] clk_sel,        //clock select
    output  logic       clk_out1,       //100MHz
    output  logic       dclk    );      //display clock  25MHz or 65MHz

//internal signal declare
logic   clk25MHz;   //for VGA
logic   clk65MHz;   //for XGA
logic   clk40MHz;   //for SVGA
logic   clk108MHz;  //for SXGA
logic   clkfb_out;  //for PLL feedback out
logic   clkfb_in;   //for PLL feedback in
logic   dclk_a;     //25MHz or 65MHz
logic   dclk_b;     //40MHz or 108MHz


// MMCM instance
clk_core i_clk_core   (
    // Clock out ports
    .clk_out1(clk_out1),     // output clk_out1 100MHz
    .clk_out2(clk25MHz),     // output clk_out2 25MHz
    .clk_out3(clk65MHz),     // output clk_out3 65MHz
   // Clock in ports
    .clk_in1(clk_in1)      // input clk_in1
);

// PLL instance
clk_core2 i_clk_core2   (
    .clkfb_in(clkfb_in),     // input clkfb_in
    // Clock out ports
    .clk_out1(clk40MHz),     // output clk_out1 40MHz
    .clk_out2(clk108MHz),     // output clk_out2 108MHz
    .clkfb_out(clkfb_out),    // output clkfb_out
   // Clock in ports
//    .clk_in1(clk_in1)      // input clk_in1
    .clk_in1(clk_out1)      // input clk_out1
);

//feedback buffer for PLL
BUFG i_BUFG (
      .O(clkfb_in), // 1-bit output: Clock output
      .I(clkfb_out)  // 1-bit input: Clock input
);

//clock select BUFG(VGA/XGA)
BUFGMUX_CTRL i_BUFGMUX_CTRL_A (
    .O(dclk_a),   // 1-bit output: Clock output
    .I0(clk25MHz), // 1-bit input: Clock input (S=0)
    .I1(clk65MHz), // 1-bit input: Clock input (S=1)
    .S(clk_sel[0])    // 1-bit input: Clock select
);

//clock select BUFG(SVGA/SXGA)
BUFGMUX_CTRL i_BUFGMUX_CTRL_B (
    .O(dclk_b),   // 1-bit output: Clock output
    .I0(clk40MHz), // 1-bit input: Clock input (S=0)
    .I1(clk108MHz), // 1-bit input: Clock input (S=1)
    .S(clk_sel[0])    // 1-bit input: Clock select
);
    
//clock select BUFG(VGA/XGA/SVGA/SXGA)
BUFGMUX_CTRL i_BUFGMUX_CTRL_O (
    .O(dclk),   // 1-bit output: Clock output
    .I0(dclk_a), // 1-bit input: Clock input (S=0)
    .I1(dclk_b), // 1-bit input: Clock input (S=1)
    .S(clk_sel[1])    // 1-bit input: Clock select
);


endmodule 
