// 4-bit ALU
// (c) 2017 Warren Toomey, GPL3

//  DADD  => 0,         # A + B decimal
//  DSUB  => 1,         # A - B decimal
//  AND   => 2,         # A & B
//  OR    => 3,         # A | B
//  XOR   => 4,         # A ^ B
//  INCA  => 5,         # A + 1
//  BFLAGS => 6,        # 0, flags set to B's value
//  ZERO  => 7,         # 0
//  ADD   => 8,         # A + B binary
//  SUB   => 9,         # A - B binary
//  PASSA => 10,        # A
//  PASSB => 11,        # B
//  MULLO => 12,        # A * B binary, low nibble
//  MULHI => 13,        # A * B binary, high nibble
//  DIV   => 14,        # A / B binary
//  MOD   => 15,        # A % B binary

module alu (
	input [3:0] A,		// First operand
	input [3:0] B,		// Second operand
	input [2:0] ALUop,	// ALU operation
	input Cin,		// Carry in
	input ALUbank,		// Which operation bank in use
	output [3:0] result,	// ALU result
	output [3:0] flags	// NZVC flags
  );

  // Temporary results for always code
  reg [4:0] temp_result;	// Top bit indicates carry
  reg N;
  reg Z;
  reg V;
  reg C;

  // Actual ALU operation
  wire [3:0] Op;
  assign Op[2:0] = ALUop;
  assign Op[3]   = ALUbank;

  /* verilator lint_off WIDTH */
  always @* begin
    case (Op)
      4'h0: begin				// Decimal ADD
	  temp_result= A + B + Cin;
	  if (temp_result>9)
	    begin temp_result= temp_result - 10; C= 1;
	    end
	  else C= 0;
	  N= 0;
	  Z= (temp_result==0) ? 1 : 0;
	  V= 0;
        end
      4'h1: begin				// Decimal SUB
	  temp_result= A - B - Cin;
	  if (temp_result>9)
	    begin temp_result= temp_result - 10; C= 1;
	    end
	  else C= 0;
	  N= 0;
	  Z= (temp_result==0) ? 1 : 0;
	  V= 0;
	end
      4'h2: begin
	  temp_result= A & B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
          V= 0;
	end
      4'h3: begin
	  temp_result= A | B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
          V= 0;
	end
      4'h4: begin
	  temp_result= A ^ B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
          V= 0;
	end
      4'h5: begin
	  temp_result= A + 1;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'h6: begin
	  temp_result= 0;
	  N= B[3]; Z= B[2]; V= B[1]; C= B[0];
	end
      4'h7: begin
	  temp_result= 0;
	  C= 0;
	  N= 0;
	  Z= 1;
          V= 0;
	end
      4'h8: begin
	  temp_result= A + B + Cin;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'h9: begin
	  temp_result= A - B - Cin;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'ha: begin
	  temp_result= A;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
          V= 0;
	end
      4'hb: begin
	  temp_result= B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
          V= 0;
	end
      4'hc: begin
	  temp_result= A * B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'hd: begin
	  temp_result= A * B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'he: begin
	  temp_result= A / B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
      4'hf: begin
	  temp_result= A % B;
	  C= temp_result[4];
	  N= temp_result[3];
	  Z= (temp_result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (temp_result[3]!=A[3])) ? 1 : 0;
	end
    endcase
  end

  assign result= temp_result;
  assign flags[3]= N;
  assign flags[2]= Z;
  assign flags[1]= V;
  assign flags[0]= C;
  /* verilator lint_on WIDTH */

endmodule
