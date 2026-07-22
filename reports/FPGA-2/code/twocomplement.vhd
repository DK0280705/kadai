library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twocomplement is
	port(
		input  : in  std_logic_vector(3 downto 0);
		output : out std_logic_vector(3 downto 0)
	);
end twocomplement;

architecture Behavioral of twocomplement is
begin
	output <= std_logic_vector(-signed(input));
end Behavioral;