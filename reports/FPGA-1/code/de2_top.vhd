library IEEE;
use IEEE.std_logic_1164.all;

entity de2_top is
	port (
		SW   : in  std_logic_vector(7 downto 0);
		LEDR : out std_logic_vector(7 downto 0)
	);
end entity de2_top;

architecture Structural of de2_top is
	component test is 
		port(	
			sw_in   : in  std_logic;
			led_out : out std_logic
		);
	end component;
	component andtest is
		port(
			sw_in1, sw_in2     : in  std_logic_vector(1 downto 0);
			led_out1, led_out2 : out std_logic
		);
	end component;
	component adder2bits is
		port (
			a : in  std_logic_vector(1 downto 0);
			b : in  std_logic_vector(1 downto 0);
			c : out std_logic_vector(2 downto 0)
		);
	end component;
begin
	mytest: test
		port map (
			sw_in   => SW(0),
			led_out => LEDR(0)
		);
	myandtest: andtest
		port map (
			sw_in1   => SW(2 downto 1),
			sw_in2   => SW(4 downto 3),
			led_out1 => LEDR(1),
			led_out2 => LEDR(2)
		);
	myadder2bits: adder2bits
		port map (
			a => SW(2 downto 1),
			b => SW(4 downto 3),
			c => LEDR(5 downto 3)
		);
end architecture Structural;