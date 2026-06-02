
`timescale 1ns / 1ps

module tb_vga_top;

    // Test bench signals
    reg clk;
    reg rst;
    reg [2:0] sw;
    wire red, green, blue;
    wire h_sync, v_sync;
    wire video_on;
    wire [9:0] h_counter;
    wire [9:0] v_counter;

    // Instantiate the top module
    VGA_Top dut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .red(red),
        .green(green),
        .blue(blue),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );

    // Access internal signals from vga_ctrl (inst2)
    assign h_counter = dut.inst2.h_counter;
    assign v_counter = dut.inst2.v_counter;
    assign video_on = dut.inst2.video_on;

    // Clock generation: 25.175 MHz ≈ 39.72 ns, use 40 ns for simplicity
    localparam CLK_PERIOD = 40;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test procedure
    initial begin
        rst = 1;
        sw = 3'b000;
        #100;

        // Test 1: Reset state
        $display("Test 1: Checking reset state...");
        if (h_sync !== 1 || v_sync !== 1 || video_on !== 0 ||
            red !== 0 || green !== 0 || blue !== 0 ||
            h_counter !== 0 || v_counter !== 0) begin
            $error("Reset failed: h_sync=%b, v_sync=%b, video_on=%b, red=%b, green=%b, blue=%b, h_counter=%d, v_counter=%d",
                   h_sync, v_sync, video_on, red, green, blue, h_counter, v_counter);
        end else begin
            $display("Test 1 passed: Reset state correct.");
        end

        // Release reset
        rst = 0;
        #100;

        // Test 2: RGB in visible area
        $display("Test 2: Checking RGB in visible area...");
        sw = 3'b100; // Red
        wait (h_counter == 320 && v_counter == 240); // Middle of visible area
        #CLK_PERIOD;
        if (video_on !== 1 || red !== 1 || green !== 0 || blue !== 0) begin
            $error("RGB failed at (320,240) sw=100: video_on=%b, red=%b, green=%b, blue=%b",
                   video_on, red, green, blue);
        end else begin
            $display("Test 2a passed: Red color correct.");
        end

        sw = 3'b011; // Cyan
        wait (h_counter == 500 && v_counter == 400);
        #CLK_PERIOD;
        if (video_on !== 1 || red !== 0 || green !== 1 || blue !== 1) begin
            $error("RGB failed at (500,400) sw=011: video_on=%b, red=%b, green=%b, blue=%b",
                   video_on, red, green, blue);
        end else begin
            $display("Test 2b passed: Cyan color correct.");
        end

        // Test 3: Blanking intervals
        $display("Test 3: Checking blanking intervals...");
        sw = 3'b111; // White
        // Back porch (h_counter = 746)
        wait (h_counter == 746);
        #CLK_PERIOD;
        if (video_on !== 0 || red !== 0 || green !== 0 || blue !== 0) begin
            $error("Blanking failed at h_counter=746: video_on=%b, red=%b, green=%b, blue=%b",
                   video_on, red, green, blue);
        end else begin
            $display("Test 3a passed: Back porch blanking correct.");
        end

        // Front porch (v_counter = 8)
        wait (v_counter == 8 && h_counter == 0);
        #CLK_PERIOD;
        if (video_on !== 0 || red !== 0 || green !== 0 || blue !== 0) begin
            $error("Blanking failed at v_counter=8: video_on=%b, red=%b, green=%b, blue=%b",
                   video_on, red, green, blue);
        end else begin
            $display("Test 3b passed: Front porch blanking correct.");
        end

        // Test 4: Sync pulse timing
        $display("Test 4: Checking sync pulse timing...");
        // Horizontal sync pulse
        wait (h_counter == 656); // Start of h_sync
        #CLK_PERIOD;
        if (h_sync !== 0) begin
            $error("h_sync failed at h_counter=656: h_sync=%b", h_sync);
        end else begin
            $display("Test 4a passed: h_sync low at start.");
        end
        wait (h_counter == 752); // End of h_sync
        #CLK_PERIOD;
        if (h_sync !== 1) begin
            $error("h_sync failed at h_counter=752: h_sync=%b", h_sync);
        end else begin
            $display("Test 4b passed: h_sync high at end.");
        end

        // Vertical sync pulse
        wait (v_counter == 490 && h_counter == 0); // Start of v_sync
        #CLK_PERIOD;
        if (v_sync !== 0) begin
            $error("v_sync failed at v_counter=490: v_sync=%b", v_sync);
        end else begin
            $display("Test 4c passed: v_sync low at start.");
        end
        wait (v_counter == 492 && h_counter == 0); // End of v_sync
        #CLK_PERIOD;
        if (v_sync !== 1) begin
            $error("v_sync failed at v_counter=492: v_sync=%b", v_sync);
        end else begin
            $display("Test 4c passed: v_sync high at end.");
        end

        // Test 5: Counter ranges
        $display("Test 5: Checking counter ranges...");
        wait (h_counter == 799 && v_counter == 524);
        #CLK_PERIOD;
        if (h_counter !== 0 || v_counter !== 0) begin
            $error("Counter reset failed: h_counter=%d, v_counter=%d", h_counter, v_counter);
        end else begin
            $display("Test 5 passed: Counters reset correctly.");
        end

        // Run for one more frame
        repeat (800 * 525) @(posedge clk);
        $display("Simulation completed successfully.");
        $finish;
    end

    // Monitor for debugging
    initial begin
        $monitor("Time=%0t rst=%b sw=%b h_counter=%d v_counter=%d h_sync=%b v_sync=%b video_on=%b red=%b green=%b blue=%b",
                 $time, rst, sw, h_counter, v_counter, h_sync, v_sync, video_on, red, green, blue);
    end

endmodule