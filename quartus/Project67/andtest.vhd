library IEEE;
use IEEE.std_logic_1164.all;
entity andtest is 
	port(
		sw_in1, sw_in2     : in  std_logic_vector(1 downto 0);
		led_out1, led_out2 : out std_logic
	);
end andtest;
architecture rtl of andtest is
component andgate
	port(
		sw_in   : in  std_logic_vector(1 downto 0);
		led_out : out std_logic);
end component;
begin
	and1: andgate port map(sw_in => sw_in1,led_out => led_out1);
	and2: andgate port map(sw_in => sw_in2,led_out => led_out2);
end rtl;