library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity top is
    port(
        clk : in std_logic;
        sw_1 : in unsigned(7 downto 0); 
        rst : in std_logic;
        data : inout std_logic;
        echo1:in std_logic; 
        trig : out std_logic;
        option : in std_logic_vector(1 downto 0);
        wind_warning : out STD_LOGIC;
        low_humid_warning,high_humid_warning,low_temp_warning,high_temp_warning :inout std_logic;
        Activator : out std_logic_vector (3 downto 0);
        LED_on : out std_logic_vector (6 downto 0);
        soil_humid : in std_logic;
        soil_warning: out std_logic;
        kurulum : inout std_logic
    );
end top;

architecture behavior of top is
    component dht11_finaltop is
    	port(	
        clock_100Mhz : in std_logic;
        reset : in std_logic;
        Activator : out std_logic_vector (3 downto 0);
        LEDs : out std_logic_vector (6 downto 0);
        data : inout std_logic;
        air_humid_out : inout std_logic_vector(7 downto 0);
        temp_out : inout std_logic_vector(7 downto 0)
            );
	end component;
    component hcsr04 is
        port(
            clk: in std_logic;
            echo11: in std_logic;
            trig11: out std_logic;
            check : out std_logic
        );
    end component;
    signal lcd_message: std_logic_vector(2 downto 0);
    signal a: std_logic;
    signal clk1,clk2: std_logic;
    signal harf1,harf2,harf3,harf4 : std_logic_vector(6 downto 0);
    signal light: STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    signal refrCounter: STD_LOGIC_VECTOR (17 downto 0):= (others => '0');
    signal LEDActivater: std_logic_vector(1 downto 0):= (others => '0');
    signal temp_threshold_low :  unsigned(7 downto 0); -- Sýcaklýk alt sýnýrý
    signal temp_threshold_high : unsigned(7 downto 0); -- Sýcaklýk üst sýnýrý
    signal air_humid_threshold_low :  unsigned(7 downto 0); -- Nem alt sýnýrý
    signal air_humid_threshold_high :  unsigned(7 downto 0); -- Nem üst sýnýrý
    signal dht11 : std_logic_vector(39 downto 0);
    signal temp_out, air_humid_out : unsigned(7 downto 0);
begin
clk1 <= clk;
clk2 <= clk;
    dht11_sensor_inst : dht11_finaltop
        port map(
            unsigned(temp_out) => temp_out,
            unsigned(air_humid_out) => air_humid_out,
            data => data,
            clock_100Mhz => clk1,
            reset => rst,
            Activator => Activator,
            Leds => Led_on
        );
     hcsr04_inst : hcsr04
        port map(
            clk => clk2,
            echo11 => echo1,
            trig11 => trig,
            check => a
           );
    temp_out <=  unsigned(dht11(23 downto 16));
    air_humid_out <= unsigned(dht11(39 downto 32));
    process(option, sw_1)
    begin
        if  option = "00" then
            air_humid_threshold_low <= sw_1;   
        elsif option = "01" then
            air_humid_threshold_high <= sw_1;          
        elsif option = "10" then
            temp_threshold_low <= sw_1;
        else
            temp_threshold_high <= sw_1;
        end if;
    end process;
    process(rst,temp_out,air_humid_out,kurulum)
    begin
        soil_warning <= soil_humid;
        wind_warning <= a;
        if rst = '1' then
            lcd_message <= "000";
            low_temp_warning <= '0';
            high_temp_warning <= '0';
            low_humid_warning <= '0';
            high_humid_warning <= '0';
            wind_warning <= '0';
        end if;
        if kurulum = '1' then
            if rising_edge(clk) then
                if temp_out < temp_threshold_low then
                    low_temp_warning <= '1';
                elsif temp_out > temp_threshold_high then
                    high_temp_warning <= '1';
                else
                    high_temp_warning <= '0';
                    low_temp_warning <= '0';
                end if;
                --------------
                if air_humid_out < air_humid_threshold_low then
                    low_humid_warning <= '1';
                elsif air_humid_out > air_humid_threshold_high then
                    high_humid_warning <= '1';
                else 
                    high_humid_warning <= '0';
                    low_humid_warning <= '0';
                end if;
            end if;
        else 
            high_humid_warning <= '0';
            low_humid_warning <= '0';
            high_temp_warning <= '0';
            low_temp_warning <= '0';
        end if;
    end process;
end Behavior;
