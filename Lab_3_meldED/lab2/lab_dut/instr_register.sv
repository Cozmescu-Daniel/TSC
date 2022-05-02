/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter
 *
 * An error can be injected into the design by invoking compilation with
 * the option:  +define+FORCE_LOAD_ERROR
 *
 **********************************************************************/
//De adaugat in package de instructionword un semnal numit result. tipul e def de noi. in dut in fc de ce tip de opcode de facut operatia corespunzatoare
//un switch in case avem un tip de operatie si result
module instr_register//modulul
import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
(input  logic          clk,//clock
 input  logic          load_en,//load enable permitem incarcarea de operanzi
 input  logic          reset_n,//resetam modulul
 input  operand_t      operand_a,
 input  operand_t      operand_b,
 input  opcode_t       opcode,//codul operatiei
 input  address_t      write_pointer,
 input  address_t      read_pointer,
 output instruction_t  instruction_word
);
  //timeunit 1ns;

  instruction_t  iw_reg [0:31];  // an array of instruction_word structures (stocheaza opcode, operand a, operand b, result)

  // write to the register
  always@(posedge clk, negedge reset_n)   // write into register (cand iesim din reset sa scrie in registru)
    if (!reset_n) begin//daca resetul nu e in 1(adica nu suntem in reset)
      foreach (iw_reg[i]) //pt fiecare iw_reg[i]
        iw_reg[i] = '{opc:ZERO,default:0};  // reset to all zeros (pune zero peste tot)
    end
    else if (load_en) begin//daca putem incarca in iw_reg
     
      case (opcode)
      PASSA : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, operand_a};//pasam operand a
      PASSB : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, operand_b};//pasam operand b
      ADD   : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, $signed(operand_a + operand_b)};//suma cu semn
      SUB   : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, $signed(operand_a - operand_b)};//scadere cu semn
      MULT  : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, $signed(operand_a * operand_b)};//inmultire cu semn
      DIV   : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, $signed(operand_a / operand_b)};//impartire cu semn
      MOD   : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, $signed(operand_a % operand_b)};//modulo cu semn
    default : iw_reg[write_pointer] = '{opcode, operand_a, operand_b, 'b0}; //pass 0
    endcase

    end

  // read from the register
  assign instruction_word = iw_reg[read_pointer];  // continuously read from register (citeste incontinuu din register) practic ca sa faca loop prin el

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force operand_b = operand_a; // cause wrong value to be loaded into operand_b
end
`endif

endmodule: instr_register
