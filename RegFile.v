//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Register File                                                       //
// The Register File, RF, contains the 32 32-bit MIPS registers. The register file  // 
// has two read ports and a single write port. The register file is read            //
// asynchronously and written synchronously at the rising edge of the clock.        //
// Additionally, it has an active high asynchronous reset.                           //
//////////////////////////////////////////////////////////////////////////////////////
module RegFile 
#(parameter RegFile_Width     = 32,
           AddressBus_width   = 5)
(
  //-------------------------------Input Ports-------------------------------------//
  input    wire    [RegFile_Width - 1: 0]    Wdata,
  input    wire    [AddressBus_width - 1:0]  Waddr,
  input    wire                              Wen,
  input    wire    [AddressBus_width - 1:0]  Raddr0, Raddr1,
  input    wire                              clk,
  input    wire                              rst, // Additional Signal for proper operation
  //-------------------------------Output Ports------------------------------------//
  output   reg     [RegFile_Width - 1: 0]    Rdata0, Rdata1
);
// RegFile Depth
localparam RegFile_Depth = 1 << AddressBus_width;

integer i;
// Memory 
reg   [RegFile_Width - 1:0]  Memory  [0:RegFile_Depth - 1];

// Asynchronous Read Data 
always @(*)
  begin
    Rdata0 = Memory[Raddr0];
    Rdata1 = Memory[Raddr1];
  end
  
// Synchronous Write Data and Asynchronous active low reset
always @(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        for (i = 0; i <  RegFile_Depth; i = i + 1)
            begin
              Memory[i] <= 'b0;
            end
      end
   else if (Wen) 
      begin
        Memory[Waddr] <= Wdata;
      end
  end
endmodule







