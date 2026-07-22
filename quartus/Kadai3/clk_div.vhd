library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Needed for the counter vector math

entity clk_div is
    port (
        clk_in  : in  std_logic; -- 50 MHz input clock
        clk_out : out std_logic  -- Slow output clock
    );
end clk_div;

architecture rtl of clk_div is
    -- 25 bits is enough to count up to 25,000,000
    signal counter : unsigned(24 downto 0) := (others => '0');
    signal temporal: std_logic := '0';
begin
    process(clk_in) begin
        if rising_edge(clk_in) then
            if (counter = 24999999) then
                temporal <= not temporal; -- Toggle the slow clock state
                counter  <= (others => '0'); -- Reset counter
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temporal;
end rtl;