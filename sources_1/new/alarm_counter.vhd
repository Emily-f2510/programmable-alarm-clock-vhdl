library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--count 30 secounds
entity alarm_counter is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        alarm_ok : out std_logic
    );
end alarm_counter;

architecture Behavioral of alarm_counter is
    signal count_in : STD_LOGIC_VECTOR(4 downto 0);  -- 17 bits
begin

    process(clk, rst)
    begin
        if rst = '1' then
            count_in <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                if count_in = "11101" then  -- 29 in binary
                    count_in <= (others => '0');
                else
                    count_in <= count_in + 1;
                end if;
            end if;
        end if;
    end process;
    
    alarm_ok <= '1' when count_in = "11101" else '0';
    
end Behavioral;
