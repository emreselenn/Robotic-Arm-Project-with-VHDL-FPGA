
 -- Author Name: Yunus Emre Selen
 -- Project Name: 4 Axis Robotic Arm with Servo Motors
 -- Univerity: Eskiþherir Osmangazi Univerity
 -- Department: E.E.E
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_MODULE is port(
   pwm_out_rl           : out std_logic;
	pwm_out_ud           : out std_logic;
	pwm_out_fb           : out std_logic;
	pwm_out_oc           : out std_logic;
	HS							: out std_logic;
	VS							: out std_logic;
	RGB						: out std_logic_vector(0 to 2);
	CLK                  : in 	std_logic;
	switch2     			: in 	std_logic;
	switch3              : in  std_logic;
	switch4     			: in 	std_logic;
	rot_button   			: in 	std_logic;
	east_button 			: in 	std_logic;
	west_button 			: in 	std_logic;
	south_button 			: in 	std_logic;
	north_button 			: in 	std_logic);
end TOP_MODULE;

architecture TOP_MODULE of TOP_MODULE is

	component debouncer is
    port (
        CLK   : in STD_LOGIC;
        BTN   : in STD_LOGIC;
        BTNDB : out STD_LOGIC
    );
	end component;
	
	component PWM_GENERATOR is
	generic( 
		  clk_freq : integer := 50_000_000; -- 50 MHz system clock - 20 ns period
		  pwm_freq : integer := 50 --  20 ms period - 50 Hz PWM frequency
	);
	port(
		 clk         : in std_logic;
		 duty_cycle  : in std_logic_vector(16 downto 0);
		 pwm_o       : out std_logic
	); 
	end component;
	
	component clock_divider is port(
     CLK : in std_logic; -- 50M Hz System clock
	  CLK_NEW : out std_logic --  new clock
	  );    
	end component;
	
	component vga_display is port(
	  CLK    		: in  STD_LOGIC;
	  Speed_rl    	: in STD_LOGIC_VECTOR(2 downto 0);
	  Speed_ud    	: in STD_LOGIC_VECTOR(2 downto 0);
	  Speed_oc    	: in STD_LOGIC_VECTOR(2 downto 0);
	  Speed_fb    	: in STD_LOGIC_VECTOR(2 downto 0);
	  Angle_rl 		: in  integer;
	  Angle_ud 		: in  integer;
	  Angle_oc 		: in  integer;
	  Angle_fb 		: in  integer;
	  HS, VS 		: out STD_LOGIC;
	  RGB    		: out STD_LOGIC_VECTOR(0 to 2));
	end component;
	
	
	signal east_button_debounced                       : std_logic := '0';
	signal west_button_debounced   						   : std_logic := '0';
	signal south_button_debounced  						   : std_logic := '0';
	signal north_button_debounced  						   : std_logic := '0';
	signal rot_button_debounced  		    				   : std_logic := '0';
	signal rot_button_prev      		    				   : std_logic := '0';
	signal duty_cycle_rl, duty_cycle_ud					   : std_logic_vector(16 downto 0) := (others => '0');
	signal duty_cycle_fb, duty_cycle_oc 					: std_logic_vector(16 downto 0) := (others => '0');
	signal duty_cycle_rl_int									: integer range 25000 to 125000 := 75000;
	signal duty_cycle_ud_int									: integer range 25000 to 125000 := 75000;
	signal duty_cycle_fb_int									: integer range 25000 to 125000 := 75000;
	signal duty_cycle_oc_int 									: integer range 25000 to 125000 := 75000;
	signal CLK2													   : std_logic := '0';
	
	signal modef4_rl                       : std_logic := '0'; 
	signal modef3_rl   						   : std_logic := '0'; 
	signal modef2_rl						      : std_logic := '0'; 
	signal modes4_rl  						   : std_logic := '0'; 
	signal modes3_rl   						   : std_logic := '0'; 
	signal modes2_rl  						   : std_logic := '0'; 
	
	signal modef4_ud                       : std_logic := '0'; 
	signal modef3_ud   						   : std_logic := '0'; 
	signal modef2_ud  						   : std_logic := '0'; 
	signal modes4_ud  						   : std_logic := '0'; 
	signal modes3_ud   						   : std_logic := '0'; 
	signal modes2_ud  						   : std_logic := '0';
	
	signal modef4_oc                       : std_logic := '0'; 
	signal modef3_oc   						   : std_logic := '0'; 
	signal modef2_oc  						   : std_logic := '0'; 
	signal modes4_oc  						   : std_logic := '0'; 
	signal modes3_oc   						   : std_logic := '0'; 
	signal modes2_oc  						   : std_logic := '0';
	
	signal modef4_fb                       : std_logic := '0'; 
	signal modef3_fb   						   : std_logic := '0'; 
	signal modef2_fb  						   : std_logic := '0'; 
	signal modes4_fb  						   : std_logic := '0'; 
	signal modes3_fb   						   : std_logic := '0'; 
	signal modes2_fb  						   : std_logic := '0';
	
	signal fast_cntr_rl                    : integer range 0 to 3 := 0;
	signal slow_cntr_rl                    : integer range 0 to 3 := 0;
	
	signal fast_cntr_ud                    : integer range 0 to 3 := 0;
	signal slow_cntr_ud                    : integer range 0 to 3 := 0;
	
	signal fast_cntr_oc                    : integer range 0 to 3 := 0;
	signal slow_cntr_oc                    : integer range 0 to 3 := 0;
	
	signal fast_cntr_fb                    : integer range 0 to 3 := 0;
	signal slow_cntr_fb                    : integer range 0 to 3 := 0;
	
	signal Speed_rl                        : std_logic_vector(2 downto 0);
	signal Speed_ud                        : std_logic_vector(2 downto 0);
	signal Speed_fb                        : std_logic_vector(2 downto 0);
	signal Speed_oc                        : std_logic_vector(2 downto 0);
	
	
