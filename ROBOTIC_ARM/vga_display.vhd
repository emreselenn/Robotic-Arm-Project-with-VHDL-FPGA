library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;


entity vga_display is 
    port (
        Speed_rl : in  std_logic_vector(2 downto 0);
        Speed_ud : in  std_logic_vector(2 downto 0);
		  Speed_fb : in  std_logic_vector(2 downto 0);
		  Speed_oc : in  std_logic_vector(2 downto 0);
		  Angle_rl : in  integer;
		  Angle_ud : in  integer;
		  Angle_oc : in  integer;
		  Angle_fb : in  integer;
        CLK      : in  std_logic;
        HS, VS   : out STD_LOGIC;
        RGB      : out STD_LOGIC_VECTOR(0 to 2)
    );
end vga_display;

architecture Behavioral of vga_display is

    component raster is 
        port ( 
            CLK25M   : in  STD_LOGIC;
            HS, VS   : out STD_LOGIC;
            x        : out integer range 0 to 800;
            y        : out integer range 0 to 521;
            XYvalid  : out STD_LOGIC
        );
    end component;
	 
	 component RAM is
    Port (
        address : in  std_logic_vector(8 downto 0); -- 9-bit adresleme (512 satr) yapar 32 karakter 
        data    : out std_logic_vector(9 downto 0)
    );
	 end component;
	 	 
    signal x       : integer range 0 to 800;
    signal y       : integer range 0 to 521;
    signal XYvalid : STD_LOGIC := '0';
	 
	 signal rom_address    : std_logic_vector(8 downto 0);
	 signal rom_data       : std_logic_vector(9 downto 0);
	 
	 signal Angle_rl_internal : integer range 10 to 190;
	 signal Angle_ud_internal : integer range 210 to 390;
	 signal Angle_fb_internal : integer range 410 to 590;
    signal Angle_oc_internal : integer range 610 to 790;
	 
	 
	 
begin
    sync : raster port map (
        CLK25M => CLK,
        HS => HS,
        VS => VS,
        x => x,
        y => y,
        XYvalid => XYvalid
    );
	 
	 ROM_inst : RAM port map(
		address => rom_address,
		data   => rom_data	 
	 );

    P_MAIN : process(CLK)
	 

	 
