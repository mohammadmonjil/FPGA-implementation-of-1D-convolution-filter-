-- Greg Stitt
-- University of Florida
--
-- File: dram_addr_gen.vhd
-- Entity: DRAM_ADDR_GEN
--
-- Description: This entity is an address generator for DRAM. The addr gen
-- waits until the go signal is asserted, and then creates "transfer_size"
-- addresses, once per cycle. If the stall signal is assert, the address
-- generator stalls. For each address, the addr gen outputs DRAM control
-- signals based on the "rd_wr" signal.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-------------------------------------------------------------------------------
-- Generic
-- addr_width: width of the address signal

-- Port
-- clk: clock
-- rst (active hi): reset
-- go (active hi): starts the address generators
-- rd_wr: specifies a read/write (rd = 0, wr = 1)
-- stall (active hi): stalls the address generator
-- addr_start: the address to start from
-- addr_out: the generated address
-- done (active hi): specifies that all addresses have been generated
-- dram_ld_n (active lo): load a read or write command
-- dram_rw_n: specifies a rd/wr to the DRAM (RD = 1, WR = 0)
-------------------------------------------------------------------------------

entity DRAM_ADDR_GEN is
    generic(addr_width : natural);
    port(clk        : in  std_logic;
         rst        : in  std_logic;
         go         : in  std_logic;
         size       : in  std_logic_vector(addr_width downto 0);
         stall      : in  std_logic;
         stop       : in  std_logic;
         addr_start : in  std_logic_vector(addr_width-1 downto 0);
         addr_out   : out std_logic_vector(addr_width-1 downto 0);
         addr_valid : out std_logic
         );
end DRAM_ADDR_GEN;

architecture bhv of DRAM_ADDR_GEN is

    type STATE_TYPE is (S_START, S_ADDR);
    signal state, next_state : STATE_TYPE;

    signal addr_current      : unsigned(addr_width-1 downto 0);
    signal next_addr_current : unsigned(addr_width-1 downto 0);

begin

    process(clk, rst)
    begin
        if (rst = '1') then
            addr_current <= (others => '0');
            state        <= S_START;
        elsif (clk = '1' and clk'event) then
            addr_current <= next_addr_current;
            state        <= next_state;
        end if;
    end process;

    process(go, stall, stop, addr_start, addr_current, state)
    begin

        addr_out          <= (others => '0');
        next_addr_current <= addr_current;
        next_state        <= state;
        addr_valid        <= '0';

        case state is

            -- wait until go becomes 1
            when S_START =>

                next_addr_current <= unsigned(addr_start);

                if (go = '1') then
                    next_state <= S_ADDR;
                end if;

            -- output addresses until stop is asserted
            when S_ADDR =>

                addr_out <= std_logic_vector(addr_current);

                if (stop = '1') then
                    next_state <= S_START;
                elsif (stall = '1') then
                    next_addr_current <= addr_current;
                else
                    addr_valid        <= '1';
                    next_addr_current <= addr_current + 1;
                end if;

            when others => null;
        end case;
    end process;
end bhv;
