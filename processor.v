/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,	 // I: Data from port B of regfile
	 q_PC_test,//////TEST
	 alu1_out_test,
	 Rwd0_test,
	 Rwd1_test,
	 mux1_out_test,mux1_in1_test,
	 ALUinB_test,
	 addi_test,
	 op_code_test
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;


	 
    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;


wire [4:0]op_code;
assign op_code = q_imem[31:27];


//////TEST
output [4:0]op_code_test;
assign op_code_test=op_code;




wire [4:0]mux9_out,mux10_out;//R type, I type, JII type
wire [4:0]r_rt; 
wire [4:0]shamt;
assign shamt = q_imem[11:7];
wire [4:0]ALUOp;
assign ALUOp = q_imem[6:2];

wire [16:0]imme;
assign imme = q_imem[16:0];
wire [26:0]target;
assign target = q_imem[26:0];
wire [31:0]mux1_in1;
wire [31:0] mux1_out,alu1_out;
wire [31:0]q_PC,mux8_out,alu2_out,alu3_out;
wire isNotEqual1, isLessThan1, overflow1,isNotEqual2, isLessThan2, overflow2,isNotEqual3, isLessThan3, overflow3;
wire [31:0]mux2_out,mux3_out,mux4_out,mux5_out,mux6_out,mux7_out,mux11_out,mux12_out,mux13_out,mux14_out; 
wire r_type,addi,sw,lw,j,bne,jal,jr,blt,bex,setx,add,sub;	
wire and1_out,and2_out,or1_out;
wire BR1,JP1,JP0,ALUinB,ctrl_writeEnable,Rwd1,Rwd0,BR2,r30_or_r31,mux10_control,rstatus_1_or_2,rstatus_3_or_T,mux13_control,mux14_control;


assign mux9_out = r30_or_r31? 5'b11111:5'b11110;

assign r_rt = bex? 5'b00000 : q_imem[16:12];//bex = 1, rt choose r0
assign ctrl_writeReg = mux10_control? q_imem[26:22] : mux9_out;
assign ctrl_readRegA = bex? 5'b11110 : q_imem[21:17];//bex = 1, rs choose r30
assign ctrl_readRegB = sw ? q_imem[26:22] : r_rt;
//sign-extend immediate

