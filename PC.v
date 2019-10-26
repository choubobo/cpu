module PC(q,d,clk,en,clr);
input [31:0]d;
input clk;
input en;
input clr;
output reg [31:0] q;

always @(posedge clk) begin
		if(clr)
			begin
				q <= 32'b0;
			end
		else if(en)
			begin
				q <= d;
			end
	end
	
	endmodule
//genvar i;