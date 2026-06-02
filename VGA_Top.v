module VGA_Top( rst, clk, sw, red, green, blue, h_sync, v_sync );

input rst, clk;
input [2:0] sw;
output red, green, blue, h_sync,v_sync;

wire video_on;

RGB inst1(clk, rst, sw, video_on, red, green, blue);
VGA inst2(rst, clk, h_sync, v_sync, video_on);

endmodule