library IEEE;
use IEEE.std_logic_1164.all;

entity kadai3 is
	port(
		D, CLK : in  std_logic;
		Q, NQ  : out std_logic
	);
end kadai3;

architecture rtl of kadai3 is
begin
	process(CLK) begin
		if (CLK'event and CLK = '1') then
			Q  <= D;
			NQ <= not D;
		end if;
	end process;
end rtl;