library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity roulette is
	port(
		CLK_50     : in std_logic;
		KEY, RESET : in std_logic;
		RESULT     : out std_logic_vector(3 downto 0)
	);
end roulette;

architecture rtl of roulette is
	type state_t is (IDLE, SPINNING, SLOWING);
	signal state : state_t := IDLE;
	
	signal intval : unsigned(3 downto 0) := "0000";
	
	constant FAST_LIMIT : integer := 2500000;
	constant STOP_LIMIT : integer := 20000000;
	constant DECEL_STEP : integer := 8000000;
	
	signal clk_counter : integer range 0 to 50000000 := 0;
	signal clk_limit   : integer range 0 to 50000000 := FAST_LIMIT;
begin
	process(CLK_50, RESET)
	begin
		if RESET = '0' then
			state <= IDLE;
			intval <= "0000";
			clk_counter <= 0;
			clk_limit <= FAST_LIMIT;
		elsif (CLK_50'event and CLK_50='1') then
			case state is
				when IDLE =>
					if KEY = '0' then
						state <= SPINNING;
						clk_counter <= 0;
						clk_limit <= FAST_LIMIT;
					end if;
				when SPINNING =>
					if clk_counter >= clk_limit then 
						clk_counter <= 0;
						intval <= intval + 1;
					else
						clk_counter <= clk_counter + 1;
					end if;
					if KEY = '1' then
						state <= SLOWING;
					end if;
				when SLOWING => 
					if clk_counter >= clk_limit then
						clk_counter <= 0;
						intval <= intval + 1;
						
						if clk_limit >= STOP_LIMIT then
							state <= IDLE;
						else
							clk_limit <= clk_limit + DECEL_STEP;
						end if;
					else
						clk_counter <= clk_counter + 1;
					end if;
					if KEY = '0' then
						state <= SPINNING;
						clk_limit <= FAST_LIMIT;
					end if;
			end case;
		end if;
	end process;
	RESULT <= std_logic_vector(intval);
end rtl;