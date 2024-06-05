library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Sev_Seg_Dis is
 Port (number: in integer range 0 to 10;
 LED_on: out STD_LOGIC_VECTOR (6 downto 0));
end Sev_Seg_Dis;
architecture Behavioral of Sev_Seg_Dis is
begin
process(number)
begin
 case number is

 when 0 => LED_on <= "0000001"; -- "0"
 when 1 => LED_on <= "1001111"; -- "1"
 when 2 => LED_on <= "0010010"; -- "2"
 when 3 => LED_on <= "0000110"; -- "3"
 when 4 => LED_on <= "1001100"; -- "4"
 when 5 => LED_on <= "0100100"; -- "5"
 when 6 => LED_on <= "0100000"; -- "6"
 when 7 => LED_on <= "0001111"; -- "7"
 when 8 => LED_on <= "0000000"; -- "8"
 when 9 => LED_on <= "0000100"; -- "9"
 when others => LED_on <= "0000001";
 end case;
end process;
end Behavioral;