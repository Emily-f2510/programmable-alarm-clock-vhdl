library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uc is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           sel_time : in STD_LOGIC_VECTOR (1 downto 0);
           sel_target : in STD_LOGIC_VECTOR (1 downto 0);
           set_time : in STD_LOGIC;
           set_target : in STD_LOGIC;
           target_reached : in STD_LOGIC;
           alarm_ok : in std_logic;
           enable_ue : out std_logic;
           set_time_ue : out STD_LOGIC;
           set_target_ue : out STD_LOGIC;
           radio_on_ue : out STD_LOGIC;
           radio_off_ue : out STD_LOGIC;
           alarm_on_ue : out STD_LOGIC;
           alarm_off_ue : out std_logic
           );
end uc;

architecture Behavioral of uc is
type state_type is (idle, wait_4_time, load_time, wait_4_target, load_target, reach_target, ring, radio_on, radio_off, alarm_on, alarm_off);
signal state : state_type;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= idle;
        elsif rising_edge(clk) then
            case state is
            when idle =>
                report "state is idle";
                if sel_time = "00" then
                    state <= idle;
                elsif sel_time = "01" then
                    state <= wait_4_time;
                elsif sel_time = "10" then
                    state <= wait_4_target;
                end if;
            when wait_4_time =>
                if set_time = '0' then
                    state <= wait_4_time;
                else 
                    state <= load_time;
                end if;
            when load_time =>
                state <= idle;
            when wait_4_target =>
                if set_target = '0' then
                    state <= wait_4_target;
                else 
                    state <= load_target;
                end if;
            when load_target =>
                state <= reach_target;
            when reach_target =>
                if target_reached = '0' then
                    state <= reach_target;
                else
                    report "state is ring";
                    state <= ring;
                end if;
            when ring =>
                if sel_target = "00" then
                    state <= radio_on;
                elsif sel_target = "01" then
                    state <= radio_off;
                elsif sel_target = "10" then
                    state <= alarm_on;
                end if;
            when radio_on =>
                state <= idle;
            when radio_off =>
                state <= idle;
            when alarm_on =>
                if alarm_ok = '0' then
                    state <= alarm_on;
                else 
                    state <= alarm_off;
                end if;
            when alarm_off =>
                state <= idle;
            end case;
        end if;
    end process;
    
    enable_ue <= enable;
    set_time_ue <= '1' when state = load_time else '0';
    set_target_ue <= '1' when state = load_target else '0';
    radio_on_ue <= '1' when state = radio_on else '0';
    radio_off_ue <= '1' when state = radio_off else '0';
    alarm_on_ue <= '1' when state = alarm_on else '0';
    alarm_off_ue <= '1' when state = alarm_off else '0';
end Behavioral;
