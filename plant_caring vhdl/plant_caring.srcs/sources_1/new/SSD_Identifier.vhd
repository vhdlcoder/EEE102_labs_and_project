library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
entity SSD_Identifier is
 Port ( Fourty_bit : in STD_LOGIC_VECTOR( 39 downto 0);
 check :out integer range 0 to 1;
 ssd1 :out integer;
 ssd2 :out integer;
 ssd3 :out integer;
 ssd4 :out integer );
end SSD_Identifier;
architecture Behavioral of SSD_Identifier is
signal temp1 : std_logic_vector( 3 downto 0 );
signal temp2 : std_logic_vector( 3 downto 0 );
signal humid1 : std_logic_vector( 3 downto 0 );
signal humid2 : std_logic_vector( 3 downto 0 );
signal ctrl : std_logic_vector( 7 downto 0 );
signal ctrl1 : std_logic_vector( 7 downto 0 );
signal ctrl2 : std_logic_vector( 7 downto 0 );
signal ctrl3 : std_logic_vector( 7 downto 0 );
signal ctrl4 : std_logic_vector( 7 downto 0 );
signal dec1,dec2,dec3,dece1,dece2,dece3 : integer range 0 to 30;
component Hex_to_Decimal is
 Port ( four_bit : in STD_LOGIC_VECTOR (3 downto 0);
 decimal : out integer range 0 to 15 );
end component;
begin
ctrl1 <= Fourty_bit( 39 downto 32);
ctrl2 <= Fourty_bit( 31 downto 24);
 
ctrl3 <= Fourty_bit( 23 downto 16);
ctrl4 <= Fourty_bit( 15 downto 8);
ctrl <= Fourty_bit( 7 downto 0);
humid1 <=  Fourty_bit(39 downto 36);
humid2 <=  Fourty_bit(39 downto 36);
temp1 <= Fourty_bit(23 downto 20);
temp2 <= Fourty_bit(19 downto 16);
number1: Hex_to_Decimal port map(temp1,dec1);
number2: Hex_to_Decimal port map(temp2,dec2);
number3: Hex_to_Decimal port map(humid1,dece1);
number4: Hex_to_Decimal port map(humid2,dece2);
dec3 <= (dec1*16) + dec2;
dece3 <= (dece1*16)+dece2;
process (dec3)
begin
 if dec3 > 9 and dec3 <= 19 then
 ssd1<= 1;
 ssd2<= dec3 - 10;
 elsif dec3 > 19 and dec3 <= 29 then
 ssd1<= 2;
 ssd2<= dec3 - 20;
 elsif dec3 > 29 and dec3 <= 39 then
 ssd1<= 3;
 ssd2<= dec3 - 30;
 end if;
end process;
process (dec3)
begin
 if dece3 > 9 and dece3 <= 19 then
 ssd3<= 1;
 ssd4<= dece3 - 10;
 elsif dece3 > 19 and dece3 <= 29 then
 ssd3<= 2;
 ssd4<= dece3 - 20;
 elsif dece3 > 29 and dece3 <= 39 then
 ssd3<= 3;
 ssd4<= dec3 - 30;
 end if;
end process;
check <= 1 when (ctrl1 + ctrl2 +ctrl3 +ctrl4 ) = ctrl else 0;
end Behavioral;