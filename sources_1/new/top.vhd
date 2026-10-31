library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           set_time : in STD_LOGIC;
           set_target : in STD_LOGIC;
           sel_time : in STD_LOGIC_VECTOR (1 downto 0);
           sel_target : in STD_LOGIC_VECTOR (1 downto 0);
           time_in : in STD_LOGIC_VECTOR (16 downto 0);
           target_time : out STD_LOGIC_VECTOR (16 downto 0);
           q_time : out STD_LOGIC_VECTOR (16 downto 0);
           target_reached_out : out std_logic;
           alarm_on : out STD_LOGIC;
           alarm_off : out STD_LOGIC;
           radio_on : out STD_LOGIC;
           radio_off : out STD_LOGIC);
end top;

architecture Behavioral of top is
component ue is
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
end component;

component uc is
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
end component;

signal q_time_in : STD_LOGIC_VECTOR (16 downto 0);
signal target_reached : STD_LOGIC;
signal alarm_ok : std_logic;
signal enable_ue : std_logic;
signal set_time_ue : STD_LOGIC;
signal set_target_ue : STD_LOGIC;
signal radio_on_ue : STD_LOGIC;
signal radio_off_ue : STD_LOGIC;
signal alarm_on_ue : STD_LOGIC;
signal alarm_off_ue : std_logic;

begin

uc_comp: uc
        port map (
            clk           => clk,
            rst           => rst,
            enable        => enable,
            sel_time      => sel_time,
            sel_target    => sel_target,
            set_time      => set_time,
            set_target    => set_target,
            target_reached => target_reached,
            alarm_ok      => alarm_ok,
            enable_ue     => enable_ue,
            set_time_ue   => set_time_ue,
            set_target_ue => set_target_ue,
            radio_on_ue   => radio_on_ue,
            radio_off_ue  => radio_off_ue,
            alarm_on_ue   => alarm_on_ue,
            alarm_off_ue  => alarm_off_ue
        );

ue_comp: ue
        port map (
            clk           => clk,
            rst           => rst,
            time_in       => time_in,
            enable        => enable_ue,
            radio_on      => radio_on_ue,
            radio_off     => radio_off_ue,
            alarm_on      => alarm_on_ue,
            alarm_off     => alarm_off_ue,
            set_time      => set_time_ue,
            set_target    => set_target_ue,
            target_reached => target_reached,
            alarm_ok      => alarm_ok,
            target_time_out => target_time,
            q_time_out => q_time
        );
    
    alarm_on <= alarm_on_ue;
    alarm_off <= alarm_off_ue;
    radio_on <= radio_on_ue;
    radio_off <= radio_off_ue;
    target_reached_out <= target_reached;
    
end Behavioral;