begin 
    if rising_edge(CLK) then
        if XYvalid = '1' then
		      RGB <= "000"; 
            if ((x >= 198 and x <= 202) or (x >= 398 and x <= 402) or (x >= 598 and x <= 602)) then
                RGB <= "111";
            else
                if ((x - 100) * (x - 100) + (y - 200) * (y - 200) <= 80 * 80 and y <= 200) then
                    RGB <= "110";
                    if (Speed_rl = "000" and x >= 20 and x <= 100 and y >= 198 and y <= 199) then -- 4x slow
                        RGB <= "001";
                    elsif ((Speed_rl = "001") and (x >= 30) and (x <= 100) and (y >= 160) and (y <= 200) and (7*y >= 4*x +995 and 7*y <= 4*x +1005)) then --3x slow
                        RGB <= "001";
                    elsif ((Speed_rl = "010") and (x >= 60) and (x <= 100) and (y >= 130) and (y <= 200) and (4*y >= 7*x +95 and 4*y <= 7*x +105)) then --2x slow
                        RGB <= "001";
                    elsif(Speed_rl = "011" and x >= 99 and x <= 100 and y >= 125 and y <= 200) then --default speed
                        RGB <= "000";
                    elsif ((Speed_rl = "100") and (x >= 100) and (x <= 140) and (y >= 130) and (y <= 200) and (4*y >= -7*x +1495 and 4*y <= -7*x +1505)) then --3x fast
                        RGB <= "100";
                    elsif ((Speed_rl = "101") and (x >= 100) and (x <= 170) and (y >= 160) and (y <= 200) and (7*y >= -4*x +1795 and 7*y <= -4*x +1805)) then --3x slow
                        RGB <= "100";
                    elsif (Speed_rl = "110" and x >= 100 and x <= 180 and y >= 198 and y <= 199) then -- 4x fast
                        RGB <= "100";
                    end if;
                end if;
					 if ((x - 300) * (x - 300) + (y - 200) * (y - 200) <= 80 * 80 and y <= 200) then
						 RGB <= "111";
						 if (Speed_ud = "000" and x >= 220 and x <= 300 and y >= 198 and y <= 199) then -- 4x slow
							RGB <= "001";
						 elsif ((Speed_ud = "001") and (x >= 230) and (x <= 300) and (y >= 160) and (y <= 200) and (7*y >= 4*x +195 and 7*y <= 4*x +205)) then -- 3x slow
							RGB <= "001";
						 elsif ((Speed_ud = "010") and (x >= 260) and (x <= 300) and (y >= 130) and (y <= 200) and (7*x - 4*y >= 1295 and 7*x - 4*y <= 1305) ) then -- 2x slow
							RGB <= "001";
						 elsif (Speed_ud = "011" and x >= 299 and x <= 300 and y >= 125 and y <= 200) then -- default speed
							RGB <= "000";
						 elsif ((Speed_ud = "100") and (x >= 300) and (x <= 340) and (y >= 130) and (y <= 200) and (4*y >= -7*x + 2895 and 4*y <= -7*x + 2905)) then -- 2x fast
							RGB <= "100";
						 elsif ((Speed_ud = "101") and (x >= 300) and (x <= 370) and (y >= 160) and (y <= 200) and (7*y >= -4*x + 2595 and 7*y <= -4*x + 2605)) then -- 3x fast
							RGB <= "100";
						 elsif (Speed_ud = "110" and x >= 300 and x <= 380 and y >= 198 and y <= 199) then -- 4x fast
							RGB <= "100";
						 end if;
					 end if;



					 if ((x - 500) * (x - 500) + (y - 200) * (y - 200) <= 80 * 80 and y <= 200) then
						 RGB <= "010";
						 if (Speed_fb = "000" and x >= 420 and x <= 500 and y >= 198 and y <= 199) then -- 4x slow
							  RGB <= "001";
						 elsif ((Speed_fb = "001") and (x >= 430) and (x <= 500) and (y >= 160) and (y <= 200) and (4*x - 7*y >= 595 and 4*x - 7*y <= 605)) then -- 3x slow
							  RGB <= "001";
						 elsif ((Speed_fb = "010") and (x >= 460) and (x <= 500) and (y >= 130) and (y <= 200) and (7*x -4*y >= 2695 and 7*x -4*y <= 2705)) then -- 2x slow
							  RGB <= "001";
						 elsif (Speed_fb = "011" and x >= 499 and x <= 500 and y >= 125 and y <= 200) then -- default speed
							  RGB <= "000";
						 elsif ((Speed_fb = "100") and (x >= 500) and (x <= 540) and (y >= 130) and (y <= 200) and (7*x + 4*y >= 4295 and 7*x +4*y <= 4305)) then -- 2x fast
							  RGB <= "100";
						 elsif ((Speed_fb = "101") and (x >= 500) and (x <= 570) and (y >= 160) and (y <= 200) and (4*x + 7*y >= 3395 and 4*x + 7*y <= 3405)) then -- 3x fast
							  RGB <= "100";
						 elsif (Speed_fb = "110" and x >= 500 and x <= 580 and y >= 198 and y <= 199) then -- 4x fast
							  RGB <= "100";
						 end if;
					 end if;
					 
					 
					 
					 if ((x - 700) * (x - 700) + (y - 200) * (y - 200) <= 80 * 80 and y <= 200) then
						 RGB <= "011";
						 if (Speed_oc = "000" and x >= 620 and x <= 700 and y >= 198 and y <= 199) then -- 4x slow
							  RGB <= "001";
						 elsif ((Speed_oc = "001") and (x >= 630) and (x <= 700) and (y >= 160) and (y <= 200) and (4*x - 7*y >= 1395 and 4*x - 7*y <= 1405)) then -- 3x slow
							  RGB <= "001";
						 elsif ((Speed_oc = "010") and (x >= 660) and (x <= 700) and (y >= 130) and (y <= 200) and (7*x - 4*y >= 4095 and 7*x - 4*y <= 4105)) then -- 2x slow
							  RGB <= "001";
						 elsif (Speed_oc = "011" and x >= 699 and x <= 700 and y >= 125 and y <= 200) then -- default speed
							  RGB <= "000";
						 elsif ((Speed_oc = "100") and (x >= 700) and (x <= 740) and (y >= 130) and (y <= 200) and (7*x + 4*y >= 5695 and 7*x + 4*y <= 5705)) then -- 2x fast
							  RGB <= "100";
						 elsif ((Speed_oc = "101") and (x >= 700) and (x <= 770) and (y >= 160) and (y <= 200) and (4*x + 7*y >= 4195 and 4*x + 7*y <= 4205)) then -- 3x fast
							  RGB <= "100";
						 elsif (Speed_oc = "110" and x >= 700 and x <= 780 and y >= 198 and y <= 199) then -- 4x fast
							  RGB <= "100";
						 end if;
					 end if;
					 
