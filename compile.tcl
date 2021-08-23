vlib work
vcom ./fifo_async.vhd
vcom ./fifo_tb.vhd
#vsim -novopt -wlf /sim/t1 -wlfdeleteonquit work.fifo_async
#add wave sim:/fifo_sync/*
