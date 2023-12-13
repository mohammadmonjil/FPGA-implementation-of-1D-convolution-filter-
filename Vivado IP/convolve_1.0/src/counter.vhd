library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.config_pkg.all;
use work.user_pkg.all;
use IEEE.NUMERIC_STD.ALL;



entity counter is
port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        count_en        : in std_logic;
        go              : in std_logic;
        size            : in std_logic_vector(C_DRAM0_SIZE_WIDTH downto 0);        
        done            : out  std_logic
        );
end counter;

architecture Behavioral of counter is
    type state_t is (IDLE, RUN);
    signal state_r             : state_t;
    signal size_r              : std_logic_vector(size'range);
    signal count_r             : std_logic_vector(size'range);
    signal done_r              : std_logic;

begin

    done <= done_r;
    
    process(clk, rst)
    begin
        if (rst = '1') then
            state_r <= IDLE;
            done_r <= '0';
            count_r <= (others => '0');
            size_r <= (others => '0');
            
        elsif (rising_edge(clk)) then
            case state_r is 
                when IDLE =>
                
                    if (go = '1') then
                        size_r <= size;
                        state_r <= RUN;
                    end if;

                when RUN =>
                    
                    if(count_en = '1') then
                        count_r <= std_logic_vector( unsigned(count_r)+1);
                    end if;
                    
                    if(count_r = std_logic_vector( unsigned(size_r)-1)) then
                        done_r <= '1';
                        state_r <= IDLE;
                    end if;
              end case;
        end if;
    end process;

end Behavioral;