library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
entity SSD_Timer is
 Port ( clock_100Mhz : in STD_LOGIC;
 reset : in STD_LOGIC;
 Enable: out std_logic_vector(1 downto 0));
end SSD_Timer;
architecture Behavioral of SSD_Timer is
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0):= "00000000000000000000";
begin
process(clock_100Mhz,reset)
begin
 if(reset='1') then
 refresh_counter <= (others => '0');
 elsif(rising_edge(clock_100Mhz)) then
 refresh_counter <= refresh_counter + 1;
 end if;
end process;
 
 Enable <= refresh_counter(19 downto 18);
end Behavioral;