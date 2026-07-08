library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity count10 is
	port(
		RESET, CLK : in  std_logic;
		Q          : out std_logic_vector(3 downto 0)
	);
end count10;

architecture rtl of count10 is
signal TQ : std_logic_vector(3 downto 0);
begin
	process (RESET, CLK) begin
		if (RESET = '0') then
			TQ <= "0000";
		elsif (CLK'event and CLK='1') then
			if (TQ = "1001") then
				TQ <= "0000";
			else
				TQ <= TQ + '1';
			end if;
		end if;
	end process;
	Q <= TQ;
end rtl;