---------------------------------------------------SERVO MOTOR SPEED DISPLAY ENDS, ANGLE DISPLAY STARTS-------------------------------------------------------------------
					
					if(x >= 10 and x <= 190 and y >= 400 and y <= 410) then
						RGB <= "111";
						if(((x >= 10 and x <= 11) or (x >= 20 and x <= 21) or (x >= 30 and x <= 31) or (x >= 40 and x <= 41) or (x >= 50 and x <= 51) or 
						   (x >= 60 and x <= 61) or (x >= 70 and x <= 71) or (x >= 80 and x <= 81) or (x >= 90 and x <= 91) or 
							(x >= 100 and x <= 101) or (x >= 110 and x <= 111) or (x >= 120 and x <= 121) or (x >= 130 and x <= 131) or 
							(x >= 140 and x <= 141) or (x >= 150 and x <= 151) or (x >= 160 and x <= 161) or (x >= 170 and x <= 171) or (x >= 180 and x <= 181) or (x >= 189 and x <= 190)) 
							and (y >= 400 and y <= 405)) then							
							RGB <= "001";							
						elsif( x >= Angle_rl_internal -2 and x <= Angle_rl_internal +2 and y >= 400 and y <= 410) then
							RGB <= "100";															
						end if;												
					end if;
					
					if(x >= 210 and x <= 390 and y >= 400 and y <= 410) then
								RGB <= "111";

						if( x >= Angle_ud_internal -2 and x <= Angle_ud_internal +2 and y >= 400 and y <= 410) then
								RGB <= "100";														
						elsif(((x >= 210 and x <= 211) or (x >= 220 and x <= 221) or (x >= 230 and x <= 231) or (x >= 240 and x <= 241) or (x >= 250 and x <= 251) or 
						   (x >= 260 and x <= 261) or (x >= 270 and x <= 271) or (x >= 280 and x <= 281) or (x >= 290 and x <= 291) or 
							(x >= 300 and x <= 301) or (x >= 310 and x <= 311) or (x >= 320 and x <= 321) or (x >= 330 and x <= 331) or 
							(x >= 340 and x <= 341) or (x >= 350 and x <= 351) or (x >= 360 and x <= 361) or (x >= 370 and x <= 371) or (x >= 380 and x <= 381) or (x >= 389 and x <= 390)) 
							and (y >= 400 and y <= 405)) then							
							RGB <= "001";							
																					
						end if;												
					end if;
					
					if(x >= 410 and x <= 590 and y >= 400 and y <= 410) then
						 RGB <= "111";
						 if(((x >= 410 and x <= 411) or (x >= 420 and x <= 421) or (x >= 430 and x <= 431) or (x >= 440 and x <= 441) or (x >= 450 and x <= 451) or 
							  (x >= 460 and x <= 461) or (x >= 470 and x <= 471) or (x >= 480 and x <= 481) or (x >= 490 and x <= 491) or 
							  (x >= 500 and x <= 501) or (x >= 510 and x <= 511) or (x >= 520 and x <= 521) or (x >= 530 and x <= 531) or 
							  (x >= 540 and x <= 541) or (x >= 550 and x <= 551) or (x >= 560 and x <= 561) or (x >= 570 and x <= 571) or (x >= 580 and x <= 581) or (x >= 589 and x <= 590)) 
							  and (y >= 400 and y <= 405)) then
							  RGB <= "001";                            
						 elsif(x >= Angle_fb_internal -2 and x <= Angle_fb_internal +2 and y >= 400 and y <= 410) then
							  RGB <= "100";                                                            
						 end if;                                                
					end if;

					if(x >= 610 and x <= 790 and y >= 400 and y <= 410) then
						 RGB <= "111";
						 if(((x >= 610 and x <= 611) or (x >= 620 and x <= 621) or (x >= 630 and x <= 631) or (x >= 640 and x <= 641) or (x >= 650 and x <= 651) or 
							  (x >= 660 and x <= 661) or (x >= 670 and x <= 671) or (x >= 680 and x <= 681) or (x >= 690 and x <= 691) or 
							  (x >= 700 and x <= 701) or (x >= 710 and x <= 711) or (x >= 720 and x <= 721) or (x >= 730 and x <= 731) or 
							  (x >= 740 and x <= 741) or (x >= 750 and x <= 751) or (x >= 760 and x <= 761) or (x >= 770 and x <= 771) or (x >= 780 and x <= 781) or (x >= 789 and x <= 790)) 
							  and (y >= 400 and y <= 405)) then
							  RGB <= "001";                            
						 elsif(x >= Angle_oc_internal -2 and x <= Angle_oc_internal +2 and y >= 300 and y <= 410) then
							  RGB <= "100";                                                            
						 end if;                                                
					end if;


