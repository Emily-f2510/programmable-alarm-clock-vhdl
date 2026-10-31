library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity day_counter is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        set_time : in std_logic;
        time_in : in STD_LOGIC_VECTOR(16 downto 0);
        count : out STD_LOGIC_VECTOR(16 downto 0)
    );
end day_counter;

architecture Behavioral of day_counter is
    signal count_in : STD_LOGIC_VECTOR(16 downto 0);  -- 17 bits
begin

    process(clk, rst)
    begin
        if rst = '1' then
            count_in <= (others => '0');
        
        elsif rising_edge(clk) then
            if set_time = '1' then
                count_in <= time_in;
            end if;
            if enable = '1' then
                if count_in = "10101000101111111" then  -- 86399 in binary
                    count_in <= (others => '0');
                else
                    count_in <= count_in + 1;
                end if;
            end if;
        end if;
    end process;
    
    count <= count_in;
    
end Behavioral;
