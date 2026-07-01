library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder4bits is
	port(
		a : in  std_logic_vector(3 downto 0);
		b : in  std_logic_vector(3 downto 0);
		c : out std_logic_vector(4 downto 0)
	);
end adder4bits;

architecture Behavioral of adder4bits is
begin
	c <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
end Behavioral;