library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Decoder is
    Port (
        Enable : in std_logic_vector(1 downto 0);
        Fourty_bit : in STD_LOGIC_VECTOR(39 downto 0);
        Activator : out std_logic_vector(3 downto 0) := "0000";
        number : out integer range 0 to 10
    );
end Decoder;

architecture Behavioral of Decoder is
    signal check, ssd1, ssd2,ssd3,ssd4 : integer;
    
    component SSD_Identifier is
        Port (
            Fourty_bit : in STD_LOGIC_VECTOR(39 downto 0);
            check : out integer range 0 to 1;
            ssd2 : out integer;
            ssd1 : out integer;
            ssd3: out integer;
            ssd4: out integer
        );
    end component;

begin
    ssd_iden : SSD_Identifier port map(Fourty_bit, check, ssd2, ssd1,ssd3,ssd4);

    process(Enable, Fourty_bit)
    begin
        case Enable is
            when "00" =>
                Activator <= "0111";
                number <= ssd3;
            when "01" =>
                Activator <= "1011";
                number <= ssd4;
            when "10" =>
                Activator <= "1101";
                number <= ssd1;
            when "11" =>
                Activator <= "1110";
                number <= ssd2;
            when others =>
                Activator <= "0000";
                number <= 0;
        end case;
    end process;

end Behavioral;
