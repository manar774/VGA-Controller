module VGA ( rst, clk, h_sync, v_sync, video_on);

input rst, clk;
output reg h_sync, v_sync, video_on;

reg [9:0] h_counter, v_counter;

localparam VISIBLE_AREA_H = 640;
localparam FRONT_PORCH_H = 16;
localparam SYNC_PULSE_H = 96;
localparam BACK_PORCH_H = 48;
localparam WHOLE_LINE_H = 800;

localparam VISIBLE_AREA_V = 480;
localparam FRONT_PORCH_V = 10;
localparam SYNC_PULSE_V = 2;
localparam BACK_PORCH_V = 33;
localparam WHOLE_FRAME_V = 525;

localparam h_sync_on = VISIBLE_AREA_H+FRONT_PORCH_H; //640+16
localparam v_sync_on = VISIBLE_AREA_V+FRONT_PORCH_V; //480+10
localparam h_sync_end = VISIBLE_AREA_H+FRONT_PORCH_H+SYNC_PULSE_H; //640+16+96
localparam v_sync_end = VISIBLE_AREA_V+FRONT_PORCH_V+SYNC_PULSE_V; //480+10+2

always @(posedge clk or posedge rst) begin
    if (rst) begin
        h_counter <= 10'd0;
        v_counter <= 10'd0;
        h_sync <= 1'b1;
        v_sync <= 1'b1;
        video_on <= 0;
    end else begin
        // Increment horizontal counter
        if (h_counter < WHOLE_LINE_H - 1) begin
            h_counter <= h_counter + 1;
        end else begin
            h_counter <= 10'd0; // Reset h_counter at end of line
            // Increment vertical counter
            if (v_counter < WHOLE_FRAME_V - 1) begin
                v_counter <= v_counter + 1;
            end else begin
                v_counter <= 10'd0; // Reset v_counter at end of frame
            end
        end

		h_sync <= (h_counter >= h_sync_on && h_counter < h_sync_end) ? 1'b0 : 1'b1;
        v_sync <= (v_counter >= v_sync_on && v_counter < v_sync_end) ? 1'b0 : 1'b1;
        video_on <= (h_counter < VISIBLE_AREA_H && v_counter < VISIBLE_AREA_V) ? 1'b1 : 1'b0;
    end
end

endmodule
