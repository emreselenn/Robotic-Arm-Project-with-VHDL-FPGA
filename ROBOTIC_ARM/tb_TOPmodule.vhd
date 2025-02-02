
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY tb_TOPmodule IS
END tb_TOPmodule;
 
ARCHITECTURE behavior OF tb_TOPmodule IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP_MODULE
    PORT(
         pwm_out_rl : OUT  std_logic;
         pwm_out_ud : OUT  std_logic;
         pwm_out_fb : OUT  std_logic;
         pwm_out_oc : OUT  std_logic;
         CLK : IN  std_logic;
         switch1 : IN  std_logic;
         switch2 : IN  std_logic;
         east_button : IN  std_logic;
         west_button : IN  std_logic;
         south_button : IN  std_logic;
         north_button : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal switch1 : std_logic := '0';
   signal switch2 : std_logic := '0';
   signal east_button : std_logic := '0';
   signal west_button : std_logic := '0';
   signal south_button : std_logic := '0';
   signal north_button : std_logic := '0';

 	--Outputs
   signal pwm_out_rl : std_logic;
   signal pwm_out_ud : std_logic;
   signal pwm_out_fb : std_logic;
   signal pwm_out_oc : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP_MODULE PORT MAP (
          pwm_out_rl => pwm_out_rl,
          pwm_out_ud => pwm_out_ud,
          pwm_out_fb => pwm_out_fb,
          pwm_out_oc => pwm_out_oc,
          CLK => CLK,
          switch1 => switch1,
          switch2 => switch2,
          east_button => east_button,
          west_button => west_button,
          south_button => south_button,
          north_button => north_button
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		
		east_button <= '1' ; 
		      wait for CLK_period*10;
		east_button <= '0' ; 
		      wait for CLK_period*10;
		east_button <= '1' ; 
		      wait for CLK_period*10;
		east_button <= '0' ; 
		      wait for CLK_period*10;
		east_button <= '1' ; 
		      wait for CLK_period*10;
		east_button <= '0' ; 
		      wait for CLK_period*10;
		
		west_button <= '1' ; 
		      wait for CLK_period*10;
		west_button <= '0' ; 
		      wait for CLK_period*10;

      wait;
   end process;

END;
