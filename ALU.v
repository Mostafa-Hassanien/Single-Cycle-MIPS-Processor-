//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: ALU                                                                 //
// The ALU supports Add, Subtract, AND, OR, XOR, NOR, Set on Less than, Shift Left, // 
// Shift Right, and Shift Right Arithmetic. The specific operation that the ALU     //
// performs is specified by the 4-bit ?alu_control? bus.                            //
//////////////////////////////////////////////////////////////////////////////////////
module ALU 
  #(parameter Data_Width = 32)
  (
    //-------------------------------Input Ports------------------------------------//
    input   wire   [Data_Width - 1:0]    operand0, operand1,
    input   wire   [4:0]                 shamt,
    input   wire   [3:0]                 alu_control,
    //-------------------------------Output Ports------------------------------------//
    output  reg    [Data_Width - 1:0]    result,
    output  reg                          overflow, 
    output  wire                         zero
  );
  
// ALU zero Flag
assign zero     = (result == 'b0);
  
// ALU Functions Implementation
always @(*)
  begin
    overflow = 1'b0;
    result   =  'b0;
    case (alu_control)
      4'b0000: result = operand0 & operand1;
      4'b0001: result = operand0 | operand1;
      4'b0010: result = operand0 ^ operand1;
      4'b0011: result = ~(operand0 | operand1);
      4'b0100: result = operand0 + operand1;
      4'b0101: {overflow,result} = $signed (operand0) + $signed (operand1); 
      4'b0110: result = operand0 - operand1;
      4'b0111: {overflow,result} = $signed (operand0) - $signed (operand1); 
      4'b1000: result = ($signed (operand0) < $signed (operand1));
      4'b1001: result = operand0 << shamt;
      4'b1010: result = operand0 >> shamt;
      4'b1011: result = operand0 >>> shamt;
      default: result = 'b0;   
    endcase
  end
endmodule
  