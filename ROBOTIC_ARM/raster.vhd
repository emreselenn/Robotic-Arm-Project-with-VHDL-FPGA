library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity raster is Port ( 
  CLK25M : in  STD_LOGIC;
  HS, VS : out STD_LOGIC;
       x : out integer range 0 to 800;
       y : out integer range 0 to 521;
 XYvalid : out STD_LOGIC);
end raster;

architecture raster of raster is

  constant HMAX : integer := 1040;
  constant HPIC : integer := 800;
  constant HFP  : integer := 56;
  constant HPW  : integer := 120;
  constant HBP  : integer := 64;
  
  constant VMAX : integer := 666;
  constant VPIC : integer := 600;
  constant VFP  : integer := 37;
  constant VPW  : integer := 6;
  constant VBP  : integer := 23;

  signal hcntr : integer range 0 to HMAX;
  signal vcntr : integer range 0 to VMAX;
  signal pHSx, HSx : STD_LOGIC;
begin
  
  HS <= HSx; x <= hcntr; y <= vcntr;
  
  process(CLK25M) is begin
    if(rising_edge(CLK25M)) then
      if(hcntr=HMAX-1) then hcntr <= 0; else hcntr <= hcntr +1; end if;
      if(hcntr=HPIC+HFP-1) then HSx <= '0'; 
      elsif(hcntr=HPIC+HFP+HPW-1) then HSx <= '1'; end if;
    end if;
  end process;

  process(CLK25M) is begin
    if(rising_edge(CLK25M)) then
      pHSx <= HSx;
      if((pHSx='1')and(HSx='0')) then
        if(vcntr=VMAX-1) then vcntr <= 0; else vcntr <= vcntr +1; end if;
        if(vcntr=VPIC+VFP-1) then VS <= '0'; 
        elsif(vcntr=VPIC+VFP+VPW-1) then VS <= '1'; end if;
      end if;
    end if;
  end process;
  
  process(hcntr,vcntr) is begin
    if((hcntr<HPIC) and (vcntr<VPIC)) then XYvalid <= '1'; else XYvalid <= '0'; end if;
  end process;
  

end raster;

