library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
use IEEE.NUMERIC_STD.ALL;
entity Clock_1Mhz is
 Port (
 clock_100Mhz : in std_logic;
 clock_1Mhz : out std_logic
 );
end Clock_1Mhz;
architecture Behavioral of Clock_1Mhz is
signal clk : std_logic:= '0';
signal count: integer range 0 to 49:= 0;
begin
process(clock_100Mhz)
begin
 if rising_edge(clock_100Mhz) then
 if count = 49 then
 count <= 0;
 clk <= not clk;
 else
 count <= count + 1;
 end if;
 end if;
end process;
clock_1Mhz <= clk;
end Behavioral;
 