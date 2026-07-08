library IEEE;
use IEEE.std_logic_1164.all;

entity de2_top is
	port (
		LEDR     : out std_logic_vector(15 downto 0);
		KEY      : in  std_logic_vector(3 downto 0);
		SW			: in  std_logic_vector(3 downto 0);
		CLOCK_50 : in  std_logic
	);
end de2_top;

architecture Structural of de2_top is
	component clk_div is
		port (
			clk_in  : in  std_logic;
			clk_out : out std_logic
		);
   end component;
	component kadai3 is
		port(
			D, CLK : in  std_logic;
			Q, NQ  : out std_logic
		);
	end component;
	component count10 is
		port(
			RESET, CLK : in  std_logic;
			Q          : out std_logic_vector(3 downto 0)
		);
	end component;
	component jkflipflop is
		port(
			J, K, CLK : in  std_logic;
			Q, NQ     : out std_logic
		);
	end component;
	component st_man4 is
		port (
			RESET, CLK, X : in  std_logic;
			Y             : out std_logic_vector(1 downto 0)
		);
	end component;
	signal slow_clock : std_logic;
begin
	my_clk_div : clk_div
		port map(
			clk_in  => CLOCK_50,
			clk_out => slow_clock
		);
	mycount10: count10
		port map(
			RESET => KEY(0),
			CLK   => slow_clock,
			Q     => LEDR(5 downto 2)
		);
	myjkflipflop: jkflipflop
		port map(
			J   => SW(0),
			K   => SW(1),
			CLK => slow_clock,
			Q   => LEDR(0),
			NQ  => LEDR(1)
		);
	myst_man4: st_man4
		port map(
			RESET => KEY(0),
			CLK   => slow_clock,
			X     => KEY(1),
			Y     => LEDR(8 downto 7)
		);
	LEDR(15) <= slow_clock;
end Structural;