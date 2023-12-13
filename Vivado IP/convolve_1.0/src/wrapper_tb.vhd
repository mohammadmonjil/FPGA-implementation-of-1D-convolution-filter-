-- Greg Stitt
-- University of Florida
-- EEL 5721/4720 Reconfigurable Computing
--
-- File: wrapper_tb.vhd
--
-- This testbench simulates the dram_test application from the wrapper entity
-- so that it can access the emulated DRAMs.
--
-- IMPORTANT: This is not provided as a thorough testbench. It is up to you
-- to extend it to test your own design.

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity wrapper_tb is
end wrapper_tb;

architecture behavior of wrapper_tb is

    constant TEST_SIZE  : integer := 256;
    constant MAX_CYCLES : integer := TEST_SIZE*100;

    constant MAX_MMAP_READ_CYCLES : integer := 100;
    
    
    constant CLK0_HALF_PERIOD : time := 5 ns;

    signal clks : std_logic_vector(NUM_CLKS_RANGE) := (others => '0');
    signal rst  : std_logic                        := '1';

    signal mmap_wr_en   : std_logic                         := '0';
    signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE) := (others => '0');

    signal mmap_rd_en         : std_logic                         := '0';
    signal mmap_rd_addr       : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_rd_data       : std_logic_vector(MMAP_DATA_RANGE);
    signal mmap_rd_data_valid : std_logic;

    signal sim_done : std_logic := '0';

    constant C_MMAP_CYCLES : positive := 1;

    -- function to check if the outputs is correct
    function checkOutput (
        i : integer)
        return integer is

    begin
        return i+1;
    end checkOutput;


    procedure clearMMAP (signal mmap_rd_en : out std_logic;
                         signal mmap_wr_en : out std_logic) is
    begin
        mmap_rd_en <= '0';
        mmap_wr_en <= '0';
    end clearMMAP;


    -- Read from the memory map and wait until the data is marked as valid.
    -- The result is available in mmap_rd_data upon completion.
    procedure mmap_read(constant addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
                        constant MAX_CYCLES : in  natural;
                        signal mmap_rd_addr : out std_logic_vector(MMAP_ADDR_RANGE);
                        signal mmap_rd_en   : out std_logic
                        ) is

        variable count : integer := 0;

    begin

        mmap_rd_addr <= addr;
        mmap_rd_en   <= '1';
        wait until (rising_edge(clks(0)));
        mmap_rd_en   <= '0';

        while (mmap_rd_data_valid = '0' and count < MAX_CYCLES) loop
            count := count + 1;
            wait until (rising_edge(clks(0)));
        end loop;

        if (count = MAX_CYCLES) then
            report "ERROR: MMAP read timeout.";
        end if;

    end procedure;


    -- Run dram_test with the specified starting address and size.
    -- start_addr is the 32-bit word address in memory
    -- size is the number of 16-bit words to transfer.
    procedure run_test(constant test_name  :    string;
                       constant start_addr : in natural;
                       constant size       : in natural;

                       signal mmap_wr_addr : out std_logic_vector(MMAP_ADDR_RANGE);
                       signal mmap_wr_data : out std_logic_vector(MMAP_DATA_RANGE);
                       signal mmap_wr_en   : out std_logic;
                       signal mmap_rd_addr : out std_logic_vector(MMAP_ADDR_RANGE);
                       signal mmap_rd_en   : out std_logic
                       ) is

        variable count  : integer   := 0;
        variable errors : integer   := 0;
        variable done   : std_logic := '0';

        constant MAX_DONE_CYCLES : integer := size * 20;
        
    begin

        -- Disable user mode to enable transfers to DRAM.
        mmap_wr_addr <= (others => '1');
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(0, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Write the test inputs to RAM.
        -- TODO: Adjust this to test different values. Keep in mind that this
        -- writes 32 bits, but dram_test delivers 16 bits to the datapath, so
        -- if you want to test 16-bit values, you need to pack two 16-bit values
        -- into each 32-bit word here/
        for i in 0 to size/2 + (size mod 2) - 1 loop
            mmap_wr_addr <= std_logic_vector(to_unsigned(start_addr+i, C_MMAP_ADDR_WIDTH));
            mmap_wr_en   <= '1';
            mmap_wr_data <= std_logic_vector(to_unsigned(i+1, C_MMAP_DATA_WIDTH));
            wait until rising_edge(clks(0));
        end loop;
        clearMMAP(mmap_rd_en, mmap_wr_en);

        for i in 0 to 3 loop
            wait until rising_edge(clks(0));
        end loop;

        -- Enable user mode to access user_app memory map
        mmap_wr_addr <= (others => '1');
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Specify the starting write address
        mmap_wr_addr <= C_RAM1_WR_ADDR_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(start_addr, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Specify the starting read address
        mmap_wr_addr <= C_RAM0_RD_ADDR_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(start_addr, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Specify the size (in 16-bit words).
        mmap_wr_addr <= C_SIZE_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(size, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Start user_app
        mmap_wr_addr <= C_GO_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Since the user clock domain is slower, we need to give some time for
        -- done to be cleared from previous runs.
        for i in 0 to 9 loop
            wait until (rising_edge(clks(0)));
        end loop;

        done  := '0';
        count := 0;

        -- Wait for done to be asserted.
        while done = '0' and count < MAX_DONE_CYCLES loop

            mmap_read(C_DONE_ADDR, MAX_MMAP_READ_CYCLES, mmap_rd_addr, mmap_rd_en);
            done  := mmap_rd_data(0);
            count := count + 1;
        end loop;

        if (done /= '1') then
            errors := errors + 1;
            report "ERROR: Done signal not asserted before timeout.";
        end if;

        -- Disable user mode to access DRAM.
        mmap_wr_addr <= (others => '1');
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(0, C_MMAP_DATA_WIDTH));
        wait until rising_edge(clks(0));
        clearMMAP(mmap_rd_en, mmap_wr_en);

        -- Read outputs from output memory
        for i in 0 to size/2 + (size mod 2) - 1 loop

            mmap_read(std_logic_vector(to_unsigned(start_addr + i, C_MMAP_ADDR_WIDTH)), MAX_MMAP_READ_CYCLES, mmap_rd_addr, mmap_rd_en);
            if (unsigned(mmap_rd_data) /= checkOutput(i)) then
                errors := errors + 1;
                report "Result for " & integer'image(i) &
                    " is incorrect. The output is " &
                    integer'image(to_integer(unsigned(mmap_rd_data))) &
                    " but should be " & integer'image(checkOutput(i));
            end if;
        end loop;

        report test_name & " completed. Total Errors: " & integer'image(errors);
    end procedure;

begin

    UUT : entity work.wrapper
        port map (
            clks               => clks,
            rst                => rst,
            mmap_wr_en         => mmap_wr_en,
            mmap_wr_addr       => mmap_wr_addr,
            mmap_wr_data       => mmap_wr_data,
            mmap_rd_en         => mmap_rd_en,
            mmap_rd_addr       => mmap_rd_addr,
            mmap_rd_data       => mmap_rd_data,
            mmap_rd_data_valid => mmap_rd_data_valid);

    -- Toggle clocks
    clks(0) <= not clks(0) after 5 ns when sim_done = '0' else clks(0);
    clks(1) <= not clks(1) after 7 ns when sim_done = '0' else clks(1);

    -- Main testbench code.
    process
    begin
        -- Reset circuit  
        rst <= '1';
        clearMMAP(mmap_rd_en, mmap_wr_en);
        for i in 0 to 20 loop
            wait until rising_edge(clks(0));
        end loop;

        -- Clear reset
        rst <= '0';
        for i in 0 to 20 loop
            wait until rising_edge(clks(0));
        end loop;

        -- Here are some sample tests that you can use.
        -- TODO: add whatever tests you think you need to debug.
        -- Hint: if a test is failing on the board, recreate it here.
        run_test("Test0", 3, 2, mmap_wr_addr, mmap_wr_data, mmap_wr_en, mmap_rd_addr, mmap_rd_en);

        run_test("Test1", 8, 9, mmap_wr_addr, mmap_wr_data, mmap_wr_en, mmap_rd_addr, mmap_rd_en);

        run_test("Test2", 1, 4, mmap_wr_addr, mmap_wr_data, mmap_wr_en, mmap_rd_addr, mmap_rd_en);

        run_test("Test3", 100, 10000, mmap_wr_addr, mmap_wr_data, mmap_wr_en, mmap_rd_addr, mmap_rd_en);

        run_test("TestBig", 27069, 17248, mmap_wr_addr, mmap_wr_data, mmap_wr_en, mmap_rd_addr, mmap_rd_en);

        report "SIMULATION FINISHED.";
        sim_done <= '1';
        wait;

    end process;
end behavior;
