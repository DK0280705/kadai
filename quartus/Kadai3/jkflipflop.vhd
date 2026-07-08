library IEEE;
use IEEE.std_logic_1164.all;

entity jkflipflop is
	port(
		J, K, CLK : in  std_logic;
		Q, NQ     : out std_logic
	);
end jkflipflop;

architecture rtl of jkflipflop is
	signal q_state : std_logic := '0';
begin
    process(CLK) begin
        if (CLK'event and CLK='1') then
            q_state <= (J and not q_state) or (not K and q_state);
        end if;
    end process;
	Q  <= q_state;
	NQ <= not q_state;
end rtl;