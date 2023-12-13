library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.config_pkg.all;
use work.user_pkg.all;
use IEEE.NUMERIC_STD.ALL;



entity address_generator is
port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        en              : in std_logic;
        go              : in std_logic;
        size            : in std_logic_vector(C_DRAM0_SIZE_WIDTH-1 downto 0);
        start_address   : in std_logic_vector(C_DRAM0_ADDR_WIDTH-1 downto 0);
        stall           : in std_logic;
        
        done            : out  std_logic;
        address_out     : out std_logic_vector(C_DRAM0_ADDR_WIDTH-1 downto 0);
        valid_address   : out std_logic
        );
end address_generator;

architecture Behavioral of address_generator is
--    type state_t is (IDLE, WAIT_FOR_EN, RUN);
        type state_t is (IDLE, WAIT_for_EN,RUN);
    signal state_r, next_state : state_t;
    signal address_r, next_address     : std_logic_vector(C_DRAM0_ADDR_WIDTH-1 downto 0);
    signal count_r, next_count : std_logic_vector(C_DRAM0_SIZE_WIDTH-1 downto 0);
    signal done_r, next_done, valid_address_r, next_valid_address : std_logic;

begin

--    address_out <= address_r;
--    valid_address <= valid_address_r;
--    done <= done_r;
    
    address_out <= next_address;
    valid_address <= next_valid_address;
    done <= next_done;
    
    process(clk, rst)
    begin
        if (rst = '1') then
            state_r <= IDLE;
            done_r <= '0';
            valid_address_r <= '0';
            address_r <= (others => '0');
            count_r <= (others => '0');

        elsif (rising_edge(clk)) then
            state_r <= next_state;
            done_r <= next_done;
            valid_address_r <= next_valid_address;
            address_r <= next_address;
            count_r <= next_count;

        end if;
    end process;
    
    process(state_r,go,en,done_r,valid_address_r,address_r, stall)
     variable temp_address: unsigned(next_address'range);
     variable upper_count: unsigned(size'range);
    begin
        next_state <= state_r;
        next_done <= done_r;
        next_valid_address <= valid_address_r;
        next_address <= address_r;
                    
        case state_r is 
        
            when IDLE =>
--                next_address <= (others=>'0');
                next_address <= start_address;
                next_valid_address <= '0';
                
                if(go = '1') and (en = '1') then
                    next_done <= '0';
                    next_valid_address <= '1';
                    next_state <= RUN;
                    
                elsif (go = '1') and (en = '0')  then
                    next_state <= WAIT_for_EN;
                    next_done <= '0';
                end if;
                
               when WAIT_for_EN =>
               
                    if( en = '1') then
                        next_valid_address <= '1';
                        next_state <= RUN;
                    end if;
                    
               when RUN =>
               
               if (stall = '0') then
               
                    temp_address:= unsigned(address_r) + 1;
                    next_address <= std_logic_vector(temp_address);  
                    next_valid_address <= '1';
                    
                    upper_count := unsigned('0' & start_address) + unsigned(size) - TO_UNSIGNED(1, C_DRAM0_SIZE_WIDTH-1);
    
                    if ('0'& address_r = std_logic_vector(upper_count)) then
                
                        next_state <= IDLE;
                        next_done <= '1';
                        next_valid_address <= '0';
                    
                     end if;
                     
                 else
                    next_valid_address <= '0';
                 end if;
                 
         end case;

    end process;

end Behavioral;