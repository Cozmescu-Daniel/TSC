/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc (input logic clk);
  //timeunit 1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // ADD CODE TO DECLARE THE INTERFACE SIGNALS
	 // interconnecting signals
  logic          load_en;
  logic          reset_n;
  opcode_t       opcode;
  operand_t      operand_a, operand_b;
  address_t      write_pointer, read_pointer;
  instruction_t  instruction_word;

clocking cb @(posedge clk);
input reset_n;
input load_en;
input read_pointer;

endclocking

modport test (clocking cb,output rst);
modport tb(
  output  logic          clk,
 output  logic          load_en,
 output  logic          reset_n,
 output  operand_t      operand_a,
 output  operand_t      operand_b,
 output  opcode_t       opcode,
 output  address_t      write_pointer,
 output  address_t      read_pointer,
 input instruction_t  instruction_word);
  // instantiate testbench and connect ports
  


endinterface: tb_ifc

