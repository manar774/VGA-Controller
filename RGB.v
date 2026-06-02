module RGB( clk, rst, sw, video_on, red, green, blue);

input clk, rst, video_on;
input [2:0] sw;
output  reg red, green, blue;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		red <= 0;
		green <= 0;
		blue <= 0;
	end
	else begin
		{red, green, blue} <= {video_on & sw[2], video_on & sw[1], video_on & sw[0]};
	end
end

endmodule