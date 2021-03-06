//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Program Counter                                                     //
// The program counter maintains the current 32-bit instruction address and outputs //
// it on the ?pc? bus. The program counter is a synchronous unit that is updated at //
// the rising edge of the clock signal ?clk?. The program counter is asynchronously //
// cleared (zeroed) whenever the active-high reset signal ?rst? is asserted. The    //
// value of the program counter is updated based on the value of the 4-bit          //
// ?pc_control? signal.                                                             //
//////////////////////////////////////////////////////////////////////////////////////
module ProgramCounter (
  //-------------------------------Input Ports--------------------------------------//
  input    wire     [3:0]      PC_control,
  input    wire     [31:0]     reg_addr,
  input    wire     [15:0]     branch_offset,
  input    wire     [25:0]     jump_addr,
  input    wire                clk,
  input    wire                rst,
  //-------------------------------Output Ports------------------------------------//
  output   reg      [31:0]     PC
  );
  
// Internal Connection 
wire    [31:0]     branch_offset_sign_extended;
wire    [31:0]     jump_addr_multiplied_4;

// Combinational Logic
assign jump_addr_multiplied_4 = jump_addr << 2;

// instentiating Sign Extension Module 
SignExtension #(.input_width(16), .output_width(32)) SIGN_Extension (
  .in(branch_offset), .out(branch_offset_sign_extended)
);


// Active High Asynchronous Reset
always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        PC = 32'b0;
      end
    else
      begin
        case (PC_control)
          4'b0000 : PC <= PC + 32'd4;
          4'b0001 : PC <= {PC[31:28] , jump_addr_multiplied_4[27:0]};
          4'b0010 : PC <= reg_addr;
          4'b0011 : PC <= PC + 32'd4 + (branch_offset_sign_extended << 2);
        endcase
      end
  end
endmodule 