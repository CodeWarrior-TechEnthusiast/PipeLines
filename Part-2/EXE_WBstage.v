`include "define.v"

module EXE_WB_stage (
	
	input  clk,  rst,
	input [`ASIZE-1:0] waddr_in,
	input [`DSIZE-1:0] aluout_in,
	output reg [`ASIZE-1:0] waddr_out,
	output reg [`DSIZE-1:0] aluout_out
	
);

//EXE_WB register to save the values.
always @ (posedge clk) begin
	if(rst)
	begin
		waddr_out <= 0;
		aluout_out<=0;
	end
   else
	begin
		waddr_out <= waddr_in;
		aluout_out<=aluout_in;
	end
 
end
endmodule






