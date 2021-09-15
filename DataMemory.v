//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Data Memory RAM                                                     //
// The data memory is a RAM that provides a store for the CPU to load from and      //
// store to. The Data Memory has one read port and one write port. Reads are        //
// asynchronous while writes are synchronous to the rising edge of the ?clk? signal.//
// The Word width of the data memory is 32-bits to match the datapath width.        //
// The data memory has a 4-bit write enable bus (wren[3:0]) to allow writes from    //
// specific bytes of the 32-bit ?wdata?. The write enable bus is useful only when   //
// performing a write to the data memory and is meaningless for reads               //
// (reads return all 4 bytes of a word). For example, Wen[3:0] == 4?b0001 indicates //
// that only the lower byte of the ?wdata? should be used to update the location    // 
// specified by the address. There are four valid values of wren:                   //
// 4?b0000 (No write), 4?b0001 (byte0), 4?b0011 (bytes 0-1), and 4?b1111 (bytes 0-3)//                           //
//////////////////////////////////////////////////////////////////////////////////////
module DataMemory (
    //-------------------------------Input Ports------------------------------------//
    input    wire    [31:0]      Wdata,
    input    wire    [31:0]      addr,
    input    wire    [3:0]       Wen,
    input    wire                clk,
    input    wire                rst,    // Additional Signal for proper operation
    //-------------------------------Output Ports-----------------------------------//
    output   reg     [31:0]      Rdata
  );
  
 integer i;
  
// Memory Depth
localparam  Memory_Depth = 1 << 32;
  
// Memory 
reg    [31:0]  Memory  [0:Memory_Depth - 1];

// Asynchronous Read Data
  always @(*)
    begin
      Rdata = Memory[addr];
    end
    
// Synchronous Write and Active High Asynchronous Reset
always @(posedge clk or posedge rst)
  begin
    if (rst)
      begin
        for (i = 0; i < Memory_Depth; i = i + 1)
            begin
                Memory[i] <= 'b0;
            end
      end
    else 
      begin
        case (Wen)
          4'b0001 : Memory[addr] <= Wdata[7:0];
          4'b0011 : Memory[addr] <= Wdata[15:0];
          4'b1111 : Memory[addr] <= Wdata;
        endcase
      end 
  end
endmodule
  
