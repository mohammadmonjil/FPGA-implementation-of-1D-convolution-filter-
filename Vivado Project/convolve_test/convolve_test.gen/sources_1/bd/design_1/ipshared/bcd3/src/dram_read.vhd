----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2023 11:54:17 AM
-- Design Name: 
-- Module Name: dram_read - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library xpm;
use xpm.vcomponents.all;

use work.config_pkg.all;
use work.user_pkg.all;


entity dram_read is
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
end dram_read;

architecture Behavioral of dram_read is
    signal size_converted : std_logic_vector(C_DRAM0_SIZE_WIDTH-1 downto 0); -- This size is one bit less than the input size
    signal stall_address_generator, fifo_full, fifo_empty: std_logic;
    signal debug_valid_address, valid_address: std_logic;
    signal fifo_in_data : std_logic_vector(dram_rd_data'range);
    signal prog_full: std_logic;
    signal wr_rst_busy, rd_rst_busy : std_logic;
    signal fifo_rd_en, fifo_wr_en : std_logic;
    
    signal start_addr_synced : std_logic_vector(start_addr'range);
    signal size_converted_synced : std_logic_vector(size_converted'range);
    signal req_to_addressgen : std_logic; 
    signal bus_in ,bus_out : std_logic_vector(C_DRAM0_ADDR_WIDTH + C_DRAM0_SIZE_WIDTH -1 downto 0 );
    
    COMPONENT fifo_generator_0
        PORT (
            rst : IN STD_LOGIC;
            wr_clk : IN STD_LOGIC;
            rd_clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC;
            prog_full : OUT STD_LOGIC;
            wr_rst_busy : OUT STD_LOGIC;
            rd_rst_busy : OUT STD_LOGIC 
         );
        END COMPONENT;  
begin

    process(size)
    begin
        if (size(0) = '0') then
            size_converted <= size(C_DRAM0_SIZE_WIDTH downto 1);
        else
            size_converted <= std_logic_vector( unsigned(size(C_DRAM0_SIZE_WIDTH downto 1))+1 ) ;
        end if;
    end process;
    
    fifo_in_data(31 downto 16) <= dram_rd_data(15 downto 0);
    fifo_in_data(15 downto 0) <= dram_rd_data(31 downto 16);   
    
    fifo_rd_en <= rd_en and (not fifo_empty);
    fifo_wr_en <= dram_rd_valid;
      
    valid <= (not fifo_empty);        -- valid data in fifo output
    stall_address_generator <= prog_full or not dram_ready;
    
    bus_in <= start_addr & size_converted;
    
    xpm_cdc_handshake_address : xpm_cdc_handshake
        generic map (
            DEST_EXT_HSK => 0, -- DECIMAL; 0=internal handshake, 1=external handshake
            DEST_SYNC_FF => 4, -- DECIMAL; range: 2-10
            INIT_SYNC_FF => 0, -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
            SIM_ASSERT_CHK => 0, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            SRC_SYNC_FF => 4, -- DECIMAL; range: 2-10
            WIDTH => C_DRAM0_ADDR_WIDTH + C_DRAM0_SIZE_WIDTH -- DECIMAL; range: 1-1024
            )
        port map (
            dest_out => bus_out, -- WIDTH-bit output: Input bus (src_in) synchronized to destination clock domain.
            dest_req => req_to_addressgen,
            src_rcv => open, 
            dest_ack => '0', -- 1-bit input: optional; required when DEST_EXT_HSK = 1
            dest_clk => dram_clk, -- 1-bit input: Destination clock.
            src_clk => user_clk, -- 1-bit input: Source clock.
            src_in => bus_in, -- WIDTH-bit input: Input bus that will be synchronized to the destination clock
            src_send => go 
    );
    
   U_ADDRESS_GEN: entity work.address_generator
        port map(
            clk             => dram_clk,
            rst             => dram_rst,
            en              => dram_ready,
            go              => req_to_addressgen,
--            size            => size_converted,
--            start_address   => start_addr,
            size            => bus_out(C_DRAM0_SIZE_WIDTH-1 downto 0),
            start_address   => bus_out(C_DRAM0_ADDR_WIDTH + C_DRAM0_SIZE_WIDTH -1 downto C_DRAM0_SIZE_WIDTH),
            done            => open,
            address_out     => dram_rd_addr,
            valid_address   => dram_rd_en,
            stall           => stall_address_generator
        
        ); 
    
    DMA_READ_FIFO : fifo_generator_0
        PORT MAP (
            rst         => dram_rst,
            wr_clk      => dram_clk,
            rd_clk      => user_clk,
            din         => fifo_in_data,
            wr_en       => fifo_wr_en,
            rd_en       => fifo_rd_en,
            dout        => data,
            full        => fifo_full,
            empty       => fifo_empty,
            prog_full   => prog_full,
            wr_rst_busy => open,
            rd_rst_busy => open
        );
    
    -- DMA done generator
    U_COUNTER: entity work.counter
        port map(
            clk         => user_clk,
            rst         => user_rst,
            count_en    => fifo_rd_en,
            go          => go,
            size        => size,      
            done        => done
        );

end Behavioral;