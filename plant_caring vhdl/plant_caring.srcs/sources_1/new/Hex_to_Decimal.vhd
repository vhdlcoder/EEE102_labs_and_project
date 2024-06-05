library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Hex_to_Decimal is
 Port (four_bit: in STD_LOGIC_VECTOR (3 downto 0);
 decimal: out integer range 0 to 15);
end Hex_to_Decimal;
architecture Behavioral of Hex_to_Decimal is
begin
process(four_bit)
begin
 case four_bit is
 when "0000" => decimal <= 0; 
 when "0001" => decimal <= 1; 
 when "0010" => decimal <= 2; 
 when "0011" => decimal <= 3; 
 when "0100" => decimal <= 4; 
 when "0101" => decimal <= 5; 
 when "0110" => decimal <= 6; 
 when "0111" => decimal <= 7; 
 when "1000" => decimal <= 8; 
 when "1001" => decimal <= 9; 
 when "1010" => decimal <= 10; 
 when "1011" => decimal <= 11; 
 when "1100" => decimal <= 12; 
 when "1101" => decimal <= 13; 
 when "1110" => decimal <= 14; 
 when "1111" => decimal <= 15; 
 when others => decimal <= 0;
 end case;
end process;
end Behavioral;