---------------------------------------------------ANGLE DISPLAY ENDS, ASCII CHARACTER DISPLAY STARTS-------------------------------------------------------------------
					---------------------------------------------------ANGLE DISPLAY ENDS, ASCII CHARACTER DISPLAY STARTS-------------------------------------------------------------------
					
					--R
					if (x >= 20 and x < 30) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +170, 9));
						
						if rom_data(x - 20) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--I
					if (x >= 30 and x < 40) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +80, 9));
						
						if rom_data(x - 30) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 40 and x < 50) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +60, 9));
						
						if rom_data(x - 40) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--H
					if (x >= 50 and x < 60) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +70, 9));
						
						if rom_data(x - 50) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--T
					if (x >= 60 and x < 70) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +190, 9));
						
						if rom_data(x - 60) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--L
					if (x >= 75 and x < 85) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +110, 9));
						
						if rom_data(x - 75) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 85 and x < 95) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +40, 9));
						
						if rom_data(x - 85) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--F
					if (x >= 95 and x < 105) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +50, 9));
						
						if rom_data(x - 95) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--T
					if (x >= 105 and x < 115) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +190, 9));
						
						if rom_data(x - 105) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					
					--F
					if (x >= 420 and x < 430) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +50, 9));
						
						if rom_data(x - 420) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 430 and x < 440) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +140, 9));
						
						if rom_data(x - 430) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 440 and x < 450) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +170, 9));
						
						if rom_data(x - 440) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--W
					if (x >= 450 and x < 460) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +220, 9));
						
						if rom_data(x - 450) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 460 and x < 470) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +0, 9));
						
						if rom_data(x - 460) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					--R
					if (x >= 470 and x < 480) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +170, 9));
						
						if rom_data(x - 470) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 480 and x < 490) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +30, 9));
						
						if rom_data(x - 480) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					
					--B
					if (x >= 495 and x < 505) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +10, 9));
						
						if rom_data(x - 495) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 505 and x < 515) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +0, 9));
						
						if rom_data(x - 505) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--C
					if (x >= 515 and x < 525) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +20, 9));
						
						if rom_data(x - 515) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;

					--K
					if (x >= 525 and x < 535) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +100, 9));
						
						if rom_data(x - 525) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--W
					if (x >= 535 and x < 545) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +220, 9));
						
						if rom_data(x - 535) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 545 and x < 555) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +0, 9));
						
						if rom_data(x - 545) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					--R
					if (x >= 555 and x < 565) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +170, 9));
						
						if rom_data(x - 555) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 565 and x < 575) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +30, 9));
						
						if rom_data(x - 565) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;

					-----------------------------------------------------------------------------------

					--U
					if (x >= 220 and x < 230) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +200, 9));
						
						if rom_data(x - 220) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 230 and x < 240) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +150, 9));
						
						if rom_data(x - 230) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					
					--D
					if (x >= 245 and x < 255) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +30, 9));
						
						if rom_data(x - 245) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 255 and x < 265) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +140, 9));
						
						if rom_data(x - 255) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--W
					if (x >= 265 and x < 275) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +220, 9));
						
						if rom_data(x - 265) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 275 and x < 285) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +130, 9));
						
						if rom_data(x - 275) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					
					--O
					if (x >= 620 and x < 630) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +140, 9));
						
						if rom_data(x - 620) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 630 and x < 640) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +150, 9));
						
						if rom_data(x - 630) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 640 and x < 650) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +40, 9));
						
						if rom_data(x - 640) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 650 and x < 660) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +130, 9));
						
						if rom_data(x - 650) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					
					--C
					if (x >= 665 and x < 675) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +20, 9));
						
						if rom_data(x - 665) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 675 and x < 685) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +110, 9));
						
						if rom_data(x - 675) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 685 and x < 695) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +140, 9));
						
						if rom_data(x - 685) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--S
					if (x >= 695 and x < 705) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +180, 9));
						
						if rom_data(x - 695) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 705 and x < 715) and (y >= 20 and y < 30) then					
						rom_address <= std_logic_vector(to_unsigned(y - 20 +40, 9));
						
						if rom_data(x - 705) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
