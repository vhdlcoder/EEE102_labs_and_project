library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity dht11_finaltop is
Port ( clock_100Mhz : in std_logic;
reset : in std_logic;
Activator : out std_logic_vector (3 downto 0);
LEDs : out std_logic_vector (6 downto 0);
data : inout std_logic;
air_humid_out : inout std_logic_vector(7 downto 0);
temp_out : inout std_logic_vector(7 downto 0)
);
end dht11_finaltop;
architecture Behavioral of dht11_finaltop is
signal Enable : std_logic_vector(1 downto 0);
signal Led : integer;
signal clock1Mhz : std_logic ;
signal temp_humid_sig : std_logic_vector( 39 downto 0);
component DHT11 is
Port(
    clock_1Mhz: in std_logic;
    data: inout std_logic;
    temp_humid_sig: out std_logic_vector(39 downto 0)
    );
end component;
component Decoder is
PORT( 
    Enable : in std_logic_vector(1 downto 0);
    Fourty_bit : in STD_LOGIC_VECTOR( 39 downto 0);
    Activator : out std_logic_vector(3 downto 0):="0000";
    number : out integer);
end component;
component Sev_Seg_Dis is
PORT
 (number : in integer;
 LED_on : out STD_LOGIC_VECTOR (6 downto 0));
end component;
component SSD_Timer is
PORT
 (clock_100Mhz : in STD_LOGIC;
 reset : in STD_LOGIC;
 Enable: out std_logic_vector(1 downto 0));
end component;
component Clock_1Mhz is
Port(
 clock_100Mhz : in std_logic;
 clock_1Mhz : out std_logic
 );
end component;
begin
sensor_generate : DHT11 port map (clock1Mhz,data,temp_humid_sig);
divided_clock: Clock_1Mhz Port Map (clock_100Mhz, clock1Mhz);
timer_count : SSD_Timer PORT MAP (clock_100Mhz,reset,Enable);
decod_for_ssd : Decoder PORT MAP (Enable,temp_humid_sig,Activator,Led);
SSD : Sev_Seg_Dis PORT MAP (Led,LEDs);
air_humid_out <= temp_humid_sig(39 downto 32);
temp_out <= temp_humid_sig(23 downto 16);
end Behavioral;