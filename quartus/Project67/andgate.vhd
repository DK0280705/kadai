library IEEE;
use IEEE.std_logic_1164.all;
entity andgate is
	port(	
		sw_in : in std_logic_vector(1 downto 0);
		led_out : out std_logic);
end andgate;
architecture rtl of andgate is
begin
		led_out <= sw_in(0) and sw_in(1);
end rtl;