---------------------------------------------------------------SERVO------------------------------------------------------------------------------------				
					--servo1
					
					--S
					if (x >= 20 and x < 30) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +180, 9));
						
						if rom_data(x - 20) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 30 and x < 40) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +40, 9));
						
						if rom_data(x - 30) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 40 and x < 50) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +170, 9));
						
						if rom_data(x - 40) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--V
					if (x >= 50 and x < 60) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +210, 9));
						
						if rom_data(x - 50) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 60 and x < 70) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +140, 9));
						
						if rom_data(x - 60) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--servo2
					
					--S
					if (x >= 220 and x < 230) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +180, 9));
						
						if rom_data(x - 220) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 230 and x < 240) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +40, 9));
						
						if rom_data(x - 230) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 240 and x < 250) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +170, 9));
						
						if rom_data(x - 240) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--V
					if (x >= 250 and x < 260) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +210, 9));
						
						if rom_data(x - 250) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 260 and x < 270) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +140, 9));
						
						if rom_data(x - 260) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--servo3
					
					--S
					if (x >= 420 and x < 430) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +180, 9));
						
						if rom_data(x - 420) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 430 and x < 440) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +40, 9));
						
						if rom_data(x - 430) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 440 and x < 450) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +170, 9));
						
						if rom_data(x - 440) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--V
					if (x >= 450 and x < 460) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +210, 9));
						
						if rom_data(x - 450) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 460 and x < 470) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +140, 9));
						
						if rom_data(x - 460) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--servo4
					
					--S
					if (x >= 620 and x < 630) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +180, 9));
						
						if rom_data(x - 620) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 630 and x < 640) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +40, 9));
						
						if rom_data(x - 630) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 640 and x < 650) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +170, 9));
						
						if rom_data(x - 640) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--V
					if (x >= 650 and x < 660) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +210, 9));
						
						if rom_data(x - 650) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--O
					if (x >= 660 and x < 670) and (y >= 35 and y < 45) then					
						rom_address <= std_logic_vector(to_unsigned(y - 35 +140, 9));
						
						if rom_data(x - 660) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
--------------------------------------------SPEED-----------------------------------------------------------------------------------
					--Speed1
					--S
					if (x >= 75 and x < 85) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +180, 9));
						
						if rom_data(x - 75) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 85 and x < 95) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +150, 9));
						
						if rom_data(x - 85) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 95 and x < 105) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 95) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 105 and x < 115) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 105) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 115 and x < 125) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +30, 9));
						
						if rom_data(x - 115) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Speed2
					
					--S
					if (x >= 275 and x < 285) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +180, 9));
						
						if rom_data(x - 275) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 285 and x < 295) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +150, 9));
						
						if rom_data(x - 285) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 295 and x < 305) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 295) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 305 and x < 315) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 305) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 315 and x < 325) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +30, 9));
						
						if rom_data(x - 315) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Speed3
					
					--S
					if (x >= 475 and x < 485) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +180, 9));
						
						if rom_data(x - 475) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 485 and x < 495) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +150, 9));
						
						if rom_data(x - 485) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 495 and x < 505) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 495) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 505 and x < 515) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 505) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 515 and x < 525) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +30, 9));
						
						if rom_data(x - 515) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Speed4
					
					--S
					if (x >= 675 and x < 685) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +180, 9));
						
						if rom_data(x - 675) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 685 and x < 695) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +150, 9));
						
						if rom_data(x - 685) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 695 and x < 705) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 695) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 705 and x < 715) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +40, 9));
						
						if rom_data(x - 705) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 715 and x < 725) and (y >= 210 and y < 220) then					
						rom_address <= std_logic_vector(to_unsigned(y - 210 +30, 9));
						
						if rom_data(x - 715) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 95 and x < 105) and (y >= 105 and y < 115) then					
						rom_address <= std_logic_vector(to_unsigned(y - 105 +360, 9));
						
						if rom_data(x - 95) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
