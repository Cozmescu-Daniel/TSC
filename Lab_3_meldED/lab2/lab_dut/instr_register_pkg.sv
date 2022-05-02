/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter:
 * User-defined type definitions
 **********************************************************************/
package instr_register_pkg;
  //timeunit 1ns;

  typedef enum logic [3:0] {
  	ZERO,//zero
    PASSA,//val a
    PASSB,//val b
    ADD,//operatii
    SUB,
    MULT,
    DIV,
    MOD
  } opcode_t;//enumerare de opcodeuri de 4 biti

  typedef logic signed [31:0] operand_t;//un tip de data
  typedef logic signed [63:0] operand_r;//rezultatul

  typedef logic [4:0] address_t;
  
  typedef struct {
    opcode_t  opc;
    operand_t op_a;
    operand_t op_b;
    operand_r res;
  } instruction_t;//structura de date unde stocam opcode, operand a b result

endpackage: instr_register_pkg//se inchide package
