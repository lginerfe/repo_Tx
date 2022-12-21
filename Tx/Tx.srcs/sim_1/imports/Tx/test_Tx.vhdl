-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 16.12.2022 10:53:54 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_Tx_top is
end tb_Tx_top;

architecture tb of tb_Tx_top is

    component Tx_top
        port (clk       : in std_logic;
              reset     : in std_logic;
              start     : in std_logic;
              data_in   : in std_logic_vector (7 downto 0);
              led_ready : out std_logic;
              data_out  : out std_logic);
    end component;

    signal clk       : std_logic;
    signal reset     : std_logic;
    signal start     : std_logic;
    signal data_in   : std_logic_vector (7 downto 0);
    signal led_ready : std_logic;
    signal data_out  : std_logic;

    constant TbPeriod : time := 100000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Tx_top
    port map (clk       => clk,
              reset     => reset,
              start     => start,
              data_in   => data_in,
              led_ready => led_ready,
              data_out  => data_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start <= '0';
        data_in <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 100 ns;
        start <= '1';
		data_in <= "01010101";
        wait for 1000000 ns;
          start <= '0';
        -- EDIT Add stimuli here
        wait for 1500 * TbPeriod;
        reset <= '0';
        reset <= '1';
		start <= '1';
		data_in <= "01111110";
        wait for 1000000 ns;
        start <= '0';
                wait for 1500 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
