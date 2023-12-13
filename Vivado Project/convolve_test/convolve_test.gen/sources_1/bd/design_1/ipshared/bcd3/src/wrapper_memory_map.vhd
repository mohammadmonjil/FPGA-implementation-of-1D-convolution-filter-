-- Greg Stitt
-- University of Florida
--
-- This entity provides a memory map controller that shares the address space
-- across two clock domains: one for "dram" (emulated with block RAM) and one
-- for the user_app entity.
--
--
-- The entity uses a user_mode register that is mapped to the highest address.
-- When user_mode is '0', all memory map reads and writes go to the DRAMs.
-- When user_mode is '1', all memory map reads and writes go to user_app.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;

entity wrapper_memory_map is
    port (
        clk_wrapper   : in  std_logic;
        clk_user      : in  std_logic;
        rst_wrapper   : in  std_logic;
        rst_user      : in  std_logic;

        -- Primary memory-map interface
        wr_en         : in  std_logic;
        wr_addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
        wr_data       : in  std_logic_vector(MMAP_DATA_RANGE);
        rd_en         : in  std_logic;
        rd_addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
        rd_data       : out std_logic_vector(MMAP_DATA_RANGE);
        rd_data_valid : out std_logic;

        -- Signals to allow software to access DRAM (uses clk_wrapper)
        dram0_wr_en      : out std_logic;
        dram0_wr_addr    : out std_logic_vector(DRAM0_ADDR_RANGE);
        dram0_wr_data    : out std_logic_vector(DRAM0_DATA_RANGE);
        dram0_wr_pending : in  std_logic;

        dram1_rd_en    : out std_logic;
        dram1_rd_addr  : out std_logic_vector(DRAM1_ADDR_RANGE);
        dram1_rd_data  : in  std_logic_vector(DRAM1_DATA_RANGE);
        dram1_rd_valid : in  std_logic;

        -- MMAP interface for user_app (on clk_user clock domain)
        user_wr_en   : out std_logic;
        user_wr_addr : out std_logic_vector(MMAP_ADDR_RANGE);
        user_wr_data : out std_logic_vector(MMAP_DATA_RANGE);
        user_rd_en   : out std_logic;
        user_rd_addr : out std_logic_vector(MMAP_ADDR_RANGE);
        user_rd_data : in  std_logic_vector(MMAP_DATA_RANGE)
        );
end wrapper_memory_map;

