library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ue is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           time_in : in std_logic_vector(16 downto 0); -- 131071 = 2^17 - 1, 86400 seconds in a day, we need 17 bits
           enable : in std_logic;
           radio_on : in STD_LOGIC;
           radio_off : in STD_LOGIC;
           alarm_on : in STD_LOGIC;
           alarm_off : in STD_LOGIC;
           set_time : in STD_LOGIC;
           set_target : in STD_LOGIC;
           target_reached : out STD_LOGIC;
           alarm_ok : out STD_LOGIC;
           target_time_out : out std_logic_vector(16 downto 0);
           q_time_out : out std_logic_vector(16 downto 0)
           );
end ue;

architecture Behavioral of ue is

component day_counter is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        set_time : in std_logic;
        time_in : in STD_LOGIC_VECTOR(16 downto 0);
        count : out STD_LOGIC_VECTOR(16 downto 0)
    );
end component;

component alarm_counter is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        alarm_ok : out std_logic
    );
end component;

signal q_time : std_logic_vector(16 downto 0);
signal target_time : std_logic_vector(16 downto 0);

begin

day_cnt: day_counter 
    port map (
        clk => clk,
        rst => rst,
        enable => enable,
        set_time => set_time,
        time_in => time_in,
        count => q_time
    );

alarm_cnt: alarm_counter
     port map (
       clk => clk,
       rst => rst,
       enable => alarm_on,
       alarm_ok => alarm_ok
     );
    
    process(clk, rst)
     begin
         if rst = '1' then
             target_time <= (others => '0');
             target_reached <= '0';
         elsif q_time = target_time then
             target_reached <= '1';
         else
             target_reached <= '0';
         end if;
         if rising_edge(clk) then
             if set_target = '1' then
                 target_time <= time_in;
                 target_reached <= '0';
             end if;
         end if;
     end process;
    
    target_time_out <= target_time;
    q_time_out <= q_time;
end Behavioral;
