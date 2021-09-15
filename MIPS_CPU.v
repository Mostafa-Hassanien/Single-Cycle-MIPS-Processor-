//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: MIPS CPU                                                            //
// The CPU module represents the top-level of the design. All components should     //
// be instantiated in the CPU module and wired appropriately.                       //
//////////////////////////////////////////////////////////////////////////////////////
module MIPS_CPU (
  //-------------------------------Input Ports------------------------------------//
  input      wire    clk,
  input      wire    rst
  );
  
  //-------------------------Internal Wiring Connections--------------------------//
  wire      [31:0]      pc;
  wire      [31:0]      instruction;
  wire                  alu_zero;
  wire      [3:0]       PC_control;
  wire                  reg_file_rmux_select;
  wire                  reg_file_wren;
  wire                  alu_mux_select;
  wire      [4:0]       alu_shamt;
  wire      [3:0]       alu_control;
  wire      [3:0]       data_mem_wren;
  wire                  reg_file_dmux_select;
  wire      [31:0]      sign_extension_out;
  wire      [4:0]       rmux_out;
  wire      [31:0]      wdata;
  wire      [31:0]      rdata0;
  wire      [31:0]      rdata1;
  wire      [4:0]       mux_out;
  wire      [31:0]      result;
  wire      [31:0]      operand1;
  wire      [31:0]      rdata;
  wire                  overflow;
  
  //-----------------------------------------Modules Instentiations----------------------------------------//
  ProgramCounter PC (
  .PC_control(PC_control),
  .reg_addr(rdata0),
  .branch_offset(instruction[15:0]),
  .jump_addr(instruction[25:0]),
  .clk(clk),
  .rst(rst),
  .PC(pc)
  );
  //******************************************************************************************************//
  InstructionMemory IM (
  .address(pc),
  .instruction(instruction)
  );
  //******************************************************************************************************//
  Mux21 rmux (
  .A(instruction[20:16]), 
  .B(instruction[15:11]),
  .sel(reg_file_rmux_select),
  .out(rmux_out)
  );
  //******************************************************************************************************//
  RegFile RF (
  .Wdata(wdata),
  .Waddr(rmux_out),
  .Wen(reg_file_wren),
  .Raddr0(instruction[25:21]),
  .Raddr1(instruction[20:16]),
  .clk(clk),
  .rst(rst),
  .Rdata0(rdata0), 
  .Rdata1(rdata1)
  );
  //******************************************************************************************************//
  SignExtension SE (
  .in(instruction[15:0]),
  .out(sign_extension_out)
  );
  //******************************************************************************************************//
  Mux21 mux (
  .A(rdata1), 
  .B(sign_extension_out),
  .sel(alu_mux_select),
  .out(operand1)
  );
  //******************************************************************************************************//
  ALU ALU1 (
  .operand0(rdata0), 
  .operand1(operand1),
  .shamt(alu_shamt),
  .alu_control(alu_control),
  .result(result),
  .overflow(overflow), 
  .zero(alu_zero)
  );
  //******************************************************************************************************//
  DataMemory DM (
  .Wdata(rdata1),
  .addr(result),
  .Wen(data_mem_wren),
  .clk(clk),
  .rst(rst),
  .Rdata(rdata)  
  );
  //******************************************************************************************************//
  Mux21 dmux (
  .A(rdata), 
  .B(result),
  .sel(reg_file_dmux_select),
  .out(wdata)
  );
  //******************************************************************************************************//
  ControlUnit CU (
  .instruction(instruction),
  .alu_zero(alu_zero),
  .rst(rst),
  .PC_control(PC_control),
  .reg_file_rmux_select(reg_file_rmux_select),
  .reg_file_wren(reg_file_wren),
  .alu_mux_select(alu_mux_select),
  .alu_shamt(alu_shamt),
  .alu_control(alu_control),
  .data_mem_wren(data_mem_wren),
  .reg_file_dmux_select(reg_file_dmux_select)
  );
  //******************************************************************************************************//
endmodule
  
  
  
  
  
  
  
  
  