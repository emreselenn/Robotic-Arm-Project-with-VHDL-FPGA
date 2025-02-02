--YUNUS EMRE SELEN 151220202061

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    port (
        CLK   : in STD_LOGIC;
        BTN   : in STD_LOGIC;
        BTNDB : out STD_LOGIC
    );
end debouncer;

architecture debouncer of debouncer is
    signal CLK2 : std_logic := '0'; 
    constant MAXV : integer := 250000;
    signal cntr : integer range 0 to MAXV;
    signal SR : std_logic_vector(3 downto 0);
begin
    -- Process 1: Yeni clock üretme
    process(CLK) is
    begin
        if (rising_edge(CLK)) then
            if cntr = (MAXV-1) then
                cntr <= 0;
                CLK2 <= not CLK2;
            else
                cntr <= cntr + 1;
            end if;
        end if;
    end process;

    -- Process 2: Debouncer
    process(CLK2) is
    begin
        if (rising_edge(CLK2)) then
            SR <= SR(2 downto 0) & BTN;
            if SR = "0000" then
                BTNDB <= '0';
            elsif SR = "1111" then
                BTNDB <= '1';
            end if;
        end if;
    end process;
end debouncer;
