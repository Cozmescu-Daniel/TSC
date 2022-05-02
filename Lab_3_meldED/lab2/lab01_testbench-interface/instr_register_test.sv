/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/
//virtual tb_ifc.TEST inflab;

module instr_register_test 
  import instr_register_pkg::*;
  (
  tb_ifc.TEST intflab
  );
 // int seed = 555; //seed reprezinta valoarea initiala cu care se incepe randomizarea





  class first_test;
  virtual tb_ifc.TEST intflab;
  parameter genOperations=5;



covergroup cover_gr;
OP_Acover:coverpoint intflab.cb.operand_a{
  bins op_a_values_neg[7]={[-15:-1]};
  bins op_a_values_zero={0};
  bins op_a_values_pos[]={[1:15]};
}
OP_Bcover:coverpoint intflab.cb.operand_b{
  bins op_b_values[]={[0:15]};
}
OP_CODEcover:coverpoint intflab.cb.opcode{
  bins op_code_values[]={[0:7]};
}
//tema
REScover:coverpoint intflab.cb.instruction_word.res{
bins results_values[]={[-225:225]};
}
endgroup

function new(virtual tb_ifc.TEST manio) ; //constructor 
 intflab=manio;
 cover_gr=new();
endfunction;

  //initial begin//timp semnal zero
   task run();
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");
    $display(  "**************************HEADER***************************\n");
//Dif intre task si fc, in task se pot pune valori temporale (@ posedge etc)

    $display("\nReseting the instruction register...");//initializare + reset de dut
    intflab.cb.write_pointer  <= 5'h00;         // initialize write pointer
    intflab.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    intflab.cb.load_en        <= 1'b0;          // initialize load control line
    intflab.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @intflab.cb;     // hold in reset for 2 clock cycles
    intflab.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

//ne pune valori pt a fi procesate op a op b op c
    $display("\nWriting values to register stack...");
    @intflab.cb intflab.cb.load_en <= 1'b1;  // enable writing to register
    repeat (genOperations) begin
      @intflab.cb randomize_transaction;
      @intflab.cb print_transaction;
      cover_gr.sample();
    end
    @intflab.cb intflab.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
//    for (int i=10; i>=0; i--) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      repeat(genOperations) begin//itereaza prin valorile salvate si print rezultat
        @intflab.cb intflab.cb.read_pointer <= $unsigned($random)%10;//read pointer e adresa uunde sunt localizate valorile de mai sus
      // the expected values to be read back
    // @intflab.cb intflab.cb.read_pointer <= i;
    //functia are timp de simulare 0, taskul contine timp de simulare
      @intflab.cb  print_results;
      cover_gr.sample();
    end

     @intflab.cb ;
    
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $display(  "**************************FOOTER***************************\n");

    $finish;
  //end
  endtask 
//inafara de initial begin intra tot in clasa, fc taskuri interfata si var interne


  function void randomize_transaction;//adauga valori random in memorie
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    intflab.cb.operand_a     <= $signed($urandom)%16;                 // between -15 and 15
    intflab.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    intflab.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    intflab.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;//printeaza valorile
    $display("Writing to register location %0d: ", intflab.cb.write_pointer);
    $display("  opcode = %0d (%s)", intflab.cb.opcode, intflab.cb.opcode.name);
    $display("  operand_a = %0d",   intflab.cb.operand_a);
    $display("  operand_b = %0d\n", intflab.cb.operand_b);
  endfunction: print_transaction

  function void print_results;//printeaza rezultatul
    $display("Read from register location %0d: ", intflab.cb.read_pointer);
    $display("  opcode = %0d (%s)", intflab.cb.instruction_word.opc, intflab.cb.instruction_word.opc.name);//accesam semnal din package (intra in test deoarece e input
    $display("  operand_a = %0d",   intflab.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", intflab.cb.instruction_word.op_b);
    $display("  result    = %0d\n", intflab.cb.instruction_word.res);
  endfunction: print_results

 
  
    endclass 


initial begin
    first_test fs; //clasa first_test obiect fs ( clasa)
    fs = new(intflab); //am atribuit interfata obiectului
    fs.run();//apelam taskul de run
   // run();
  end
  //random stabila pe thread urandom stabil pe clasa
  
endmodule: instr_register_test