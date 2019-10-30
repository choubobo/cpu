/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock,reg0,reg1,reg2,reg3,
	reg4,
	reg5,
	reg6,
	reg7,
	
	
	
	 q_PC_test,//////TEST
	 alu1_out_test,
	 Rwd0_test,
	 Rwd1_test,
	 mux1_out_test,mux1_in1_test,
	 ALUinB_test,addi_test,op_code_test,
	 address_imem_test,q_imem_test,
	 address_dmem_test,wren_test,q_dmem_test	
	 );
	 
	 
	 
	 
    input clock, reset;
    output imem_clock, dmem_clock, processor_clock, regfile_clock;

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
	 
	   imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

	 
	 
	  //////TEST
	 output [11:0]address_imem_test;
	 assign address_imem_test = address_imem;
	 output [31:0] q_imem_test;
	 
	 assign q_imem_test=q_imem;//////skeleton 的 q_imem
	
output [11:0] address_dmem_test;
assign address_dmem_test= address_dmem;
output wren_test;
assign wren_test = wren;
output [31:0] q_dmem_test;

assign q_dmem_test = q_dmem;
	
	 
	 
    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (data),    // data you want to write
        .wren	    (wren),      // write enable
        .q          (q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 
	 //////TEST
	 output [31:0]reg0,reg1,reg2,reg3,
	reg4,
	reg5,
	reg6,
	reg7;



	
	 
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  reg0, ////////test
		  reg1,
		  reg2,
		  reg3,
	reg4,
	reg5,
	reg6,
	reg7
    );
	 
	
//////TEST
output [31:0] q_PC_test,alu1_out_test,mux1_out_test,mux1_in1_test;//////TEST
output Rwd0_test,Rwd1_test,ALUinB_test,addi_test;
output [4:0]op_code_test;	 
	 
    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        .clock(clock),                          // I: The master clock
        .reset(reset),                          // I: A reset signal

        // Imem
        .address_imem(address_imem),                   // O: The address of the data to get from imem
        .q_imem(q_imem),                         // I: The data from imem

        // Dmem
        .address_dmem(address_dmem),                   // O: The address of the data to get or put from/to dmem
        .data(data),                           // O: The data to write to dmem
        .wren(wren),                           // O: Write enable for dmem
        .q_dmem(q_dmem),                         // I: The data from dmem

        // Regfile
        .ctrl_writeEnable(ctrl_writeEnable),               // O: Write enable for regfile
        .ctrl_writeReg(ctrl_writeReg),                  // O: Register to write to in regfile
        .ctrl_readRegA(ctrl_readRegA),                  // O: Register to read from port A of regfile
        .ctrl_readRegB(ctrl_readRegB),                  // O: Register to read from port B of regfile
        .data_writeReg(data_writeReg),                  // O: Data to write to for regfile
        .data_readRegA(data_readRegA),                  // I: Data from port A of regfile
        .data_readRegB(data_readRegB),                   // I: Data from port B of regfile
		  
		 
		 .q_PC_test(q_PC_test),//////TEST
	 .alu1_out_test(alu1_out_test),
	 .Rwd0_test(Rwd0_test),
	 .Rwd1_test(Rwd1_test),
	 .mux1_out_test(mux1_out_test),
	 .mux1_in1_test(mux1_in1_test),
	 .ALUinB_test(ALUinB_test),
	 .addi_test(addi_test),
	 .op_code_test(op_code_test)
    );

endmodule