library IEEE;
use IEEE.std_logic_1164.all;

entity de2_top is
	port (
		SW   : in  std_logic_vector(16 downto 0);
		LEDR : out std_logic_vector(16 downto 0);
		HEX0 : out std_logic_vector(6 downto 0);
		HEX1 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX3 : out std_logic_vector(6 downto 0)
	);
end entity de2_top;

architecture Structural of de2_top is
	component adder2bits is
		port (
			a : in  std_logic_vector(1 downto 0);
			b : in  std_logic_vector(1 downto 0);
			c : out std_logic_vector(2 downto 0)
		);
	end component;
	component hex2seg7 is
		port (
			hex  :  in  std_logic_vector(3 downto 0);
			seg  :  out std_logic_vector(6 downto 0);
			seg_2:  out std_logic_vector(6 downto 0)
		);
	end component;
	component compare2bits is
		port (
			A : in  std_logic_vector(1 downto 0);
			B : in  std_logic_vector(1 downto 0);
			W : out std_logic;
			X : out std_logic;
			Y : out std_logic
		);
	end component;
	component twocomplement is
		port(
			input  : in  std_logic_vector(3 downto 0);
			output : out std_logic_vector(3 downto 0)
		);
	end component;
	component adder4bits is
		port(
			a  : in  std_logic_vector(3 downto 0);
			b  : in  std_logic_vector(3 downto 0);
			c  : out std_logic_vector(4 downto 0)
		);
	end component;
	
   signal adder4_out  : std_logic_vector(4 downto 0);
	
begin
	myadder2bits: adder2bits
		port map(
			a => SW(1 downto 0),
			b => SW(3 downto 2),
			c => LEDR(2 downto 0)
		);
	hex2seg7_1: hex2seg7
		port map(
			hex => SW(3 downto 0),
			seg => HEX0
		);
	hex2seg7_2: hex2seg7
		port map(
			hex => SW(7 downto 4),
			seg => HEX1
		);
	mycompare2bits: compare2bits
		port map(
			A => SW(9 downto 8),
			B => SW(11 downto 10),
			W => LEDR(10),
			X => LEDR(9),
			Y => LEDR(8)
		);
	mytwocomplement: twocomplement
		port map(
			input  => SW(15 downto 12),
			output => LEDR(15 downto 12)
		);

	myadder4bits: adder4bits
		port map(
			a => SW(3 downto 0),
			b => SW(7 downto 4),
			c => adder4_out
		);
	displayadder4_1: hex2seg7
		port map(
			hex => adder4_out(3 downto 0),
			seg => HEX2
		);
	displayadder4_2: hex2seg7
		port map(
			hex => "000" & adder4_out(4),
			seg => HEX3
		);
end architecture Structural;