--------------------------------------------İBRE-----------------------------------------------------------------------------------

					-----------------------------------------------------------------------------------
					--4x_1_sol
					
					if (x >= 25 and x < 35) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 25) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 35 and x < 45) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 35) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--3x_1_sol
					
					if (x >= 40 and x < 50) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 40) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 50 and x < 60) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 50) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sol
					
					if (x >= 60 and x < 70) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 60) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 70 and x < 80) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 70) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Normal noktasi_1
					
					if (x >= 95 and x < 105) and (y >= 105 and y < 115) then					
						rom_address <= std_logic_vector(to_unsigned(y - 105 +360, 9));
						
						if rom_data(x - 95) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sag
					
					if (x >= 155 and x < 165) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 155) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 165 and x < 175) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 165) = '1' then
                     RGB  <= "000";
						end if;
					end if;
					-----------------------------------------------------------------------------------
					--3x_1_sag
					
					if (x >= 140 and x < 150) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 140) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 150 and x < 160) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 150) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sag
					
					if (x >= 120 and x < 130) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 120) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 130 and x < 140) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 130) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Normal noktasi_2
					
					if (x >= 295 and x < 305) and (y >= 105 and y < 115) then					
						rom_address <= std_logic_vector(to_unsigned(y - 105 +360, 9));
						
						if rom_data(x - 295) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sol_2
					
					if (x >= 225 and x < 235) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 225) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 235 and x < 245) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 235) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--3x_1_sol_2
					
					if (x >= 240 and x < 250) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 240) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 250 and x < 260) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 250) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sol_2
					
					if (x >= 260 and x < 270) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 260) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 270 and x < 280) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 270) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sag_2
					
					if (x >= 355 and x < 365) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 355) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 365 and x < 375) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 365) = '1' then
                     RGB  <= "000";
						end if;
					end if;
					-----------------------------------------------------------------------------------
					--3x_1_sag_2
					
					if (x >= 340 and x < 350) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 340) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 350 and x < 360) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 350) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sag_2
					
					if (x >= 320 and x < 330) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 320) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 330 and x < 340) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 330) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Normal noktasi_3
					
					if (x >= 495 and x < 505) and (y >= 105 and y < 115) then					
						rom_address <= std_logic_vector(to_unsigned(y - 105 +360, 9));
						
						if rom_data(x - 495) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sol_3
					
					if (x >= 425 and x < 435) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 425) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 435 and x < 445) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 435) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--3x_1_sol_3
					
					if (x >= 440 and x < 450) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 440) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 450 and x < 460) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 450) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sol_3
					
					if (x >= 460 and x < 470) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 460) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 470 and x < 480) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 470) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sag_3
					
					if (x >= 555 and x < 565) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 555) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 565 and x < 575) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 565) = '1' then
                     RGB  <= "000";
						end if;
					end if;
					-----------------------------------------------------------------------------------
					--3x_1_sag_3
					
					if (x >= 540 and x < 550) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 540) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 550 and x < 560) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 550) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sag_3
					
					if (x >= 520 and x < 530) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 520) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 530 and x < 540) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 530) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Normal noktasi_4
					
					if (x >= 695 and x < 705) and (y >= 105 and y < 115) then					
						rom_address <= std_logic_vector(to_unsigned(y - 105 +360, 9));
						
						if rom_data(x - 695) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sol_4
					
					if (x >= 625 and x < 635) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 625) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 635 and x < 645) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 635) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--3x_1_sol_4
					
					if (x >= 640 and x < 650) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 640) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 650 and x < 660) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 650) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sol_4
					
					if (x >= 660 and x < 670) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 660) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 670 and x < 680) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 670) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--4x_1_sag_4
					
					if (x >= 755 and x < 765) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +300, 9));
						
						if rom_data(x - 755) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 765 and x < 775) and (y >= 190 and y < 200) then					
						rom_address <= std_logic_vector(to_unsigned(y - 190 +370, 9));
						
						if rom_data(x - 765) = '1' then
                     RGB  <= "000";
						end if;
					end if;
					-----------------------------------------------------------------------------------
					--3x_1_sag_4
					
					if (x >= 740 and x < 750) and (y >=165  and y <175 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +290, 9));
						
						if rom_data(x - 740) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 750 and x < 760) and (y >= 165 and y < 175) then					
						rom_address <= std_logic_vector(to_unsigned(y - 165 +370, 9));
						
						if rom_data(x - 750) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--2x_1_sag_4
					
					if (x >= 720 and x < 730) and (y >=140  and y <150 ) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +280, 9));
						
						if rom_data(x - 720) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					if (x >= 730 and x < 740) and (y >= 140 and y < 150) then					
						rom_address <= std_logic_vector(to_unsigned(y - 140 +370, 9));
						
						if rom_data(x - 730) = '1' then
                     RGB  <= "000";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Angle_1
					
					--A
					if (x >= 20 and x < 30) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +0, 9));
						
						if rom_data(x - 20) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 30 and x < 40) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +130, 9));
						
						if rom_data(x - 30) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 40 and x < 50) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +60, 9));
						
						if rom_data(x - 40) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 50 and x < 60) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +110, 9));
						
						if rom_data(x - 50) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
						
					--E
					if (x >= 60 and x < 70) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +40, 9));
						
						if rom_data(x - 60) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Angle_2
					
					--A
					if (x >= 220 and x < 230) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +0, 9));
						
						if rom_data(x - 220) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 230 and x < 240) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +130, 9));
						
						if rom_data(x - 230) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 240 and x < 250) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +60, 9));
						
						if rom_data(x - 240) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 250 and x < 260) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +110, 9));
						
						if rom_data(x - 250) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
						
					--E
					if (x >= 260 and x < 270) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +40, 9));
						
						if rom_data(x - 260) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Angle_3
					
					--A
					if (x >= 420 and x < 430) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +0, 9));
						
						if rom_data(x -420) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 430 and x < 440) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +130, 9));
						
						if rom_data(x - 430) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 440 and x < 450) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +60, 9));
						
						if rom_data(x - 440) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 450 and x < 460) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +110, 9));
						
						if rom_data(x - 450) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
						
					--E
					if (x >= 460 and x < 470) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +40, 9));
						
						if rom_data(x - 460) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Angle_4
					
					--A
					if (x >= 620 and x < 630) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +0, 9));
						
						if rom_data(x - 620) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 630 and x < 640) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +130, 9));
						
						if rom_data(x - 630) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 640 and x < 650) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +60, 9));
						
						if rom_data(x - 640) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 650 and x < 660) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +110, 9));
						
						if rom_data(x - 650) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
						
					--E
					if (x >= 660 and x < 670) and (y >= 300 and y < 310) then					
						rom_address <= std_logic_vector(to_unsigned(y - 300 +40, 9));
						
						if rom_data(x - 660) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--0_90_180_1
					
					--0
					if (x >= 10 and x < 20 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 10) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--90
					if (x >= 90 and x < 100 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +350, 9));
						
						if rom_data(x - 90) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 100 and x < 110 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 100) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--180
					if (x >= 160 and x < 170 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +270, 9));
						
						if rom_data(x - 160) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 170 and x < 180 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +340, 9));
						
						if rom_data(x - 170) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 180 and x < 190 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 180) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--0_90_180_2
					
					--0
					if (x >= 210 and x < 220 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 210) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--90
					if (x >= 290 and x < 300 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +350, 9));
						
						if rom_data(x - 290) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 300 and x < 310 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 300) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--180
					if (x >= 360 and x < 370 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +270, 9));
						
						if rom_data(x - 360) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 370 and x < 380 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +340, 9));
						
						if rom_data(x - 370) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 380 and x < 390 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 380) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--0_90_180_3
					
					--0
					if (x >= 410 and x < 420 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 410) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--90
					if (x >= 490 and x < 500 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +350, 9));
						
						if rom_data(x - 490) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 500 and x < 510 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 500) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--180
					if (x >= 560 and x < 570 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +270, 9));
						
						if rom_data(x - 560) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 570 and x < 580 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +340, 9));
						
						if rom_data(x - 570) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 580 and x < 590 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 580) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--0_90_180_4
					
					--0
					if (x >= 610 and x < 620 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 610) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--90
					if (x >= 690 and x < 700 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +350, 9));
						
						if rom_data(x - 690) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 700 and x < 710 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 700) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--180
					if (x >= 760 and x < 770 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +270, 9));
						
						if rom_data(x - 760) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 770 and x < 780 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +340, 9));
						
						if rom_data(x - 770) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					if (x >= 780 and x < 790 ) and (y >= 385 and y < 395) then					
						rom_address <= std_logic_vector(to_unsigned(y - 385 +260, 9));
						
						if rom_data(x - 780) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					-----------------------------------------------------------------------------------

               -----------------------------------------------------------------------------------
					--Emre Selen
					
					--E
					if (x >= 20 and x < 30) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 20) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--M
					if (x >= 30 and x < 40) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +120, 9));
						
						if rom_data(x - 30) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 40 and x < 50) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +170, 9));
						
						if rom_data(x - 40) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 50 and x < 60) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 50) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--S
					if (x >= 70 and x < 80) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +180, 9));
						
						if rom_data(x - 70) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 80 and x < 90) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 80) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--L
					if (x >= 90 and x < 100) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +110, 9));
						
						if rom_data(x - 90) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 100 and x < 110) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 100) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 110 and x < 120) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +130, 9));
						
						if rom_data(x - 110) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Furkan Kara
					
					--F
					if (x >= 220 and x < 230) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +50, 9));
						
						if rom_data(x - 220) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--U
					if (x >= 230 and x < 240) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +200, 9));
						
						if rom_data(x - 230) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 240 and x < 250) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +170, 9));
						
						if rom_data(x - 240) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--K
					if (x >= 250 and x < 260) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +100, 9));
						
						if rom_data(x - 250) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 260 and x < 270) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +0, 9));
						
						if rom_data(x - 260) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 270 and x < 280) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +130, 9));
						
						if rom_data(x - 270) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--K
					if (x >= 290 and x < 300) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +100, 9));
						
						if rom_data(x - 290) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 300 and x < 310) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +0, 9));
						
						if rom_data(x - 300) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 310 and x < 320) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +170, 9));
						
						if rom_data(x - 310) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 320 and x < 330) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +0, 9));
						
						if rom_data(x - 320) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--Kerem Aydın
					
					--K
					if (x >= 420 and x < 430) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +100, 9));
						
						if rom_data(x - 420) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 430 and x < 440) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 430) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--R
					if (x >= 440 and x < 450) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +170, 9));
						
						if rom_data(x - 440) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
						
					--E
					if (x >= 450 and x < 460) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 450) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--M
					if (x >= 460 and x < 470) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +120, 9));
						
						if rom_data(x - 460) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					
					--A
					if (x >= 480 and x < 490) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +0, 9));
						
						if rom_data(x - 480) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--Y
					if (x >= 490 and x < 500) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +240, 9));
						
						if rom_data(x - 490) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--D
					if (x >= 500 and x < 510) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +30, 9));
						
						if rom_data(x - 500) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--I
					if (x >= 510 and x < 520) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +80, 9));
						
						if rom_data(x - 510) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--N
					if (x >= 520 and x < 530) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +130, 9));
						
						if rom_data(x - 520) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					-----------------------------------------------------------------------------------
					--We 'heart' FPGA ------ Date (22/12/24)
					
					--W
					if (x >= 620 and x < 630) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +220, 9));
						
						if rom_data(x - 620) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--E
					if (x >= 630 and x < 640) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +40, 9));
						
						if rom_data(x - 630) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--'Heart'
					if (x >= 645 and x < 655) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +380, 9));
						
						if rom_data(x - 645) = '1' then
                     RGB  <= "100";
						end if;
					
					end if;
					
					--F
					if (x >= 660 and x < 670) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +50, 9));
						
						if rom_data(x - 660) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--P
					if (x >= 670 and x < 680) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +150, 9));
						
						if rom_data(x - 670) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--G
					if (x >= 680 and x < 690) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +60, 9));
						
						if rom_data(x - 680) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--A
					if (x >= 690 and x < 700) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +0, 9));
						
						if rom_data(x - 690) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--22/12/24
					--2
					if (x >= 720 and x < 730) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +280, 9));
						
						if rom_data(x - 720) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--2
					if (x >= 730 and x < 740) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +280, 9));
						
						if rom_data(x - 730) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--/
					if (x >= 740 and x < 750) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +390, 9));
						
						if rom_data(x - 740) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--1
					if (x >= 750 and x < 760) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +270, 9));
						
						if rom_data(x - 750) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--2
					if (x >= 760 and x < 770) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +280, 9));
						
						if rom_data(x - 760) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--/
					if (x >= 770 and x < 780) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +390, 9));
						
						if rom_data(x - 770) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--2
					if (x >= 780 and x < 790) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +280, 9));
						
						if rom_data(x - 780) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;
					
					--4
					if (x >= 790 and x < 800) and (y >= 500  and y < 510) then					
						rom_address <= std_logic_vector(to_unsigned(y - 500 +300, 9));
						
						if rom_data(x - 790) = '1' then
                     RGB  <= "111";
						end if;
					
					end if;



					
					
