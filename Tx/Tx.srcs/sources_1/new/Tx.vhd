----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2022 12:14:34 PM
-- Design Name: 
-- Module Name: Tx - Behavioral
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

entity Tx is
  port (
        clk: in std_logic;
        reset: in std_logic;
        start: in std_logic; 
        data_in: in std_logic_vector(7 downto 0);
        serial_out: out std_logic;
        ready_tx : out std_logic);
end Tx;

architecture Behavioral of Tx is
constant baud_rate  : integer := 9600;
constant clk_rate   : integer := 100000;

--constant clk_width_max  : integer := clk_rate/baud_rate;
constant clk_width_max  : integer := clk_rate/baud_rate;
constant count_bit_max  : integer := 10;

signal clk_width        : integer range 0 to clk_width_max-1;
signal count_bit        : integer range 0 to count_bit_max-1;

signal data_in_reg      : std_logic_vector(7 downto 0);

signal ready         : std_logic := '0';

type state_type is (init, send_start, send_data, send_stop);
signal pres_state, nxt_state    : state_type;

signal max_widht        : std_logic := '0';
signal max_bit          : std_logic := '0'; 
signal serial_out_reg   : std_logic := '1';
signal done				: std_logic;
signal data_correct     : std_logic := '1';

begin

ready_tx <= ready;
serial_out <= serial_out_reg;

-- actualizar estado
actualiza: process (clk, reset)
begin
  if reset = '0' then
    pres_state <= init;
  elsif rising_edge (clk) then
    pres_state <= nxt_state;   
  end if;   
end process actualiza;

-- tr ansicione,
transition: process (pres_state, start, max_widht, count_bit, ready)
begin
    case pres_state is
    when init => 
            if start = '1' then
                nxt_state <= send_start;
            else
                nxt_state <= init;
            end if;
            
    when send_start=> 
            if (ready = '0') then
                nxt_state <=  send_data;
            else
                nxt_state <=  send_start;
            end if;
    when send_data => 
            if (count_bit = 8 )then 
                nxt_state <=  send_stop;
            else
                nxt_state <=  send_data;
            end if;
    when send_stop => 
            if (ready = '1') then 
                nxt_state <=  init;
            else
                nxt_state <=  send_stop;
            end if;
    when others => 
            nxt_state <= init;
    
    end case;
end process transition;

-- actuacion estados
actions: process (pres_state, max_widht, max_bit)
begin
    case pres_state is
    when init =>
     		ready <= '1';
    when send_start=>
            ready <= '0';
            data_in_reg <= data_in;
            serial_out_reg <= '0';
    when send_data =>
            if (max_widht = '1') then
                serial_out_reg <= data_in_reg(count_bit-1);
             end if;  
    when send_stop =>
    		if (max_widht = '1') then
              	serial_out_reg <= '1';
            elsif (max_bit = '1') then
                data_correct <= '0';
                ready <= '1';
            end if;
    when others => 
                
    end case;
end process actions;

-- reloj ancho y bits
baud : process (clk,reset,ready,clk_width)
begin
    if reset ='0' then
        clk_width <= 0;
        max_widht <= '0';
    elsif rising_edge (clk) and (ready = '0') then
        if (clk_width = clk_width_max-1) then
            clk_width <= 0;
            max_widht <= '1';
        else
            clk_width <= clk_width +1;
            max_widht <= '0';
         end if;
    end if;    
end process baud;

-- reloj bits
rang : process (clk,reset,ready,clk_width,count_bit)
begin
    if reset ='0' then
        count_bit <= 0;
        max_bit <= '0';
    elsif rising_edge (clk) and (ready = '0') and (clk_width = clk_width_max-1) then
        if (count_bit = count_bit_max-1) then
             count_bit <= 0;
             max_bit <= '1'; 
         else
              count_bit <= count_bit + 1;
              max_bit <= '0'; 
         end if;
    end if;    
end process rang;

end Behavioral;

