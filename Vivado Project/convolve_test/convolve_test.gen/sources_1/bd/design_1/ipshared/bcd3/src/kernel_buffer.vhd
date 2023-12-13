----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2023 10:25:26 AM
-- Design Name: 
-- Module Name: signal_buffer - Behavioral
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
use work.user_pkg.all;
use work.math_custom.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kernel_buffer is
    port(clk        : in  std_logic;     
         rst        : in  std_logic ;
         wr_en      : in  std_logic ;
         rd_en      : in  std_logic ;
         full       : out  std_logic ;
         empty      : out  std_logic ;
         
         wr_data  : in  std_logic_vector(C_SIGNAL_WIDTH  -1 downto 0);
         rd_data : out std_logic_vector(C_KERNEL_SIZE*C_SIGNAL_WIDTH-1 downto 0));
         
end kernel_buffer;

architecture Behavioral of kernel_buffer is
    
    signal shift_registers: window(0 to C_KERNEL_SIZE-1 );
    signal shift_registers_reversed: window(0 to C_KERNEL_SIZE-1 );
    signal count_r : std_logic_vector(bitsForValue(C_KERNEL_SIZE) downto 0);
    signal empty_r, full_r : std_logic;


begin
--    empty <= empty_r;
--    full <= full_r;
    process(clk,rst)
    begin
    
        if (rst = '1') then
           
            for i in 0 to C_KERNEL_SIZE-1 loop
                shift_registers(i) <= (others => '0');
            end loop;
            
            count_r <= (others => '0');
--            empty_r <= '0';
--            full_r <= '0';
            
        elsif (rising_edge(clk)) then
            if (wr_en = '1') then
                
                shift_registers(0) <= wr_data;
                
                for i in 0 to C_KERNEL_SIZE-2 loop
                    shift_registers(i+1) <= shift_registers(i);
                end loop;
                
            end if;
            
            if(rd_en = '1' and wr_en = '0' ) then
                if (unsigned(count_r) = C_KERNEL_SIZE-1) then
                    count_r <= std_logic_vector(to_unsigned(C_KERNEL_SIZE-1, bitsForValue(C_KERNEL_SIZE)+1));
                else
                    count_r <= std_logic_vector(unsigned(count_r)-1);
                end if;
                
            elsif (rd_en = '0' and wr_en = '1' ) then
            
                if (unsigned(count_r) = C_KERNEL_SIZE) then
                    count_r <= std_logic_vector(to_unsigned(C_KERNEL_SIZE, bitsForValue(C_KERNEL_SIZE)+1));
                else
                    count_r <= std_logic_vector(unsigned(count_r)+1);
                end if;
            end if;
            
        end if;
    
    end process;
    
    process(count_r,rst)
    begin
        if(rst = '1') then
            empty <= '1';
            full <= '0';
        elsif (unsigned(count_r) < C_KERNEL_SIZE) then
            empty <= '1';
            full <= '0';
        else
            empty <= '0';
            full <= '1';
        end if;
    end process;
    
    g_REVERSE: for i in 0 to C_KERNEL_SIZE-1 generate
        shift_registers_reversed(C_KERNEL_SIZE-1-i) <= shift_registers(i);
    end generate g_REVERSE;            
    
    U_VECTORIZE : for i in 0 to C_KERNEL_SIZE-1 generate
        rd_data((i+1)*C_SIGNAL_WIDTH-1 downto i*C_SIGNAL_WIDTH) <= shift_registers_reversed(i);
    end generate;


end Behavioral;
