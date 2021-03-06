//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Sign Extension                                                      //
// This module is responsible for replicating the sign bit number of times depending// 
// on the output and input ports. It is a parameterized synthesisable module        //
//////////////////////////////////////////////////////////////////////////////////////
module SignExtension 
 #(parameter input_width  = 16,
             output_width = 32)
 (
  //-------------------------------Input Ports-------------------------------------//
   input    wire   [input_width - 1:0]    in,
  //-------------------------------Output Ports------------------------------------//
   output   wire   [output_width - 1:0]    out
  );
  
// sign bit location
localparam sign_bit_location      = input_width  - 1;
localparam sign_bit_replication_count  = output_width - input_width;

// Combinational logic
assign out = {{sign_bit_replication_count{in[sign_bit_location]}}, in};
endmodule