begin
   rot_button_deb : debouncer port map(
	CLK => CLK,
	BTN => rot_button,
	BTNDB => rot_button_debounced);
	
   east_button_deb : debouncer port map(
	CLK => CLK,
	BTN => east_button,
	BTNDB => east_button_debounced);
	
	west_button_deb : debouncer port map(
	CLK => CLK,
	BTN => west_button,
	BTNDB => west_button_debounced);
	
	north_button_deb : debouncer port map(
	CLK => CLK,
	BTN => north_button,
	BTNDB => north_button_debounced);
	
	south_button_deb : debouncer port map(
	CLK => CLK,
	BTN => south_button,
	BTNDB => south_button_debounced);
	
	right_left_servo : PWM_GENERATOR port map(
	CLK => CLK,
	duty_cycle => duty_cycle_rl,
	pwm_o => pwm_out_rl);
	
	up_down_servo : PWM_GENERATOR port map(
	CLK => CLK,
	duty_cycle => duty_cycle_ud,
	pwm_o => pwm_out_ud);
	
	forward_backward_servo : PWM_GENERATOR port map(
	CLK => CLK,
	duty_cycle => duty_cycle_fb,
	pwm_o => pwm_out_fb);
	
	open_close_servo : PWM_GENERATOR port map(
	CLK => CLK,
	duty_cycle => duty_cycle_oc,
	pwm_o => pwm_out_oc);
	
	CLK_INST : clock_divider port map(
	CLK => CLK,
	CLK_NEW => CLK2);
	
	VGA : vga_display port map(
	CLK => CLK,
	Speed_rl =>  Speed_rl,
	Speed_ud =>  Speed_ud,
	Speed_oc =>  Speed_oc,
	Speed_fb =>  Speed_fb,
	Angle_rl =>  duty_cycle_rl_int,
	Angle_ud =>  duty_cycle_ud_int,
	Angle_oc =>  duty_cycle_oc_int,
	Angle_fb =>  duty_cycle_fb_int,
	HS => HS,
	VS => VS,
	RGB => RGB); 
	
	duty_cycle_rl <= std_logic_vector(to_unsigned(duty_cycle_rl_int, 17));
	duty_cycle_ud <= std_logic_vector(to_unsigned(duty_cycle_ud_int, 17));
	duty_cycle_fb <= std_logic_vector(to_unsigned(duty_cycle_fb_int, 17));
	duty_cycle_oc <= std_logic_vector(to_unsigned(duty_cycle_oc_int, 17));
	
	process(CLK2) is begin
		if(rising_edge(clk2)) then
		  if(switch2 = '0') then
					
					if(duty_cycle_rl_int <= 25000) then
						duty_cycle_rl_int <= 25001;
					elsif(duty_cycle_rl_int >= 125000) then
						duty_cycle_rl_int <= 124999;
					elsif(duty_cycle_ud_int <= 25000) then
						duty_cycle_ud_int <= 25001;
					elsif(duty_cycle_ud_int >= 125000) then
						duty_cycle_ud_int <= 124999;
					else 
					-- rl motor için 
						if(east_button_debounced = '1') then
							if(modef4_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +48;
							elsif(modef3_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +36;
							elsif(modef2_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +24;
							elsif(modes2_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +6;
							elsif(modes3_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +4;
							elsif(modes4_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int +1;
							else 
							   duty_cycle_rl_int <= duty_cycle_rl_int +12;
							end if;
							
						elsif(west_button_debounced = '1') then
							if(modef4_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -48;
							elsif(modef3_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -36;
							elsif(modef2_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -24;
							elsif(modes2_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -6;
							elsif(modes3_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -4;
							elsif(modes4_rl = '1') then
								duty_cycle_rl_int <= duty_cycle_rl_int -1;
							else 
							   duty_cycle_rl_int <= duty_cycle_rl_int -12;
							end if;
						end if;
					--ud motor için
						if(north_button_debounced = '1') then
							if(modef4_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +48;
							elsif(modef3_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +36;
							elsif(modef2_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +24;
							elsif(modes2_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +6;
							elsif(modes3_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +4;
							elsif(modes4_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int +1;
							else 
							   duty_cycle_ud_int <= duty_cycle_ud_int +12;
							end if;
						elsif(south_button_debounced = '1') then
							if(modef4_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -48;
							elsif(modef3_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -36;
							elsif(modef2_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -24;
							elsif(modes2_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -6;
							elsif(modes3_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -4;
							elsif(modes4_ud = '1') then
								duty_cycle_ud_int <= duty_cycle_ud_int -1;
							else 
							   duty_cycle_ud_int <= duty_cycle_ud_int -12;
							end if;
						end if;
					end if;
			elsif(switch2 = '1') then
					
					
					if(duty_cycle_fb_int <= 25000) then
						duty_cycle_fb_int <= 25001;
					elsif(duty_cycle_fb_int >= 125000) then
						duty_cycle_fb_int <= 124999;
					elsif(duty_cycle_oc_int <= 25000) then
						duty_cycle_oc_int <= 25001;
					elsif(duty_cycle_oc_int >= 125000) then
						duty_cycle_oc_int <= 124999;
					else 
			--fb buton için		

						if(east_button_debounced = '1') then
							if(modef4_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +48;
							elsif(modef3_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +36;
							elsif(modef2_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +24;
							elsif(modes2_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +6;
							elsif(modes3_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +4;
							elsif(modes4_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int +1;
							else 
							   duty_cycle_fb_int <= duty_cycle_fb_int +12;
							end if;
						elsif(west_button_debounced = '1') then
							if(modef4_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -48;
							elsif(modef3_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -36;
							elsif(modef2_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -24;
							elsif(modes2_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -6;
							elsif(modes3_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -4;
							elsif(modes4_fb = '1') then
								duty_cycle_fb_int <= duty_cycle_fb_int -1;
							else 
							   duty_cycle_fb_int <= duty_cycle_fb_int -12;
							end if;
						end if;
						
						-- oc motor için
						if(north_button_debounced = '1') then
							if(modef4_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +48;
							elsif(modef3_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +36;
							elsif(modef2_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +24;
							elsif(modes2_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +6;
							elsif(modes3_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +4;
							elsif(modes4_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int +1;
							else 
							   duty_cycle_oc_int <= duty_cycle_oc_int +12;
							end if;
						elsif(south_button_debounced = '1') then
							if(modef4_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -48;
							elsif(modef3_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -36;
							elsif(modef2_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -24;
							elsif(modes2_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -6;
							elsif(modes3_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -4;
							elsif(modes4_oc = '1') then
								duty_cycle_oc_int <= duty_cycle_oc_int -1;
							else 
							   duty_cycle_oc_int <= duty_cycle_oc_int -12;
							end if;
						end if;
					end if;
			 
							
			end if;		
		end if; --rising edge		
	end process;

   P_SPEED : process(clk) is begin
		if(rising_edge(clk)) then		
			rot_button_prev <= rot_button_debounced;
			if((rot_button_prev = '0') and (rot_button_debounced = '1')) then						
				if((switch4 = '1') and (switch3 = '0') and (switch2 = '0')) then --rl servo fast mode
				   slow_cntr_rl <= 0;
					fast_cntr_rl <= fast_cntr_rl +1;
					if(fast_cntr_rl = 3) then
						fast_cntr_rl <= 0;
						modef4_rl <= '1'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						
					elsif(fast_cntr_rl = 0) then
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						
					elsif(fast_cntr_rl = 1) then 
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '1';
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						
					elsif(fast_cntr_rl = 2) then
						modef4_rl <= '0'; 
						modef3_rl <= '1'; 
						modef2_rl <= '0';
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						
					end if;
				elsif(switch4 = '0' and switch3 = '0' and switch2 = '0') then --rl slow mode
				   fast_cntr_rl <= 0;
					slow_cntr_rl <= slow_cntr_rl + 1;
					if(slow_cntr_rl = 3) then
						slow_cntr_rl <= 0;
						modes4_rl <= '1'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						
					elsif(slow_cntr_rl = 0) then
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '0';
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						
					elsif(slow_cntr_rl = 1) then
						modes4_rl <= '0'; 
						modes3_rl <= '0'; 
						modes2_rl <= '1';
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						
					elsif(slow_cntr_rl = 2) then
						modes4_rl <= '0'; 
						modes3_rl <= '1'; 
						modes2_rl <= '0';
						modef4_rl <= '0'; 
						modef3_rl <= '0'; 
						modef2_rl <= '0';
						
					end if;
				elsif(switch4 = '1' and switch3 = '1' and switch2 = '0') then --ud servo fast mode
						 fast_cntr_ud <= fast_cntr_ud + 1;
						 slow_cntr_ud <= 0;
						 if(fast_cntr_ud = 3) then
							  fast_cntr_ud <= 0;
							  modef4_ud <= '1'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
						 elsif(fast_cntr_ud = 0) then
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
						 elsif(fast_cntr_ud = 1) then
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '1';
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
						 elsif(fast_cntr_ud = 2) then
							  modef4_ud <= '0'; 
							  modef3_ud <= '1'; 
							  modef2_ud <= '0';
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
						 end if;
					elsif(switch4 = '0' and switch3 = '1' and switch2 = '0') then --ud slow mode
						 fast_cntr_ud <= 0;
						 slow_cntr_ud <= slow_cntr_ud + 1;
						 if(slow_cntr_ud = 3) then
							  slow_cntr_ud <= 0;
							  modes4_ud <= '1'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
						 elsif(slow_cntr_ud = 0) then
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '0';
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
						 elsif(slow_cntr_ud = 1) then
							  modes4_ud <= '0'; 
							  modes3_ud <= '0'; 
							  modes2_ud <= '1';
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
						 elsif(slow_cntr_ud = 2) then
							  modes4_ud <= '0'; 
							  modes3_ud <= '1'; 
							  modes2_ud <= '0';
							  modef4_ud <= '0'; 
							  modef3_ud <= '0'; 
							  modef2_ud <= '0';
						 end if;
					elsif(switch4 = '1' and switch3 = '0' and switch2 = '1') then --fb servo fast mode
					    slow_cntr_fb <= 0;
						 fast_cntr_fb <= fast_cntr_fb + 1;
						 if(fast_cntr_fb = 3) then
							  fast_cntr_fb <= 0;
							  modef4_fb <= '1'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
						 elsif(fast_cntr_fb = 0) then
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
						 elsif(fast_cntr_fb = 1) then
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '1';
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
						 elsif(fast_cntr_fb = 2) then
							  modef4_fb <= '0'; 
							  modef3_fb <= '1'; 
							  modef2_fb <= '0';
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
						 end if;
					elsif(switch4 = '0' and switch3 = '0' and switch2 = '1') then --fb slow mode
					    fast_cntr_fb <= 0;
						 slow_cntr_fb <= slow_cntr_fb + 1;
						 if(slow_cntr_fb = 3) then
							  slow_cntr_fb <= 0;
							  modes4_fb <= '1'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
						 elsif(slow_cntr_fb = 0) then
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '0';
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
						 elsif(slow_cntr_fb = 1) then
							  modes4_fb <= '0'; 
							  modes3_fb <= '0'; 
							  modes2_fb <= '1';
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
						 elsif(slow_cntr_fb = 2) then
							  modes4_fb <= '0'; 
							  modes3_fb <= '1'; 
							  modes2_fb <= '0';
							  modef4_fb <= '0'; 
							  modef3_fb <= '0'; 
							  modef2_fb <= '0';
						 end if;
					elsif(switch4 = '1' and switch3 = '1' and switch2 = '1') then --oc servo fast mode
						 fast_cntr_oc <= fast_cntr_oc + 1;
						 slow_cntr_oc <= 0;
						 if(fast_cntr_oc = 3) then
							  fast_cntr_oc <= 0;
							  modef4_oc <= '1'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
						 elsif(fast_cntr_oc = 0) then
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
						 elsif(fast_cntr_oc = 1) then
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '1';
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
						 elsif(fast_cntr_oc = 2) then
							  modef4_oc <= '0'; 
							  modef3_oc <= '1'; 
							  modef2_oc <= '0';
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
						 end if;
					elsif(switch4 = '0' and switch3 = '1' and switch2 = '1') then --oc slow mode
					    fast_cntr_oc <= 0;
						 slow_cntr_oc <= slow_cntr_oc + 1;
						 if(slow_cntr_oc = 3) then
							  slow_cntr_oc <= 0;
							  modes4_oc <= '1'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
						 elsif(slow_cntr_oc = 0) then
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '0';
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
						 elsif(slow_cntr_oc = 1) then
							  modes4_oc <= '0'; 
							  modes3_oc <= '0'; 
							  modes2_oc <= '1';
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
						 elsif(slow_cntr_oc = 2) then
							  modes4_oc <= '0'; 
							  modes3_oc <= '1'; 
							  modes2_oc <= '0';
							  modef4_oc <= '0'; 
							  modef3_oc <= '0'; 
							  modef2_oc <= '0';
						 end if;											
				end if; 
			end if; --rot_button_prev = '0' and rot_button_debounced = '1					
	end if;
 end process;
 
 P_VGA_SPEED : process(clk) is begin
	if(rising_edge(clk)) then
	
-------------RL SERVO------------------	
		if(modes4_rl = '1') then
			Speed_rl <= "000";
		elsif(modes3_rl = '1') then
			Speed_rl <= "001";
		elsif(modes2_rl = '1') then
			Speed_rl <= "010";
		elsif(modef2_rl = '1') then
			Speed_rl <= "100";
		elsif(modef3_rl = '1') then
			Speed_rl <= "101";
		elsif(modef4_rl = '1') then
			Speed_rl <= "110";
		else
			Speed_rl <= "011";
		end if;

-------------UD SERVO------------------	
		if(modes4_ud = '1') then
			Speed_ud <= "000";
		elsif(modes3_ud = '1') then
			Speed_ud <= "001";
		elsif(modes2_ud = '1') then
			Speed_ud <= "010";
		elsif(modef2_ud = '1') then
			Speed_ud <= "100";
		elsif(modef3_ud = '1') then
			Speed_ud <= "101";
		elsif(modef4_ud = '1') then
			Speed_ud <= "110";
		else
			Speed_ud <= "011";
		end if;
		
-------------FB SERVO------------------	
		if(modes4_fb = '1') then
			Speed_fb <= "000";
		elsif(modes3_fb = '1') then
			Speed_fb <= "001";
		elsif(modes2_fb = '1') then
			Speed_fb <= "010";
		elsif(modef2_fb = '1') then
			Speed_fb <= "100";
		elsif(modef3_fb = '1') then
			Speed_fb <= "101";
		elsif(modef4_fb = '1') then
			Speed_fb <= "110";
		else
			Speed_fb <= "011";
		end if;

-------------OC SERVO------------------	
		if(modes4_oc = '1') then
			Speed_oc <= "000";
		elsif(modes3_oc = '1') then
			Speed_oc <= "001";
		elsif(modes2_oc = '1') then
			Speed_oc <= "010";
		elsif(modef2_oc = '1') then
			Speed_oc <= "100";
		elsif(modef3_oc = '1') then
			Speed_oc <= "101";
		elsif(modef4_oc = '1') then
			Speed_oc <= "110";
		else
			Speed_oc <= "011";
		end if;
	
	end if; 
 end process;
 
end TOP_MODULE;