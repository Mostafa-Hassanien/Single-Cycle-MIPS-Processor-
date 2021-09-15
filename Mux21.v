//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: 2 * 1 Multiplexer                                                   //
// The multiplexer has a single bit selector line (sel) to choose accordingly       // 
// between the two parameterized data inputs A and B.                               //
//////////////////////////////////////////////////////////////////////////////////////
module Mux21 
#(parameter Data_Width = 32)
(
  //-------------------------------Input Ports------------------------------------//
  input     wire    [Data_Width - 1:0]   A, B,
  input     wire                         sel,
  //-------------------------------Output Ports------------------------------------//
  output    wire    [Data_Width - 1:0]   out
  );
  // Main Combinational Logic
assign out = sel ? B : A;
endmodule