-- Greg Stitt
-- University of Florida

-- Entity: memory_map
-- This entity establishes connections with user-defined addresses and
-- internal FPGA components (e.g. registers and blockRAMs).
--
-- Note: Make sure to add any new addresses to user_pkg. Also, in your C code,
-- make sure to use the same constants.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity memory_map is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        wr_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        wr_data : in  std_logic_vector(MMAP_DATA_RANGE);
        rd_en   : in  std_logic;
        rd_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        rd_data : out std_logic_vector(MMAP_DATA_RANGE);

        -- Circuit interface from software        
        go           : out std_logic;
        clear        : out std_logic;
        sw_rst       : out std_logic;
        signal_size  : out std_logic_vector(RAM0_RD_SIZE_RANGE);
        kernel_data  : out std_logic_vector(KERNEL_WIDTH_RANGE);
        kernel_load  : out std_logic;
        kernel_ready : in  std_logic;
        done         : in  std_logic
        );
end memory_map;

architecture BHV of memory_map is

    signal go_r          : std_logic;
    signal clear_r       : std_logic;
    signal signal_size_r : std_logic_vector(MAX_SIGNAL_SIZE_RANGE);
    signal kernel_data_r : std_logic_vector(KERNEL_WIDTH_RANGE);
    signal kernel_load_r : std_logic;


begin

    process(clk, rst)
    begin
        if (rst = '1') then
            go_r          <= '0';
            clear_r       <= '0';
            signal_size_r <= (others => '0');
            kernel_data_r <= (others => '0');
            kernel_load_r <= '0';
            rd_data       <= (others => '0');

        elsif (rising_edge(clk)) then

            go_r          <= '0';
            clear_r       <= '0';
            kernel_load_r <= '0';

            if (wr_en = '1') then
                case wr_addr is
                    when C_GO_ADDR =>
                        go_r <= wr_data(0);

                    when C_CLEAR_ADDR =>
                        clear_r <= wr_data(0);

                    when C_SIGNAL_SIZE_ADDR =>
                        signal_size_r <= wr_data(signal_size_r'range);

                    when C_KERNEL_DATA_ADDR =>
                        kernel_data_r <= wr_data(kernel_data'range);
                        kernel_load_r <= '1';

                    when others => null;
                end case;
            end if;

            if (rd_en = '1') then

                rd_data <= (others => '0');

                case rd_addr is

                    when C_SIGNAL_SIZE_ADDR =>
                        rd_data                      <= (others => '0');
                        rd_data(signal_size_r'range) <= signal_size_r;

                    when C_KERNEL_DATA_ADDR =>
                        rd_data                      <= (others => '0');
                        rd_data(kernel_data_r'range) <= kernel_data_r;

                    when C_KERNEL_READY_ADDR =>
                        rd_data    <= (others => '0');
                        rd_data(0) <= kernel_ready;

                    when C_DONE_ADDR =>
                        rd_data    <= (others => '0');
                        rd_data(0) <= done;

                    when others => null;
                end case;
            end if;

        end if;
    end process;

    go          <= go_r;
    clear       <= clear_r;
    signal_size <= signal_size_r;
    kernel_data <= kernel_data_r;
    kernel_load <= kernel_load_r;

end BHV;
