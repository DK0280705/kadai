library IEEE;
use IEEE.std_logic_1164.all;

entity st_man is
	port (
		RESET, CLK, X : in std_logic;
		Y             : out std_logic_vector(1 downto 0)
	);
end st_man;

architecture rtl of st_man is
type STATE is (STATE0, STATE1, STATE2);
signal IS_STATE, NE_STATE : STATE;
begin
	process(RESET, CLK) begin
		if (RESET='0') then
			IS_STATE <= STATE0;
		elsif (CLK'event and CLK='1') then
			IS_STATE <= NE_STATE;
		end if;
	end process;
	
	process(IS_STATE, X) begin
		case IS_STATE is
			when STATE0 =>
				Y <= "00";
				if (X='1') then
					NE_STATE <= STATE1;
				else
					NE_STATE <= STATE0;
				end if;
			when STATE1 =>
				Y <= "01";
				if (X='1') then
					NE_STATE <= STATE2;
				else
					NE_STATE <= STATE1;
				end if;
			when STATE2 =>
				Y <= "10";
				if (X='1') then
					NE_STATE <= STATE0;
				else
					NE_STATE <= STATE2;
				end if;
		end case;
	end process;
end rtl;
				