-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_custom.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app is
    port (
        clk : in std_logic;
        rst : in std_logic;

        -- Memory-map interface
        mmap_wr_en   : in  std_logic;
        mmap_wr_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_wr_data : in  std_logic_vector(MMAP_DATA_RANGE);
        mmap_rd_en   : in  std_logic;
        mmap_rd_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_rd_data : out std_logic_vector(MMAP_DATA_RANGE);

        -- DMA read interface for RAM 0
        ram0_rd_rd_en : out std_logic;
        ram0_rd_go    : out std_logic;
        ram0_rd_valid : in  std_logic;
        ram0_rd_data  : in  std_logic_vector(RAM0_RD_DATA_RANGE);
        ram0_rd_addr  : out std_logic_vector(RAM0_ADDR_RANGE);
        ram0_rd_size  : out std_logic_vector(RAM0_RD_SIZE_RANGE);
        ram0_rd_done  : in  std_logic;

        debug_ram0_rd_count      : in std_logic_vector(RAM0_RD_SIZE_RANGE);
        debug_ram0_rd_start_addr : in std_logic_vector(RAM0_ADDR_RANGE);
        debug_ram0_rd_addr       : in std_logic_vector(RAM0_ADDR_RANGE);
        debug_ram0_rd_size       : in std_logic_vector(C_RAM0_ADDR_WIDTH downto 0);
        debug_ram0_rd_prog_full  : in std_logic;
        debug_ram0_rd_empty      : in std_logic;

        -- DMA write interface for RAM 1 
        ram1_wr_ready : in  std_logic;
        ram1_wr_go    : out std_logic;
        ram1_wr_valid : out std_logic;
        ram1_wr_data  : out std_logic_vector(RAM1_WR_DATA_RANGE);
        ram1_wr_addr  : out std_logic_vector(RAM1_ADDR_RANGE);
        ram1_wr_size  : out std_logic_vector(RAM1_WR_SIZE_RANGE);
        ram1_wr_done  : in  std_logic
        );
end user_app;

architecture default of user_app is

    signal go   : std_logic;
    signal clear   : std_logic;
    signal signal_size : std_logic_vector(RAM0_RD_SIZE_RANGE);
    signal done : std_logic;
    
    signal kernel_data: std_logic_vector(KERNEL_WIDTH_RANGE);
    signal kernel_load: std_logic;
    signal kernel_ready: std_logic;
    
    signal padded_signal_size : std_logic_vector(RAM0_RD_SIZE_RANGE);
    signal output_size : std_logic_vector(RAM0_RD_SIZE_RANGE);
    signal signal_buffer_wr_en :std_logic;
    signal signal_buffer_rd_en :std_logic;
    signal signal_buffer_full  :std_logic;
    signal signal_buffer_empty :std_logic;
    signal signal_buffer_output: std_logic_vector(C_KERNEL_SIZE*C_SIGNAL_WIDTH-1 downto 0);
    
    signal kernel_buffer_full, kernel_buffer_empty: std_logic;
    signal kernel_buffer_wr_en, kernel_buffer_rd_en: std_logic;
    signal kernel_rd_data: std_logic_vector(C_KERNEL_SIZE*C_SIGNAL_WIDTH-1 downto 0);
    signal kernel_data_reversed: std_logic_vector(C_KERNEL_SIZE*C_SIGNAL_WIDTH-1 downto 0);
    
    signal pipeline_en : std_logic;
    signal pipline_outdata       : std_logic_vector(C_SIGNAL_WIDTH+C_SIGNAL_WIDTH+clog2(C_KERNEL_SIZE)-1 downto 0);
    
    signal pipeline_output_valid : std_logic;
    signal pipeline_input_valid : std_logic;
    
    signal buffer_rst : std_logic;


