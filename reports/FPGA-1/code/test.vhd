library IEEE;
use IEEE.std_logic_1164.all;
entity test is 
	port(	
		sw_in   : in  std_logic;
		led_out : out std_logic);
end test;
architecture rtl of test is
begin
	led_out <= sw_in;
end rtl;