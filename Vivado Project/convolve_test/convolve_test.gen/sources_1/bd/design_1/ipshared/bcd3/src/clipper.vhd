

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.math_custom.all;
use work.config_pkg.all;
use work.user_pkg.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clipper is
    port (
		rst         : in std_logic;
		clk         : in std_logic;
		en          : in std_logic;
		clipper_in  : in std_logic_vector(C_SIGNAL_WIDTH+C_SIGNAL_WIDTH+clog2(C_KERNEL_SIZE)-1 downto 0);
		clipper_out : out std_logic_vector(C_SIGNAL_WIDTH-1 downto 0)
	);
end clipper;

architecture Behavioral of clipper is

begin
	process(clipper_in)
	begin
	if(rst='1') then
		clipper_out <= (others=>'0');
	elsif(rising_edge(clk)) then
		if(en='1') then
		
			if(clipper_in(C_SIGNAL_WIDTH+C_SIGNAL_WIDTH+clog2(C_KERNEL_SIZE)-1 downto C_SIGNAL_WIDTH) /=  std_logic_vector(to_unsigned(0, C_SIGNAL_WIDTH+clog2(C_KERNEL_SIZE)))) then
				clipper_out <= (others=>'1');
			else
				clipper_out <= clipper_in(C_SIGNAL_WIDTH-1 downto 0);
			end if;
		end if;
	end if;
	end process;
	
end Behavioral;