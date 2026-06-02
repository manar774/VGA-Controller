vlib work
vlog VGA.v  RGB.v VGA_tb.v VGA_Top.v 
vsim -voptargs=+acc work.tb_vga_top
add wave *
run -all
#quit -sim