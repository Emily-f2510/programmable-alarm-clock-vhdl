library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_sim is
end clock_sim;

architecture Behavioral of clock_sim is

component top is
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
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal enable : STD_LOGIC := '0';
signal set_time : STD_LOGIC := '0';
signal set_target : STD_LOGIC := '0';
signal sel_time : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal sel_target : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal time_in : STD_LOGIC_VECTOR(16 downto 0) := (others => '0');
signal target_time : STD_LOGIC_VECTOR(16 downto 0);
signal q_time : STD_LOGIC_VECTOR(16 downto 0);
signal alarm_on : STD_LOGIC;
signal alarm_off : STD_LOGIC;
signal radio_on : STD_LOGIC;
signal radio_off : STD_LOGIC;
signal target_reached : std_logic;

begin

top_comp: top port map (
    clk => clk,
    rst => rst,
    enable => enable,
    set_time => set_time,
    set_target => set_target,
    sel_time => sel_time,
    sel_target => sel_target,
    time_in => time_in,
    target_time => target_time,
    q_time => q_time,
    alarm_on => alarm_on,
    alarm_off => alarm_off,
    radio_on => radio_on,
    radio_off => radio_off,
    target_reached_out => target_reached
);

clk_process : process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

stim_proc : process
begin
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10 ns;
    
    enable <= '0';

    sel_time <= "01";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(10, 17));--time_in primeste 10
    set_time <= '1';
    wait for 10 ns;
    set_time <= '0';
    wait for 10 ns;

    sel_time <= "10";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(15, 17));
    set_target <= '1';
    wait for 10 ns;
    set_target <= '0';
    wait for 10 ns;

    sel_time <= "00";
    sel_target <= "10";
    enable <= '1';

    wait for 410 ns;
    
    enable <= '0';
    
    
    sel_time <= "01";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(10, 17));
    set_time <= '1';
    wait for 10 ns;
    set_time <= '0';
    wait for 10 ns;
    
    sel_time <= "10";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(15, 17));
    set_target <= '1';
    wait for 10 ns;
    set_target <= '0';
    wait for 10 ns;
    
    sel_time <= "00";
    sel_target <= "00";
    enable <= '1';
    
    wait for 100 ns;
    
    enable <= '0';
     
    sel_time <= "01";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(10, 17));
    set_time <= '1';
    wait for 10 ns;
    set_time <= '0';
    wait for 10 ns;
        
    sel_time <= "10";
    wait for 10 ns;
    time_in <= std_logic_vector(to_unsigned(15, 17));
    set_target <= '1';
    wait for 10 ns;
    set_target <= '0';
    wait for 10 ns;
        
    sel_time <= "00";
    sel_target <= "01";
    enable <= '1';
        
    wait for 1000 ns;

    wait;
end process;

end Behavioral;
