/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  //timeunit 1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

 tb_ifc intflab (.clk(test_clk));//instantiez interfata
 instr_register_test test (.intflab(intflab));
  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(intflab.load_en),
    .reset_n(intflab.reset_n),
    .operand_a(intflab.operand_a),
    .operand_b(intflab.operand_b),
    .opcode(intflab.opcode),
    .write_pointer(intflab.write_pointer),
    .read_pointer(intflab.read_pointer),
    .instruction_word(intflab.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0; //clock primeste clock negat
    forever #5  clk = ~clk; //o data la 5 secunde
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top