architecture BHV of wrapper_memory_map is

    signal is_dram_rd : std_logic;
    signal is_dram_wr : std_logic;
    signal is_mmap_rd : std_logic;
    signal is_mmap_wr : std_logic;
    signal mmap_addr  : std_logic_vector(wr_addr'range);

    signal request_fifo_wr_en       : std_logic;
    signal request_fifo_rd_en       : std_logic;
    signal request_fifo_full        : std_logic;
    signal request_fifo_empty       : std_logic;
    signal request_fifo_wr_data     : std_logic_vector(50 downto 0);
    signal request_fifo_rd_data     : std_logic_vector(50 downto 0);
    signal request_fifo_rd_rst_busy : std_logic;
    signal request_fifo_wr_rst_busy : std_logic;

    signal rd_data_fifo_wr_en       : std_logic;
    signal rd_data_fifo_rd_en       : std_logic;
    signal rd_data_fifo_full        : std_logic;
    signal rd_data_fifo_empty       : std_logic;
    signal rd_data_fifo_rd_data     : std_logic_vector(rd_data'range);
    signal rd_data_fifo_rd_rst_busy : std_logic;
    signal rd_data_fifo_wr_rst_busy : std_logic;

    signal user_rd_wr : std_logic;
    signal user_addr  : std_logic_vector(user_wr_addr'range);

    signal user_rd_data_valid_r : std_logic;
    signal user_rd_en_s         : std_logic;

    signal user_mode_r : std_logic;

    component mmap_data_fifo
        port (
            rst         : in  std_logic;
            wr_clk      : in  std_logic;
            rd_clk      : in  std_logic;
            din         : in  std_logic_vector(31 downto 0);
            wr_en       : in  std_logic;
            rd_en       : in  std_logic;
            dout        : out std_logic_vector(31 downto 0);
            full        : out std_logic;
            empty       : out std_logic;
            wr_rst_busy : out std_logic;
            rd_rst_busy : out std_logic
            );
    end component;

    component mmap_request_fifo
        port (
            rst         : in  std_logic;
            wr_clk      : in  std_logic;
            rd_clk      : in  std_logic;
            din         : in  std_logic_vector(50 downto 0);
            wr_en       : in  std_logic;
            rd_en       : in  std_logic;
            dout        : out std_logic_vector(50 downto 0);
            full        : out std_logic;
            empty       : out std_logic;
            wr_rst_busy : out std_logic;
            rd_rst_busy : out std_logic
            );
    end component;

begin

    -- Create the user_mode_r register.
    process(clk_wrapper, rst_wrapper)
    begin
        if (rst_wrapper = '1') then
            user_mode_r <= '0';
        elsif (rising_edge(clk_wrapper)) then
            if (wr_en = '1') then
                if (wr_addr = (wr_addr'range => '1')) then
                    user_mode_r <= wr_data(0);
                end if;
            end if;

            -- Debugging code
            -- Don't uncomment without commenting out everything else in
            -- the architecture.
            -- rd_data_valid <= '0';

            -- if (rd_en = '1') then
            --     rd_data <= (others => '0');
            --     if (rd_addr = (rd_addr'range => '1')) then
            --         rd_data(0) <= user_mode_r;
            --     else
            --         rd_data <= std_logic_vector(to_unsigned(70, rd_data'length));
            --     end if;


        --     rd_data_valid <= '1';
        -- end if; 
        end if;
    end process;

    -- Check is the current request is for the DRAM.
    is_dram_rd <= '1' when rd_en = '1' and user_mode_r = '0' and rd_addr /= (rd_addr'range => '1') else '0';

    is_dram_wr <= '1' when wr_en = '1' and user_mode_r = '0' and wr_addr /= (wr_addr'range => '1') else '0';

    -- DRAM read logic
    dram1_rd_addr <= rd_addr(dram1_rd_addr'range);
    dram1_rd_en   <= is_dram_rd;

    -- DRAM write logic
    dram0_wr_en   <= is_dram_wr;
    dram0_wr_addr <= wr_addr(dram0_wr_addr'range);
    dram0_wr_data <= wr_data(dram0_wr_data'range);

    -- Check if the current request is for the user_app memory map.
    is_mmap_rd <= '1' when rd_en = '1' and user_mode_r = '1' and rd_addr /= (rd_addr'range => '1') else '0';
    is_mmap_wr <= '1' when wr_en = '1' and user_mode_r = '1' and wr_addr /= (wr_addr'range => '1') else '0';
    
    -- Write to the request FIFO when there is a user read or write and the FIFO
    -- isn't full, and the FIFO isn't busy being reset.
    request_fifo_wr_en <= (is_mmap_rd or is_mmap_wr) and not request_fifo_full and not request_fifo_wr_rst_busy;

    mmap_addr <= wr_addr when is_mmap_wr = '1' else rd_addr;

    -- This FIFO stores the rd/wr status, the wr data (if any) and the mmap
    -- address.
    request_fifo_wr_data <= is_mmap_wr & wr_data & mmap_addr;

    -- FIFO to send memory-map requests across clock domains.
    -- NOTE: There is no mechanism to stall incoming requests if the FIFO
    -- is full. That is unlikely to be a problem considering that requests
    -- arrive very slowly, but this might need to change if AXI burst support
    -- is added.
    U_MMAP_REQUEST_FIFO : mmap_request_fifo port map (
        rst         => rst_wrapper,
        wr_clk      => clk_wrapper,
        rd_clk      => clk_user,
        din         => request_fifo_wr_data,
        wr_en       => request_fifo_wr_en,
        rd_en       => request_fifo_rd_en,
        dout        => request_fifo_rd_data,
        full        => request_fifo_full,
        empty       => request_fifo_empty,
        wr_rst_busy => request_fifo_wr_rst_busy,
        rd_rst_busy => request_fifo_rd_rst_busy
        );


    -- Handle requests anytime they arrive.
    request_fifo_rd_en <= not request_fifo_empty and not request_fifo_rd_rst_busy;

    user_rd_wr <= request_fifo_rd_data(request_fifo_rd_data'left);
    user_addr  <= request_fifo_rd_data(17 downto 0);

    -- Create the user_app memory map requests.
    user_wr_en   <= request_fifo_rd_en and user_rd_wr;
    user_wr_addr <= user_addr;
    user_wr_data <= request_fifo_rd_data(49 downto 18);

    user_rd_en_s <= request_fifo_rd_en and not user_rd_wr;
    user_rd_en   <= user_rd_en_s;
    user_rd_addr <= user_addr;

    -- Read data from user mmemory-map requests has to cross clock domains,
    -- so use another FIFO.
    U_MMAP_RD_DATA_FIFO : mmap_data_fifo port map (
        rst         => rst_user,
        wr_clk      => clk_user,
        rd_clk      => clk_wrapper,
        din         => user_rd_data,
        wr_en       => rd_data_fifo_wr_en,
        rd_en       => rd_data_fifo_rd_en,
        dout        => rd_data_fifo_rd_data,
        full        => rd_data_fifo_full,
        empty       => rd_data_fifo_empty,
        wr_rst_busy => rd_data_fifo_wr_rst_busy,
        rd_rst_busy => rd_data_fifo_rd_rst_busy
        );

    -- User read data must be valid one cycle after the request.
    process(clk_user, rst_user)
    begin
        if (rst_user = '1') then
            user_rd_data_valid_r <= '0';
        elsif (rising_edge(clk_user)) then
            user_rd_data_valid_r <= user_rd_en_s;
        end if;
    end process;

    -- Write to the read data FIFO anytime the read data is valid.
    rd_data_fifo_wr_en <= user_rd_data_valid_r and not rd_data_fifo_wr_rst_busy;

    -- Read from the read data FIFO anytime it has data.
    rd_data_fifo_rd_en <= not rd_data_fifo_empty and not rd_data_fifo_rd_rst_busy;
    
    -- Read data is valid whenever data is read from the rd_data FIFO, or when
    -- the DRAM provides data.
    rd_data_valid <= rd_data_fifo_rd_en or dram1_rd_valid;

    -- Mux to select the rd_data source.
    rd_data <= rd_data_fifo_rd_data when rd_data_fifo_rd_en = '1' else dram1_rd_data;

end BHV;
