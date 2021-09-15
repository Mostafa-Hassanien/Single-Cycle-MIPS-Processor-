//////////////////////////////////////////////////////////////////////////////////////
//                                  Module Description                              //
// Module Name: Control Unit                                                        //
// The Control Unit takes the 32-bit instruction and generates the appropriate      //
// signal values to control the flow of data throughout the datapath.               //
//////////////////////////////////////////////////////////////////////////////////////
module ControlUnit (
  //-------------------------------Input Ports--------------------------------------//
  input    wire   [31:0]    instruction,
  input    wire             alu_zero,
  input    wire             rst,
  //-------------------------------Output Ports-------------------------------------//
  output   reg    [3:0]     PC_control,
  output   reg              reg_file_rmux_select,
  output   reg              reg_file_wren,
  output   reg              alu_mux_select,
  output   reg    [4:0]     alu_shamt,
  output   reg    [3:0]     alu_control,
  output   reg    [3:0]     data_mem_wren,
  output   reg              reg_file_dmux_select
  );
  
// Internal Connections
wire   [5:0]     Op_Code;
wire   [5:0]     Function;

// Constant Parameters 
localparam R_Type_Instructions = 6'b000000;
// Arithmetic
localparam ADD                          = 6'b100000;
localparam ADD_UNSIGNED                 = 6'b100001;
localparam SUBTRACT                     = 6'b100010;
localparam SUBTRACT_UNSIGNED            = 6'b100011;
localparam ADD_IMMEDIATE                = 6'b001000;
localparam ADD_IMMEDIATE_UNSIGNED       = 6'b001001;

// Logical
localparam AND                          = 6'b100100;
localparam AND_IMMEDIATE                = 6'b001100;
localparam OR                           = 6'b100101;
localparam OR_IMMEDIATE                 = 6'b001101;
localparam XOR                          = 6'b100110;
localparam NOR                          = 6'b100111;
localparam SET_ON_LESS_THAN             = 6'b101010;
localparam SET_ON_LESS_THAN_IMMEDIATE   = 6'b001010;

// Shift
localparam SHIFT_LEFT_LOGICAL           = 6'b000000;
localparam SHIFT_RIGHT_LOGICAL          = 6'b000010;
localparam SHIFT_RIGHT_ARITHMETIC       = 6'b000011;

// Conditional Branch
localparam BRANCH_ON_EQUAL              = 6'b000100;
localparam BRANCH_ON_NOT_EQUAL          = 6'b000101;

// Unconditional Jumps
localparam JUMP                         = 6'b000010;
localparam JUMP_REGISTER                = 6'b001000;

// Data Transfer
localparam LOAD_WORD                    = 6'b100011;
localparam LOAD_UPPER_IMMEDIATE         = 6'b001111;
localparam STORE_WORD                   = 6'b101011;
localparam STORE_HALF_WORD              = 6'b101001;
localparam STORE_BYTE                   = 6'b101000;

assign Op_Code   = instruction[31:26];
assign Function  = instruction[5:0];

// Combinational Logic
always @(*)
  begin
    reg_file_rmux_select = 1'b1;
    alu_mux_select       = 1'b0;
    alu_control          = 4'b0;
    alu_shamt            = 4'b0;
    data_mem_wren        = 4'b0;
    reg_file_dmux_select = 1'b0;
    reg_file_wren        = 1'b0;
    PC_control           = 4'b0;
    case (Op_Code)
     // R-type instructions ----------------------------------------------------------------------
     R_Type_Instructions : begin
                              reg_file_rmux_select = 1'b1;
                              reg_file_dmux_select = 1'b1;
                              reg_file_wren        = 1'b1;
                              case (Function)
                                (AND)                    : alu_control = 4'b0000;
                                (OR)                     : alu_control = 4'b0001;
                                (XOR)                    : alu_control = 4'b0010;
                                (NOR)                    : alu_control = 4'b0011;
                                (ADD_UNSIGNED)           : alu_control = 4'b0100;
                                (ADD)                    : alu_control = 4'b0101;
                                (SUBTRACT_UNSIGNED)      : alu_control = 4'b0110;
                                (SUBTRACT)               : alu_control = 4'b0111;
                                (SET_ON_LESS_THAN)       : alu_control = 4'b1000;
                                (SHIFT_LEFT_LOGICAL)     : begin
                                                            alu_control = 4'b1001;
                                                            alu_shamt   = instruction[10:6];
                                                           end
                                (SHIFT_RIGHT_LOGICAL)    : begin
                                                            alu_control = 4'b1010;
                                                            alu_shamt   = instruction[10:6];
                                                           end
                                (SHIFT_RIGHT_ARITHMETIC) : begin
                                                            alu_control = 4'b1011;
                                                            alu_shamt   = instruction[10:6];
                                                           end
                                default                  : alu_control = 4'b0000;
                              endcase 
                            end
     // J-type instructions ----------------------------------------------------------------------                 
     BRANCH_ON_EQUAL                                : begin
                                                        if (alu_zero)
                                                            PC_control  = 4'b0011;
                                                        else
                                                            PC_control  = 4'b0000;
                                                      end
     BRANCH_ON_NOT_EQUAL                            : begin
                                                        if (~alu_zero)
                                                            PC_control  = 4'b0011;
                                                        else
                                                            PC_control  = 4'b0000;
                                                      end                                             
     JUMP                                           : begin
                                                        PC_control  = 4'b0001;
                                                      end
     JUMP_REGISTER                                  : begin
                                                        PC_control  = 4'b0010;
                                                      end
     // I-type instructions ----------------------------------------------------------------------
     ADD_IMMEDIATE                                  : begin
                                                        alu_control          = 4'b0101;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end
     ADD_IMMEDIATE_UNSIGNED                         : begin
                                                        alu_control          = 4'b0100;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end
     AND_IMMEDIATE                                  : begin
                                                        alu_control          = 4'b0000;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end
     OR_IMMEDIATE                                   : begin
                                                        alu_control          = 4'b0001;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end                                                                                                  
   SET_ON_LESS_THAN_IMMEDIATE                       : begin
                                                        alu_control          = 4'b1000;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end                                                                                                  
    LOAD_WORD                                       : begin
                                                        alu_control          = 4'b0100;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b0;
                                                        reg_file_wren        = 1'b1;
                                                      end    
    LOAD_UPPER_IMMEDIATE                            : begin
                                                        alu_control          = 4'b0100;
                                                        reg_file_rmux_select = 1'b0;
                                                        alu_mux_select       = 1'b1;
                                                        reg_file_dmux_select = 1'b1;
                                                        reg_file_wren        = 1'b1;
                                                      end   
    STORE_WORD                                      : begin
                                                        reg_file_wren        = 1'b0;
                                                        data_mem_wren        = 4'b1111;
                                                      end
    STORE_HALF_WORD                                 : begin
                                                        reg_file_wren        = 1'b0;
                                                        data_mem_wren        = 4'b0011;
                                                      end                                                  
    STORE_BYTE                                      : begin
                                                        reg_file_wren        = 1'b0;
                                                        data_mem_wren        = 4'b0001;
                                                      end         
    default                                         : begin
                                                        reg_file_rmux_select = 1'b1;
                                                        alu_mux_select       = 1'b0;
                                                        alu_control          = 4'b0;
                                                        alu_shamt            = instruction[10:6];
                                                        data_mem_wren        = 4'b0;
                                                        reg_file_dmux_select = 1'b0;
                                                        reg_file_wren        = 1'b0;
                                                        PC_control           = 4'b0;
                                                      end                                        
  endcase
end 
endmodule 
