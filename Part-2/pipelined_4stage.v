`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_4stage(clk, rst, aluout_EXE_WB);

input clk;				
											
input	rst;

	
output [`DSIZE-1:0] aluout_EXE_WB;							
 	

		
	wire [`ISIZE-1:0] currPC;
	wire [`ISIZE-1:0] nextPC;
	wire [`ISIZE-1:0] inst;
	wire [`ISIZE-1:0] instr_out;
	wire alusrc;
	wire alusrc_out;
	wire [2:0]	aluop;
	wire [2:0]	aluop_out;
	wire [`DSIZE-1:0] aluout;
	wire regDST;
	wire wen;
	wire [`DSIZE-1:0] rdata1_in;
	wire [`DSIZE-1:0] rdata1_out;
	wire [`DSIZE-1:0] rdata2_in;
	wire [`DSIZE-1:0] rdata2_out;
	wire [`DSIZE-1:0] imm_in = {16'b0,instr_out[15:0]};
	wire [`DSIZE-1:0] imm_out;
	wire [`ASIZE-1:0]waddr;
	wire [`DSIZE-1:0]rdata2_imm=alusrc_out ? imm_out : rdata2_out;//Multiplexer to select the immediate value or rdata2 based on alusrc.
//when alusrc is 1 then connect immediate data to output else connect rdata2 to output
	wire [`ASIZE-1:0]waddr_regDST=regDST ? instr_out[15:11] : instr_out[20:16];//Multiplexer to select the inst[15:11] or inst[20:16] as the waddr based on regDST.
//when regDST is 1 then connect inst[15:11] to output else connect inst[20:16] to output
	wire [`ASIZE-1:0]waddr_regDST_out;
	
	adder ADD0 (.a(currPC),.b(32'b1),.out(nextPC));
	PC1 PC0 (.clk(clk),.rst(rst),.nextPC(nextPC),.currPC(currPC));
	memory M0 (.clk(clk),.rst(rst),.wen(1'b0), .addr(currPC), .data_in(32'b0), .fileid(0), .data_out(inst));
	IF_ID_stage IF_ID0(.clk(clk),.rst(rst),.inst_in(inst),.inst_out(instr_out));
	
	control C0 (.inst_cntrl(instr_out[31:26]),.wen_cntrl(wen),.alusrc_cntrl(alusrc),.regdst_cntrl(regDST),.aluop_cntrl(aluop));
	regfile RF0 (.clk(clk),.rst(rst),.wen(wen),.raddr1(instr_out[25:21]),.raddr2(instr_out[20:16]),.waddr(waddr),.wdata(aluout_EXE_WB),.rdata1(rdata1_in),.rdata2(rdata2_in));
	
	ID_EXE_stage ID_EXE0(.clk(clk),.rst(rst),.rdata1_in(rdata1_in),.rdata2_in(rdata2_in),.imm_in(imm_in),.opcode_in(aluop),.alusrc_in(alusrc),.waddr_in(waddr_regDST),.rdata1_out(rdata1_out),.rdata2_out(rdata2_out),.imm_out(imm_out),.opcode_out(aluop_out),.alusrc_out(alusrc_out),.waddr_out(waddr_regDST_out));
	alu ALU0 (.a(rdata1_out),.b(rdata2_imm),.op(aluop_out),.out(aluout));
	EXE_WB_stage EXE_WB0 (.clk(clk),.rst(rst),.waddr_in(waddr_regDST_out),.aluout_in(aluout),.waddr_out(waddr),.aluout_out(aluout_EXE_WB));
	
endmodule




