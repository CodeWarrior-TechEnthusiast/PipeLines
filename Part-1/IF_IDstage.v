`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:24 11/08/2018 
// Design Name: 
// Module Name:    IF_IDstage 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module IF_ID_stage (
	
	input  clk,  rst, 
	input [`ISIZE-1:0] inst_in,

	output reg [`ISIZE-1:0] inst_out);




always @ (posedge clk) begin
	if(rst)
	begin
		inst_out <= 0;
	end
   else
	begin
		inst_out <= inst_in;
	end
 
end
endmodule


