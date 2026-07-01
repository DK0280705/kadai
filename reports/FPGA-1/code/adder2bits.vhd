library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder2bits is
	port (
		a : in  std_logic_vector(1 downto 0);
		b : in  std_logic_vector(1 downto 0);
		c : out std_logic_vector(2 downto 0)
	);
end entity adder2bits;

architecture Behavioral of adder2bits is
begin
	c <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
end architecture Behavioral;