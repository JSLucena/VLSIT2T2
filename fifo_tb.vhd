library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fifo_tb is
end fifo_tb;

architecture fifo_tb of fifo_tb is

	signal clk_faster : std_logic := '0';
	signal clk_slower : std_logic := '0';
	signal rst : std_logic := '1';
	signal wr_en :std_logic := '0';
	signal rd_en : std_logic := '0';
	
	signal sts_error : std_logic := '0';
	signal sts_full : std_logic := '0';
	signal sts_high : std_logic := '0';
	signal sts_low : std_Logic := '0';
	signal sts_empty : std_Logic := '0';
	
	signal wr_data : std_logic_vector(7 downto 0) := x"00";
	signal rd_data : std_logic_vector(7 downto 0) := x"00";
	
	
	
	------ Sinais do TB -----------------
	signal stop_wr , stop_rd : std_logic;
	
begin

	rst <= '0' after 50 ns, '1' after 1000 ns, '0' after 1100 ns;



---#### WRITE_CLOCK > READ_CLOCK	
	DUV : entity work.fifo_async port map(
	wr_clk=>clk_faster, rd_clk=>clk_slower, rst=>rst, wr_en=>wr_en, rd_en=>rd_en,
	sts_error=>sts_error, sts_full=>sts_full, sts_high=>sts_high, sts_low=>sts_low, sts_empty=>sts_empty,
	wr_data=>wr_data,
	rd_data=>rd_data	);
--##############################


--######## WRITE_CLOCK < READ_CLOCK 	
--	DUV : entity work.fifo_async port map(
--	wr_clk=>clk_slower, rd_clk=>clk_faster, rst=>rst, wr_en=>wr_en, rd_en=>rd_en,
--	sts_error=>sts_error, sts_full=>sts_full, sts_high=>sts_high, sts_low=>sts_low, sts_empty=>sts_empty,
--	wr_data=>wr_data,
--	rd_data=>rd_data	); 
--###############################
	
	
	
	
	clock_gen_faster : process -- 50MHz + 25ppm
	begin
		clk <= '1';
		wait for 19999.9 ps;
		clk <= '0';
		wait for 19999.9 ps;
	end process clock_gen;
	
	clock_gen_slower : process -- 50MHz - 25ppm
	begin
		clk <= '1';
		wait for 20000.1 ps;
		clk <= '0';
		wait for 20000.1 ps;
	end
	
	stop_wr <= '1', '0' after 1200 ns;
	--stop_rd <= '0', '1' after 140 ns , '0' after 600 ns; --##teste LOW wr_pointer > rd_pointer
	--stop_rd <= '0', '1' after 240 ns , '0' after 600 ns; --##teste LOW wr_pointer < rd_pointer
	stop_rd <= '0', '1' after 440 ns , '0' after 1200 ns; --##teste HIGH
	
	write_process : process
	begin
		
		if stop_wr = '1' then
			wr_en <= not wr_en;
			wr_data <= wr_data + '1';
			wait for 40 ns;
		else
			wr_en <= '0';
			wr_data <= wr_data + '1';
			wait for 40 ns;
		end if;
	
	end process write_process;
	
	read_process : process
	begin
		if stop_rd = '1' then
			rd_en <= not rd_en;

			wait for 20 ns;
		else
			rd_en <= '0';
			wait for 20 ns;
		end if;
	end process read_process;
	
end fifo_tb;
