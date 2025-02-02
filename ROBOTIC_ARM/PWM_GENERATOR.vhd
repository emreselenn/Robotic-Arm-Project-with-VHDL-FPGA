library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PWM_GENERATOR is
generic( 
     clk_freq : integer := 50_000_000; -- 50 MHz system clock - 20 ns period
     pwm_freq : integer := 50 --  20 ms period - 50 Hz PWM frequency
);
port(
    clk         : in std_logic;
	 duty_cycle  : in std_logic_vector(16 downto 0);
    pwm_o       : out std_logic
); 
end PWM_GENERATOR;

architecture PWM_GENERATOR of PWM_GENERATOR is
    constant MAXV    : integer := clk_freq / pwm_freq; -- PWM counter max value = 1000000 (1 milyon)
    signal cntr      : integer range 0 to MAXV := 0; -- PWM counter
    signal high_time : integer range 25000 to 125000 := 25000; -- Default initial value	 
begin

    -- PWM Sinyali Üretimi
    process(clk) is begin
        if rising_edge(clk) then
		  
			high_time <= TO_INTEGER(UNSIGNED(duty_cycle));
			
            if cntr = MAXV - 1 then
                cntr <= 0;
            else
                cntr <= cntr + 1;
            end if;

            if cntr < high_time then
                pwm_o <= '1';
            else
                pwm_o <= '0';
            end if;
        end if;
    end process;
end PWM_GENERATOR;