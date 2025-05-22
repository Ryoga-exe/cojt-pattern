//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------

module BASYS3_PATTERN(
	input	logic		CLKIN,		//system clock 100MHz
	input	logic		btnR,		//push sw Right (resolution sw)
	input	logic		btnL,		//push sw Left (no use)
	input	logic		btnU,		//push sw Up (no use)
	input	logic		btnD,		//push sw Down (reset)
	input	logic		btnC,		//push sw Center (no use)
	output	logic		RED0,		//RED0
	output	logic 		RED1,		//RED1
	output	logic		RED2,		//RED2
	output	logic 		RED3,		//RED3
	output	logic		GRN0,		//GREEN0
	output	logic 		GRN1,		//GREEN1
	output	logic		GRN2,		//GREEN2
	output	logic 		GRN3,		//GREEN3
	output	logic		BLU0,		//BLUE0
	output	logic 		BLU1,		//BLUE1
	output	logic		BLU2,		//BLUE2
	output	logic 		BLU3,		//BLUE3
	output	logic		HSYNC,		//horizontal sync signal active lo
	output	logic		VSYNC,		//vertical sync signal active lo
	output	logic [3:0]	an,
	output	logic 		dp,
	output	logic [6:0]	seg,
	output	logic [15:0]	led	);

//internal signal declare
logic		clk;		//100MHz
logic		dclk;		//25Mhz or 65Mhz
logic		rst;		//reset
logic		exrst;		//extended reset
logic [7:0]	exrst_ff;	//shift register for exrst
logic		rtgl;		//resolution signal from BTNR
logic [7:0]	RED;		//DSP_R
logic [7:0]	GRN;		//DSP_G
logic [7:0]	BLU;		//DSP_B

always_comb an <= 4'b1111;
always_comb dp <= 1'b1;
always_comb seg <= 7'b1111111;
always_comb led[14:0] <= 15'b000000000000000;
always_comb led[15] <= rtgl;

always_ff @(posedge clk) begin
	exrst_ff <= {exrst_ff[6:0],rst};
end

always_ff @(posedge clk) begin
	if (rst==1'b1) begin
		exrst <= 1'b1;
	end else if (exrst_ff[7]==1'b1) begin
		exrst <= 1'b0;
	end
end


// MMCM_Block  Instance --
clk_gen i_clk_gen (
	.clk_in1(CLKIN),	//input clk_in1
	.clk_sel(XGA),		//dclk select
	.clk_out1(clk),		//100MHz
	.dclk(dclk)		);	//Display clock(65Mhz/25Mhz)

//push sw 
btn		i_btn	(
	.clk(clk),
	.btnu(btnU),
	.btnr(btnR),
	.btnl(btnL),
	.btnd(btnD),
	.btnc(btnC),
	.uone(),
	.utgl(),
	.rone(),
	.rtgl(rtgl),
	.lone(),
	.ltgl(),
	.done(rst),
	.dtgl(),
	.cone(),
	.ctgl()		);
	
patgen		i_patgen	(
	.DCLK(dclk),
	.RST(exrst),
	.BTNR_TGL(rtgl),		//resolution signal xga=1, vga=0
	.XGA(XGA),				//resolution signal synchronized to VSYNC_X 
	.DSP_HSYNC_X(HSYNC),
	.DSP_VSYNC_X(VSYNC),
	.DSP_DE(),
	.DSP_R(RED),
	.DSP_G(GRN),
	.DSP_B(BLU)	);

always_comb begin
	RED3 <= RED[7];
	RED2 <= RED[5];
	RED1 <= RED[3];
	RED0 <= RED[1];
end

always_comb begin
	GRN3 <= GRN[7];
	GRN2 <= GRN[5];
	GRN1 <= GRN[3];
	GRN0 <= GRN[1];
end

always_comb begin
	BLU3 <= BLU[7];
	BLU2 <= BLU[5];
	BLU1 <= BLU[3];
	BLU0 <= BLU[1];
end

endmodule