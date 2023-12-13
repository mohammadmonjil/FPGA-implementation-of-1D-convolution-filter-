-- Greg Stitt
-- University of Florida
--
-- The wrapper entity acts as a hardware abstraction layer (HAL) that provides
-- resources to user_app. In this example, the HAL provides two emulated DRAMs
-- (implemented using block RAM), in addition to a memory map. The DRAMs
-- operate on a different clock domain than the user_app.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity wrapper is
    port(
        clks : in std_logic_vector(NUM_CLKS_RANGE);
        rst  : in std_logic;

        mmap_wr_en         : in  std_logic;
        mmap_wr_addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_wr_data       : in  std_logic_vector(MMAP_DATA_RANGE);
        mmap_rd_en         : in  std_logic;
        mmap_rd_addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_rd_data       : out std_logic_vector(MMAP_DATA_RANGE);
        mmap_rd_data_valid : out std_logic
        );
end wrapper;

architecture default of wrapper is

    signal user_wr_en   : std_logic;
    signal user_wr_addr : std_logic_vector(MMAP_ADDR_RANGE);
    signal user_wr_data : std_logic_vector(MMAP_DATA_RANGE);
    signal user_rd_en   : std_logic;
    signal user_rd_addr : std_logic_vector(MMAP_ADDR_RANGE);
    signal user_rd_data : std_logic_vector(MMAP_DATA_RANGE);

    ----------------------------------------------------------
    -- DMA interface signals
    signal ram0_rd_rd_en : std_logic;
    signal ram0_rd_go    : std_logic;
    signal ram0_rd_valid : std_logic;
    signal ram0_rd_data  : std_logic_vector(RAM0_RD_DATA_RANGE);
    signal ram0_rd_addr  : std_logic_vector(RAM0_ADDR_RANGE);
    signal ram0_rd_size  : std_logic_vector(RAM0_RD_SIZE_RANGE);
    signal ram0_rd_done  : std_logic;

    signal debug_ram0_rd_count      : std_logic_vector(RAM0_RD_SIZE_RANGE);
    signal debug_ram0_rd_addr       : std_logic_vector(RAM0_ADDR_RANGE);
    signal debug_ram0_rd_start_addr : std_logic_vector(RAM0_ADDR_RANGE);
    signal debug_ram0_rd_size       : std_logic_vector(debug_ram0_rd_addr'length downto 0);
    signal debug_ram0_rd_prog_full  : std_logic;
    signal debug_ram0_rd_empty      : std_logic;

    signal debug_width_fifo_full  : std_logic;
    signal debug_width_fifo_empty : std_logic;

    signal ram1_wr_ready : std_logic;
    signal ram1_wr_go    : std_logic;
    signal ram1_wr_valid : std_logic;
    signal ram1_wr_data  : std_logic_vector(RAM1_WR_DATA_RANGE);
    signal ram1_wr_addr  : std_logic_vector(RAM1_ADDR_RANGE);
    signal ram1_wr_size  : std_logic_vector(RAM1_WR_SIZE_RANGE);
    signal ram1_wr_done  : std_logic;

    ----------------------------------------------------------
    -- Physical memory signals
    signal dram0_ready      : std_logic;
    signal dram0_wr_en      : std_logic;
    signal dram0_wr_addr    : std_logic_vector(DRAM0_ADDR_RANGE);
    signal dram0_wr_data    : std_logic_vector(DRAM0_DATA_RANGE);
    signal dram0_wr_pending : std_logic;
    signal dram0_rd_en      : std_logic;
    signal dram0_rd_addr    : std_logic_vector(DRAM0_ADDR_RANGE);
    signal dram0_rd_data    : std_logic_vector(DRAM0_DATA_RANGE);
    signal dram0_rd_valid   : std_logic;
    signal dram0_rd_flush   : std_logic;

    signal dram1_ready      : std_logic;
    signal dram1_wr_en      : std_logic;
    signal dram1_wr_addr    : std_logic_vector(DRAM1_ADDR_RANGE);
    signal dram1_wr_data    : std_logic_vector(DRAM1_DATA_RANGE);
    signal dram1_wr_pending : std_logic;
    signal dram1_rd_en      : std_logic;
    signal dram1_rd_addr    : std_logic_vector(DRAM1_ADDR_RANGE);
    signal dram1_rd_data    : std_logic_vector(DRAM1_DATA_RANGE);
    signal dram1_rd_valid   : std_logic;
    signal dram1_rd_flush   : std_logic;

    signal rst_user_r, rst_user_r_ms : std_logic;

    component dram_rd
        port (
            dram_clk             : in  std_logic;
            user_clk             : in  std_logic;
            dram_rst             : in  std_logic;
            user_rst             : in  std_logic;
            go                   : in  std_logic;
            rd_en                : in  std_logic;
            stall                : in  std_logic;
            start_addr           : in  std_logic_vector (14 downto 0);
            size                 : in  std_logic_vector (16 downto 0);
            valid                : out std_logic;
            data                 : out std_logic_vector (15 downto 0);
            done                 : out std_logic;
            debug_count          : out std_logic_vector (16 downto 0);
            debug_dma_size       : out std_logic_vector (15 downto 0);
            debug_dma_start_addr : out std_logic_vector (14 downto 0);
            debug_dma_addr       : out std_logic_vector (14 downto 0);
            debug_dma_prog_full  : out std_logic;
            debug_dma_empty      : out std_logic;
            dram_ready           : in  std_logic;
            dram_rd_en           : out std_logic;
            dram_rd_addr         : out std_logic_vector (14 downto 0);
            dram_rd_data         : in  std_logic_vector (31 downto 0);
            dram_rd_valid        : in  std_logic
            );
    end component;

    component dram_wr
        port (
            dram_clk        : in  std_logic;
            user_clk        : in  std_logic;
            dram_rst        : in  std_logic;
            user_rst        : in  std_logic;
            go              : in  std_logic;
            wr_en           : in  std_logic;
            start_addr      : in  std_logic_vector (14 downto 0);
            size            : in  std_logic_vector (16 downto 0);
            data            : in  std_logic_vector (15 downto 0);
            done            : out std_logic;
            ready           : out std_logic;
            dram_ready      : in  std_logic;
            dram_wr_en      : out std_logic;
            dram_wr_addr    : out std_logic_vector (14 downto 0);
            dram_wr_data    : out std_logic_vector (31 downto 0);
            dram_wr_pending : in  std_logic
            );
    end component;

begin

    -- Reset bridge to safely create a reset for the user domain.
    process(clks(C_CLK_USER), rst)
    begin
        if (rst = '1') then
            rst_user_r_ms <= '1';
            rst_user_r    <= '1';
        elsif (rising_edge(clks(C_CLK_USER))) then
            rst_user_r_ms <= '0';
            rst_user_r    <= rst_user_r_ms;
        end if;
    end process;

    -- Create a HAL memory map that separates memory map access to the DRAMs
    -- and the user_app memory map.
    U_WRAPPER_MMAP : entity work.wrapper_memory_map
        port map (
            clk_wrapper => clks(C_CLK_DRAM),
            clk_user    => clks(C_CLK_USER),
            rst_wrapper => rst,
            rst_user    => rst_user_r,

            wr_en         => mmap_wr_en,
            wr_addr       => mmap_wr_addr,
            wr_data       => mmap_wr_data,
            rd_en         => mmap_rd_en,
            rd_addr       => mmap_rd_addr,
            rd_data       => mmap_rd_data,
            rd_data_valid => mmap_rd_data_valid,

            dram0_wr_en      => dram0_wr_en,
            dram0_wr_addr    => dram0_wr_addr,
            dram0_wr_data    => dram0_wr_data,
            dram0_wr_pending => dram0_wr_pending,

            dram1_rd_en    => dram1_rd_en,
            dram1_rd_addr  => dram1_rd_addr,
            dram1_rd_data  => dram1_rd_data,
            dram1_rd_valid => dram1_rd_valid,

            user_wr_en   => user_wr_en,
            user_wr_addr => user_wr_addr,
            user_wr_data => user_wr_data,
            user_rd_en   => user_rd_en,
            user_rd_addr => user_rd_addr,
            user_rd_data => user_rd_data
            );


    ----------------------------------------------------------------------
    -- Instantiate the main user application

    U_USER_APP : entity work.user_app
        port map (
            --clks   => clks,
            clk => clks(C_CLK_USER),
            rst => rst_user_r,

            mmap_wr_en   => user_wr_en,
            mmap_wr_addr => user_wr_addr,
            mmap_wr_data => user_wr_data,
            mmap_rd_en   => user_rd_en,
            mmap_rd_addr => user_rd_addr,
            mmap_rd_data => user_rd_data,

            ram0_rd_rd_en => ram0_rd_rd_en,
            ram0_rd_go    => ram0_rd_go,
            ram0_rd_valid => ram0_rd_valid,
            ram0_rd_data  => ram0_rd_data,
            ram0_rd_addr  => ram0_rd_addr,
            ram0_rd_size  => ram0_rd_size,
            ram0_rd_done  => ram0_rd_done,

            debug_ram0_rd_count      => debug_ram0_rd_count,
            debug_ram0_rd_size       => debug_ram0_rd_size,
            debug_ram0_rd_addr       => debug_ram0_rd_addr,
            debug_ram0_rd_start_addr => debug_ram0_rd_start_addr,
            debug_ram0_rd_prog_full  => debug_ram0_rd_prog_full,
            debug_ram0_rd_empty      => debug_ram0_rd_empty,

            ram1_wr_ready => ram1_wr_ready,
            ram1_wr_go    => ram1_wr_go,
            ram1_wr_valid => ram1_wr_valid,
            ram1_wr_data  => ram1_wr_data,
            ram1_wr_addr  => ram1_wr_addr,
            ram1_wr_size  => ram1_wr_size,
            ram1_wr_done  => ram1_wr_done
            );

    ----------------------------------------------------------------------
    -- Instantiate DMA controllers

    -- DMA to read from RAM0
--    U_DRAM0_RD : dram_rd
--        port map (
--            -- user dma control signals
--            dram_clk   => clks(C_CLK_DRAM),
--            user_clk   => clks(C_CLK_USER),
--            dram_rst   => rst,
--            user_rst   => rst_user_r,
--            go         => ram0_rd_go,
--            rd_en      => ram0_rd_rd_en,
--            stall      => C_0,
--            start_addr => ram0_rd_addr,
--            size       => ram0_rd_size,
--            valid      => ram0_rd_valid,
--            data       => ram0_rd_data,
--            done       => ram0_rd_done,

--            -- debugging signals
--            debug_count          => debug_ram0_rd_count,
--            debug_dma_size       => debug_ram0_rd_size,
--            debug_dma_start_addr => debug_ram0_rd_start_addr,
--            debug_dma_addr       => debug_ram0_rd_addr,
--            debug_dma_prog_full  => debug_ram0_rd_prog_full,
--            debug_dma_empty      => debug_ram0_rd_empty,

--            -- dram control signals
--            dram_ready    => dram0_ready,
--            dram_rd_en    => dram0_rd_en,
--            dram_rd_addr  => dram0_rd_addr,
--            dram_rd_data  => dram0_rd_data,
--            dram_rd_valid => dram0_rd_valid);

    U_DRAM0_RD : entity work.dram_read
        port map (
            -- user dma control signals
            dram_clk   => clks(C_CLK_DRAM),
            user_clk   => clks(C_CLK_USER),
            dram_rst   => rst,
            user_rst   => rst_user_r,
            go         => ram0_rd_go,
            rd_en      => ram0_rd_rd_en,
            stall      => C_0,
            start_addr => ram0_rd_addr,
            size       => ram0_rd_size,
            valid      => ram0_rd_valid,
            data       => ram0_rd_data,
            done       => ram0_rd_done,

            -- debugging signals
            debug_count          => debug_ram0_rd_count,
            debug_dma_size       => debug_ram0_rd_size,
            debug_dma_start_addr => debug_ram0_rd_start_addr,
            debug_dma_addr       => debug_ram0_rd_addr,
            debug_dma_prog_full  => debug_ram0_rd_prog_full,
            debug_dma_empty      => debug_ram0_rd_empty,

            -- dram control signals
            dram_ready    => dram0_ready,
            dram_rd_en    => dram0_rd_en,
            dram_rd_addr  => dram0_rd_addr,
            dram_rd_data  => dram0_rd_data,
            dram_rd_valid => dram0_rd_valid);
            

    -- DMA to read from RAM1
    U_DRAM1_WR : dram_wr
        port map (
            -- user dma control signals
            dram_clk   => clks(C_CLK_DRAM),
            user_clk   => clks(C_CLK_USER),
            dram_rst   => rst,
            user_rst   => rst_user_r,
            go         => ram1_wr_go,
            wr_en      => ram1_wr_valid,
            start_addr => ram1_wr_addr,
            size       => ram1_wr_size,
            data       => ram1_wr_data,
            done       => ram1_wr_done,
            ready      => ram1_wr_ready,

            -- dram control signals
            dram_ready      => dram1_ready,
            dram_wr_en      => dram1_wr_en,
            dram_wr_addr    => dram1_wr_addr,
            dram_wr_data    => dram1_wr_data,
            dram_wr_pending => dram1_wr_pending);

    ----------------------------------------------------------------------
    -- Create the emulated DRAMs
    -- Note that there are no DRAMs inside the FPGA. This code actually uses
    -- block RAM, but does so in a way that mimics the latency and refresh of a
    -- DRAM. 

    -- Create the input DRAM (DRAM0)
    U_DRAM0 : entity work.dram_model
        generic map (
            num_words          => 2**C_DRAM0_ADDR_WIDTH,
            word_width         => C_DRAM0_DATA_WIDTH,
            addr_width         => C_DRAM0_ADDR_WIDTH,
            wr_only_when_ready => false)
        port map (
            clk        => clks(C_CLK_DRAM),
            rst        => rst,
            ready      => dram0_ready,
            wr_en      => dram0_wr_en,
            wr_addr    => dram0_wr_addr,
            wr_data    => dram0_wr_data,
            wr_pending => dram0_wr_pending,
            rd_en      => dram0_rd_en,
            rd_addr    => dram0_rd_addr,
            rd_data    => dram0_rd_data,
            rd_valid   => dram0_rd_valid);

    -- Create the output DRAM (DRAM1)
    U_DRAM1 : entity work.dram_model
        generic map (
            num_words          => 2**C_DRAM1_ADDR_WIDTH,
            word_width         => C_DRAM1_DATA_WIDTH,
            addr_width         => C_DRAM1_ADDR_WIDTH,
            rd_only_when_ready => false,
            rd_latency         => 1)
        port map (
            clk        => clks(C_CLK_DRAM),
            rst        => rst,
            ready      => dram1_ready,
            wr_en      => dram1_wr_en,
            wr_addr    => dram1_wr_addr,
            wr_data    => dram1_wr_data,
            wr_pending => dram1_wr_pending,
            rd_en      => dram1_rd_en,
            rd_addr    => dram1_rd_addr,
            rd_data    => dram1_rd_data,
            rd_valid   => dram1_rd_valid);

end default;
