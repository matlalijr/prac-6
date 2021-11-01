`timescale 1ns / 1ps
`include "ALU_Prac.v"
`include "CU.v"
`include "RegMem.v"

module simple_cpu( clk, rst, instruction, out);

    parameter DATA_WIDTH = 8; 
    parameter ADDR_BITS = 5; //32 Addresses
    parameter INSTR_WIDTH =20; 


    input [INSTR_WIDTH-1:0] instruction;
    input clk, rst;
    output wire [DATA_WIDTH-1:0] [0:3] out;

  
    wire [ADDR_BITS-1:0] addr_i;
    wire [DATA_WIDTH-1:0] data_in_i, data_out_i, result2_i ;
    wire wen_i; 
    

    wire [DATA_WIDTH-1:0]operand_a_i, operand_b_i, result1_i;
    wire [3:0]opcode_i;
    
   
    //Wire for connecting to CU
    wire [DATA_WIDTH-1:0]offset_i;
    wire sel1_i, sel3_i;
    wire [DATA_WIDTH-1:0] operand_1_i, operand_2_i;
    wire [DATA_WIDTH-1:0][0:3] Aout ;

    
    

    alu #(DATA_WIDTH) alu1 (clk, operand_a_i, operand_b_i, opcode_i, result1_i);
     
   
    reg_mem #(DATA_WIDTH,ADDR_BITS) data_memory(addr_i, data_in_i, wen_i, clk, data_out_i);
    
    
    CU  #(DATA_WIDTH,ADDR_BITS, INSTR_WIDTH) CU1(clk, rst, instruction, result2_i,
        operand_1_i, operand_2_i, offset_i, opcode_i, sel1_i, sel3_i, wen_i, Aout);
    

    
   
    assign operand_a_i = operand_1_i;
    assign operand_b_i = (sel3_i == 0) ? operand_2_i: (sel3_i == 1) ? offset_i : 8'bx;
    
  
    assign data_in_i = operand_2_i;
    
    assign result2_i = (sel1_i == 0) ? data_out_i : (sel1_i == 1) ? result1_i : 8'bx;  
    
    
    assign out = Aout;
endmodule