begin

    U_MMAP : entity work.memory_map
        port map (
            clk => clk,
            rst => rst,

            wr_en   => mmap_wr_en,
            wr_addr => mmap_wr_addr,
            wr_data => mmap_wr_data,
            rd_en   => mmap_rd_en,
            rd_addr => mmap_rd_addr,
            rd_data => mmap_rd_data,

            -- circuit interface from software
--            go           => go,
--            size         => size,
--            ram0_rd_addr => ram0_rd_addr,
--            ram1_wr_addr => ram1_wr_addr,
--            done         => done,
            
            go           => go,
            clear        => clear,
            sw_rst       => open,
            signal_size  => signal_size,
            kernel_data  => kernel_data,
            kernel_load  => kernel_load,
            kernel_ready => kernel_ready,
            done         => done

            );
    buffer_rst <= rst or clear;        
    U_SIGNAL_BUFFER: entity work.sliding_buffer
    port map(
    
         clk        => clk,  
         rst        => buffer_rst,
         wr_en      => signal_buffer_wr_en,
         rd_en      => signal_buffer_rd_en,
         full       => signal_buffer_full,
         empty      => signal_buffer_empty,
         wr_data    => ram0_rd_data,
         rd_data    => signal_buffer_output
    );
    
     U_KERNEL_BUFFER: entity work.kernel_buffer
    port map(
         clk        => clk,  
         rst        => buffer_rst,
         wr_en      => kernel_buffer_wr_en,
         rd_en      => C_0,
         full       => kernel_ready,
         empty      => kernel_buffer_empty,
         wr_data    => kernel_data,
         rd_data    => kernel_data_reversed
    );
    
        -- Datapath
	U_MULT_ADD_TREE : entity work.mult_add_tree
        generic map (
		  num_inputs   => C_KERNEL_SIZE,
		  input1_width => C_SIGNAL_WIDTH,
		  input2_width => C_SIGNAL_WIDTH)
		port map (
		  clk    => clk,
		  rst    => rst,
		  en     => pipeline_en ,
		  input1 => kernel_data_reversed,
		  input2 => signal_buffer_output,
		  output => pipline_outdata);
		  
   	U_CLIPPER : entity work.clipper
	   port map(
	       rst         => rst,
	       clk         => clk,
	       en          => ram1_wr_ready,
	       clipper_in  => pipline_outdata,
	       clipper_out => ram1_wr_data
	   );
		  
    U_pipeline_valid: entity work.delay 
        generic map (CYCLES => clog2(C_KERNEL_SIZE)+2,
                     WIDTH  => 1,
                     RESET_VALUE   => "0")
        port map    (clk    => clk,       
                     rst    => rst,
                     en     => ram1_wr_ready,
                     input(0)  => pipeline_input_valid,
                     output(0) => pipeline_output_valid);
    
    pipeline_input_valid <= signal_buffer_rd_en and ram1_wr_ready;
    
--    pipeline_en <= (signal_buffer_rd_en or pipeline_output_valid) and user_app_en;
    pipeline_en <= (signal_buffer_rd_en or pipeline_output_valid) and ram1_wr_ready;
    
    padded_signal_size <= std_logic_vector(unsigned(signal_size) + 2*(C_KERNEL_SIZE-1));
--    output_size <= padded_signal_size;
    output_size <= std_logic_vector(unsigned(signal_size) + C_KERNEL_SIZE-1);

    -- signal buffer control
    signal_buffer_wr_en <= ram0_rd_valid and not (signal_buffer_full and not signal_buffer_rd_en) and ram1_wr_ready;
    signal_buffer_rd_en <= ram1_wr_ready and not signal_buffer_empty;
    
    --kernel buffer control
    kernel_buffer_wr_en <= kernel_load and ram1_wr_ready;
    
    -- RAM0 control.
    ram0_rd_go    <= go;
    ram0_rd_rd_en <= ram0_rd_valid and ram1_wr_ready;
    ram0_rd_size  <= padded_signal_size;
    ram0_rd_addr  <= (others=>'0');

    -- RAM1 control.
    ram1_wr_go    <= go;
    ram1_wr_size  <= output_size;
    -- need changes
--    ram1_wr_data  <= signal_buffer_output(C_KERNEL_SIZE*C_SIGNAL_WIDTH-1 downto C_KERNEL_SIZE*C_SIGNAL_WIDTH-C_SIGNAL_WIDTH);
--    ram1_wr_data  <= pipline_outdata(RAM1_WR_DATA_RANGE);
    ram1_wr_valid <= pipeline_output_valid and ram1_wr_ready;
    --
    
    ram1_wr_addr  <= (others=>'0');

    done <= ram1_wr_done;

end default;
