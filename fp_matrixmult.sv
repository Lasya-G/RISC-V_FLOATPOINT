
`timescale 1ns/1ps
`include "fp_mul.sv"
`include "fp_add.sv"
module fp_matrix
#(parameter M = 2 ,parameter N =2,parameter P =2 )
  (
  input clk,
  input reg reset,

  input [0:3][31:0] a_in, // MxN matrix A
  input [0:3][31:0] b_in, // NxP matrix B

  output reg [0:3] [31:0] c_out // MxP result matrix C
);

reg [31:0]temp_ain;
reg [31:0]temp_bin;
wire  [31:0]fp_result;
wire [31:0] new_partial_sum;

reg [31:0] partial_sum=32'b0;

fp_mul mul(.clk(clk),.A(temp_ain),.B(temp_bin),.result(fp_result));
fp_add add(.clk(clk),.A(partial_sum),.B(fp_result),.result(new_partial_sum));


// reg [31:0] new_partial_sum;
integer i=0, j=0, k=0;
//integer i,j,k;
//integer M =2, N=2, P=2;
always @(posedge clk) begin
  if(reset) begin
    for(i=0; i<=M*P; i++) begin
        c_out[i] = 0; 
    end
    i=0;
  end 
  else begin
      if(i<M) begin
        if(j<P) 
        begin
          if(k<N) 
          begin
            temp_ain <=a_in[(i * N) + k];
            temp_bin <=b_in[(k * P)+ j];
            partial_sum = new_partial_sum;
            k=k+1;
          end
          else 
          begin
            k=0;
            c_out[(i*P)+j] = partial_sum;
            partial_sum = 0;
            j=j+1;                    
          end
        end
        else begin
          j=0;
          i=i+1;
        end
      i=0;
    end
     end
end

endmodule