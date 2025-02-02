library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_divider is port(
     CLK : in std_logic; -- 50M Hz System clock
	  CLK_NEW : out std_logic --  new clock
	  );    
end clock_divider;

architecture clock_divider of clock_divider is
     constant MAXV : integer := 10000;  
	  signal cntr : integer range 0 to MAXV;
	  signal CLK2 : std_logic := '0'; -- ara deðiþken 
begin
     process(CLK) is begin
	     if(rising_edge(CLK)) then
		     if(cntr=(MAXV-1)) then
			     cntr <= 0;
				  CLK2 <= not CLK2; --counter MAXV degerine ulastýgýnda CLK2 toggle eder
			  else
			     cntr <= cntr +1;	  
			  end if;
		  end if;
	  end process;
    CLK_NEW <= CLK2;
end clock_divider;

