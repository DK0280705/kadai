library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compare2bits is
	port (
		A : in  std_logic_vector(1 downto 0);
		B : in  std_logic_vector(1 downto 0);
		W : out std_logic;
		X : out std_logic;
		Y : out std_logic
	);
end compare2bits;

architecture Behavioral of compare2bits is
begin
	W <= '1' when (unsigned(A) > unsigned(B)) else '0';
	X <= '1' when (unsigned(A) = unsigned(B)) else '0';
	Y <= '1' when (unsigned(A) < unsigned(B)) else '0';
end Behavioral;