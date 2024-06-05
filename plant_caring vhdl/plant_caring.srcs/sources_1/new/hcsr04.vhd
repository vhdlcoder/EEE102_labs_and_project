library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity hcsr04 is
port( clk : in std_logic;
	  echo11 : in std_logic;
	  trig11 : out std_logic;
	  check : out std_logic); 
end entity;

architecture Behavioral of hcsr04 is
signal sw_int : integer range 0 to 255 := 0;
signal centimeter : integer :=0 ;
signal clk_1MHz : std_logic := '0';
signal clk_out	: std_logic := '0';
signal distance_value: std_logic := '0';
begin

process(clk) -- 100MHz / 100 = 1MHz clock
variable cont: integer:=0;
 begin
    if rising_edge(clk) then 
        cont := cont + 1;
        if cont = 100 then
           cont:=0;
        end if; 

        if cont < 50 then
           clk_out <= '1';
        else
           clk_out <= '0';
        end if;
   end if;
end process;

clk_1MHz <= clk_out;

process(clk_1MHz)
variable trig_time,echo_time: integer:=0;
variable trig_event :std_logic:='0';
begin
if rising_edge(clk_1MHz) then
	if (trig_time = 0) then
		trig11 <= '1';
   elsif (trig_time = 10) then	-- trig time
		trig11 <= '0';
		trig_event := '1';
   elsif (trig_time = 100000) then	-- wait trig
		trig_time := 0;
		trig11 <= '1';
	end if;
         
	trig_time := trig_time+1;
			
	if (echo11 = '1') then
		echo_time := echo_time + 1;
	elsif (echo11 = '0' and trig_event = '1')then
		centimeter <= echo_time / 58;
        echo_time := 0 ;
        trig_event := '0';
   end if;
end if;
sw_int <= centimeter;
if sw_int < 30 then
    distance_value <= '1';
else 
    distance_value <= '0';
end if; 
check <= distance_value;
end process;	  
end Behavioral;