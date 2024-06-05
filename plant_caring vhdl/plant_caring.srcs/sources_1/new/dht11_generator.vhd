library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DHT11 is
    Port (
        clock_1Mhz : in std_logic;
        data : inout std_logic;
        temp_humid_sig : out std_logic_vector(39 downto 0)
    );
end DHT11;

architecture Behavioral of DHT11 is
    signal State : std_logic_vector(3 downto 0) := "0000";
    signal direction: std_logic:= '0';
    signal one_counter : integer := 0;
    signal count : integer := 0;
    signal length : integer range 0 to 40 := 0;
    signal temp_humid_signal : std_logic_vector(39 downto 0) := (others => '0');
    signal Fourty_bit_data : std_logic_vector(39 downto 0) := (others => '0');
begin
    process(clock_1Mhz)
    begin
        if rising_edge(clock_1Mhz) then
            -- Durumu Kontrol Et --
            case State is
                when "0000" =>
                    count <= count + 1;
                    if count > 3000000 then
                        State <= "0001";
                        data <= '0';
                        direction <= '1';
                        count <= 0;
                    end if;

                when "0001" =>
                    count <= count + 1;
                    if count > 20000 then
                        data <= 'Z';
                        direction <= '0';
                        count <= 0;
                        State <= "0010";
                    end if;

                when "0010" =>
                    count <= count + 1;
                    if count > 15 then
                        count <= 0;
                        State <= "0011";
                    end if;

                when "0011" =>
                    if data = '0' then
                        State <= "0100";
                    end if;

                when "0100" =>
                    if data = '1' then
                        State <= "0101";
                    end if;

                when "0101" =>
                    if data = '0' then
                        State <= "0110";
                    end if;

                when "0110" =>
                    if data = '1' then
                        State <= "0111";
                        count <= 0;
                    end if;

                when "0111" =>
                    one_counter <= one_counter + 1;
                    if data = '0' then
                        if one_counter < 50 then
                            temp_humid_signal <= temp_humid_signal(38 downto 0) & '0';
                        else
                            temp_humid_signal <= temp_humid_signal(38 downto 0) & '1';
                        end if;
                        length <= length + 1;
                        one_counter <= 0;
                        State <= "1000";
                    end if;

                when "1000" =>
                    if length = 40 then
                        Fourty_bit_data <= temp_humid_signal;
                        State <= "0000";
                        length <= 0;
                    else
                        State <= "0101";
                    end if;

                when others =>
                    State <= "0000";
            end case;
        end if;
    end process;

    temp_humid_sig <= Fourty_bit_data; 
end Behavioral;
