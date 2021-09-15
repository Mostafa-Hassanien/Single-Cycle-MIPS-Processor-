//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Instruction Memory                                                  //
//The instruction memory is a Read Only Memory (ROM) that holds the program that    //
// your CPU will execute.                                                           //
// Note: the follosing design is not synthesizable; it is only implemented for      //
// testing purposes.                                                                //                                                         
//////////////////////////////////////////////////////////////////////////////////////
module InstructionMemory (
  //-------------------------------Input Ports--------------------------------------//
  input     wire      [31:0]     address,
  //-------------------------------Output Ports-------------------------------------//
  output    wire      [31:0]     instruction
  );

integer i;

// Memory 
reg    [31:0] ROM [0:255];

// ROM Initialization
initial
    begin
      for (i = 0; i < 255; i = i + 1)
        begin
          ROM[i] = 32'hFFFFFFFF;
        end
        $readmemh("program.mips",ROM);
    end
    
// Combinational Logic
assign instruction = ROM[address[9:2]];

always @(instruction)
	begin
		if (instruction == 32'hFFFFFFFF)
			$stop();
	end
endmodule