------------------------------------------------------------BU END IF ler EN SON KAPATILACAK----------------------------------------					
            end if;
        end if;
    end if;
end process;





P_ANGLE : process(clk) is
	--Bu kısımda ölçeklendirme için x = ((Angle - 25000)/100000)*180 işleminin yapılması gerekiyor. fakat 100000 2 nin katı olmadığı için bu işlem ((Angle - 25000)/32768)*59 olarak yaklaşık olarak hesaplanmıştır
    constant SCALE_FACTOR : integer := 59; -- Çarpma faktörü
    constant DIVISOR : integer := 32768;   --2^15 
    constant OFFSET : integer := 25000; -- Başlangıç ofseti
begin
    if rising_edge(clk) then
        if (Angle_rl >= OFFSET and Angle_rl <= 125000) then
            -- Bölme işlemini integer olarak uygula
            Angle_rl_internal <= 10 + (((Angle_rl - OFFSET) * SCALE_FACTOR) / DIVISOR);
	  
        else
            Angle_rl_internal <= Angle_rl_internal; -- Aralık dışıysa mevcut değeri koru
        end if;
		  
		  if (Angle_ud >= OFFSET and Angle_ud <= 125000) then
            -- Bölme işlemini integer olarak uygula
            Angle_ud_internal <= 210 + (((Angle_ud - OFFSET) * SCALE_FACTOR) / DIVISOR) ;
        else
            Angle_ud_internal <= Angle_ud_internal; -- Aralık dışıysa mevcut değeri koru
        end if;
		  
		  if (Angle_fb >= OFFSET and Angle_fb <= 125000) then
            -- Bölme işlemini integer olarak uygula
            Angle_fb_internal <= 410 + (((Angle_fb - OFFSET) * SCALE_FACTOR) / DIVISOR);
        else
            Angle_fb_internal <= Angle_fb_internal; -- Aralık dışıysa mevcut değeri koru
        end if;
		  
		  if (Angle_oc >= OFFSET and Angle_oc <= 125000) then
            -- Bölme işlemini integer olarak uygula
            Angle_oc_internal <= 610 + (((Angle_oc - OFFSET) * SCALE_FACTOR) / DIVISOR);
        else
            Angle_oc_internal <= Angle_oc_internal; -- Aralık dışıysa mevcut değeri koru
        end if;
    end if;
end process;
end Behavioral;
