----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2022 11:57:05 AM
-- Design Name: 
-- Module Name: Tx_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Tx_top is
  port ( 
    clk: in std_logic;
    reset: in std_logic;
    start: in std_logic;
    data_in: in std_logic_vector(7 downto 0);
    led_ready: out std_logic;
    data_out: out std_logic);
end Tx_top;

architecture Behavioral of Tx_top is
signal start_pulse,prueva : std_logic := '0';

  component boton_start
        port(
        clk: in std_logic;
        reset: in std_logic;
        start: in std_logic;
        start_button: out std_logic);
  end component;
  
  component Tx
  port (
        clk: in std_logic;
        reset: in std_logic;
        start: in std_logic; 
        data_in: in std_logic_vector(7 downto 0);
        serial_out: out std_logic;
        ready_tx : out std_logic);
    end component;
    
begin

   
    dut1: boton_start
        port map (
                clk  => clk,
                reset  => reset,
                start => start,
                start_button => start_pulse);
    dut2: Tx
        port map (
            clk  => clk,
            reset  => reset,
            start => start_pulse,
            data_in => data_in,
            serial_out => data_out,
            ready_tx => led_ready);    


end Behavioral;