assign mux1_in1=imme[16] ? {{15{1'b1}},imme} :{{15'b0},imme};//15‘b1:用15个bit表示1



//module mux(select, in0, in1, out);
mux mux1(ALUinB,data_readRegB,mux1_in1,mux1_out);
	
//module alu(data_operandA, data_operandB, ctrl_ALUopcode,
	//		ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

	////TEST

alu alu1(data_readRegA,mux1_out,ALUOp,shamt,alu1_out,isNotEqual1, isLessThan1, overflow1);

output [31:0]alu1_out_test;
assign alu1_out_test = alu1_out; 
//bex


assign address_dmem=alu1_out[11:0];
assign data=data_readRegB;

mux
   mux2(Rwd0,q_dmem,q_dmem,mux2_out);

//module PC(q,d,clk,en,clr);
output [31:0]q_PC_test;
assign q_PC_test = q_PC;

PC
  PC(q_PC,mux8_out,clock,1'b1,reset);

assign address_imem = q_PC[11:0];
alu
   alu2(q_PC,32'd1,5'b0,5'b0,alu2_out,isNotEqual2, isLessThan2, overflow2);
 


mux
   mux3(Rwd0,alu1_out,alu2_out,mux3_out),
   mux4(Rwd1,mux3_out,mux2_out,mux4_out),
   mux11(rstatus_1_or_2,32'd1,32'd2,mux11_out),
	mux12(rstatus_3_or_T,32'd3,{{5'b0},target},mux12_out),
	mux13(mux13_control,mux11_out,mux12_out,mux13_out),
	mux14(mux14_control,mux4_out,mux13_out,mux14_out);
	
assign data_writeReg=mux14_out;

//module alu(data_operandA, data_operandB, ctrl_ALUopcode,
	//		ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
alu
   alu3(alu2_out,mux1_in1,5'b00000,5'b00000,alu3_out,isNotEqual3, isLessThan3, overflow3);


and and1(and1_out,isNotEqual1,BR1);
and and2(and2_out,isLessThan1,BR2);
or or1(or1_out,and1_out,and2_out);
		
mux
   mux5(or1_out,alu2_out,alu3_out,mux5_out),
	mux6(JP0,mux5_out,data_readRegA,mux6_out),
	mux7(JP0,{{5'b0},target},{{5'b0},target},mux7_out),
	mux8(JP1,mux6_out,mux7_out,mux8_out);


//opcode
assign r_type =((~op_code[4])&(~op_code[3])&(~op_code[2])&(~op_code[1])&~op_code[0]);//add:00000
assign addi = ((~op_code[4])&(~op_code[3])&(op_code[2])&(~op_code[1])&(op_code[0]));//addi:00101
assign sw = (~op_code[4]&~op_code[3]&op_code[2]&op_code[1]&op_code[0]);//sw:00111
assign lw = (~op_code[4]&op_code[3]&~op_code[2]&~op_code[1]&~op_code[0]);//lw:01000
assign j= (~op_code[4]&~op_code[3]&~op_code[2]&~op_code[1]&op_code[0]);//j:00001
assign bne = (~op_code[4]&~op_code[3]&~op_code[2]&op_code[1]&~op_code[0]);//bne:00010
assign jal = (~op_code[4]&~op_code[3]&~op_code[2]&op_code[1]&op_code[0]);//jal:00011
assign jr = (~op_code[4]&~op_code[3]&op_code[2]&~op_code[1]&~op_code[0]);//jr:00100
assign blt = (~op_code[4]&~op_code[3]&op_code[2]&op_code[1]&~op_code[0]);//blt:00110
assign bex=(op_code[4]&~op_code[3]&op_code[2]&op_code[1]&~op_code[0]);//bex:10110
assign setx = (op_code[4]&~op_code[3]&op_code[2]&~op_code[1]&op_code[0]);//setx:10101
assign add = (~ALUOp[4]&~ALUOp[3]&~ALUOp[2]&~ALUOp[1]&~ALUOp[0]&~op_code[4]&~op_code[3]&~op_code[2]&~op_code[1]&~op_code[0]); //00000
assign sub = (~ALUOp[4]&~ALUOp[3]&~ALUOp[2]&~ALUOp[1]&ALUOp[0]&~op_code[4]&~op_code[3]&~op_code[2]&~op_code[1]&~op_code[0]);//00001


assign BR1=bne?1'b1:1'b0;
assign JP1 = j | jal|(bex&isNotEqual1) ? 1'b1 : 1'b0;//
assign JP0 = jr ? 1'b1:1'b0;
assign ALUinB = addi | sw | lw ? 1'b1:1'b0;
assign wren = sw ? 1'b1:1'b0;//write enable for dmem
assign ctrl_writeEnable = r_type|addi|lw|jal ?1'b1:1'b0;
assign Rwd1=lw?1'b1:1'b0;
assign Rwd0 = jal?1'b1:1'b0;
assign BR2 = blt?1'b1:1'b0;
assign r30_or_r31 = jal ?1'b1:1'b0;
assign mux10_control = ~((overflow1&(add|sub|addi))|setx|jal)? 1'b1:1'b0;
assign rstatus_1_or_2 = addi ?1'b1:1'b0;
assign rstatus_3_or_T = setx? 1'b1:1'b0;
assign mux13_control = (sub|setx) ? 1'b1:1'b0;
assign mux14_control = ((add&overflow1)|setx|(sub&overflow1)|(addi&overflow1))?1'b1:1'b0;


///////TEST
output Rwd1_test,addi_test;
assign Rwd1_test= Rwd1;
assign addi_test= addi;

output Rwd0_test;
assign Rwd0_test= Rwd0;

//////////////TEST
output [31:0] mux1_out_test,mux1_in1_test;
assign mux1_out_test = mux1_out;
assign mux1_in1_test = mux1_in1;
output ALUinB_test; 
assign ALUinB_test= ALUinB;
endmodule
