// 4-bit ALU
// (c) 2017 Warren Toomey, GPL3


module alu (
	input [3:0] A,		// First operand
	input [3:0] B,		// Second operand
	input [2:0] ALUop,	// ALU operation
	input Cin,		// Carry in
	input ALUbank,		// Which operation bank in use
	output reg [3:0] result,// ALU result
	output [3:0] flags	// NZVC flags
  );

  parameter DADD  = 0;         // A + B decimal
  parameter DSUB  = 1;         // A - B decimal
  parameter AND   = 2;         // A & B
  parameter OR    = 3;         // A | B
  parameter XOR   = 4;         // A ^ B
  parameter INCA  = 5;         // A + 1
  parameter BFLAGS = 6;        // 0, flags set to B's value
  parameter ZERO  = 7;         // 0
  parameter ADD   = 8;         // A + B binary
  parameter SUB   = 9;         // A - B binary
  parameter PASSA = 10;        // A
  parameter PASSB = 11;        // B
  parameter MULLO = 12;        // A * B binary, low nibble
  parameter MULHI = 13;        // A * B binary, high nibble
  parameter DIV   = 14;        // A / B binary
  parameter MOD   = 15;        // A % B binary

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

  always @* begin
    case (Op)
      DADD: begin				// Decimal ADD
	  temp_result= {1'd0, A} + {1'd0, B} + {4'd0, Cin};
  	  result= temp_result[3:0];
	  if (temp_result>9) begin
	    result= result - 10; C= 1;
	    end
	  else C= 0;
	  N= 0;
	  Z= (result==0) ? 1 : 0;
	  V= 0;
        end
      DSUB: begin				// Decimal SUB
	  temp_result= {1'd0, A} - {1'd0, B} - {4'd0, Cin};
  	  result= temp_result[3:0];
	  if (temp_result>9) begin
	    result= result - 10; C= 1;
	    end
	  else C= 0;
	  N= 0;
	  Z= (result==0) ? 1 : 0;
	  V= 0;
	end
      AND: begin
	  result= A & B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
          V= 0;
	end
      OR: begin
	  result= A | B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
          V= 0;
	end
      XOR: begin
	  result= A ^ B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
          V= 0;
	end
      INCA: begin
	  {C, result}= {1'd0, A} + 5'd1;
	  C= temp_result[4];
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      BFLAGS: begin
  	  result= 0;
	  {N, Z, V, C}= B;
	end
      ZERO: begin
	  temp_result= 0;			// XXX Why can't I lose
  	  result= 0;				// the temp_result= 0; line?
	  {N, Z, V, C}= 4'b0100;
	end
      ADD: begin
	  {C, result}= {1'd0, A} + {1'd0, B} + {4'd0, Cin};
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      SUB: begin
	  {C, result}= {1'd0, A} - {1'd0, B} - {4'd0, Cin};
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      PASSA: begin
	  result= A;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
          V= 0;
	end
      PASSB: begin
	  result= B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
          V= 0;
	end
      MULLO: begin
	  result= A * B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      MULHI: begin
	  result= A * B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      DIV: begin
	  result= A / B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
      MOD: begin
	  result= A % B;
	  C= 0;
	  N= result[3];
	  Z= (result==0) ? 1 : 0;
	  // Overflow: A & B sign same, result sign different
	  V= ((A[3]==B[3]) && (N!=A[3])) ? 1 : 0;
	end
    endcase
  end

  assign flags= {N, Z, V, C};

endmodule
