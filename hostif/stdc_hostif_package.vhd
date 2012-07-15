library ieee;
use ieee.std_logic_1164.all;

package stdc_hostif_package is

component stdc_hostif is
	port(
		sys_rst_i: in std_logic;
		sys_clk_i: in std_logic;
		
		serdes_clk_i: in std_logic;
		serdes_strobe_i: in std_logic;
		
		wb_addr_i: in std_logic_vector(31 downto 0);
		wb_data_i: in std_logic_vector(31 downto 0);
		wb_data_o: out std_logic_vector(31 downto 0);
		wb_cyc_i: in std_logic;
		wb_sel_i: in std_logic_vector(3 downto 0);
		wb_stb_i: in std_logic;
		wb_we_i: in std_logic;
		wb_ack_o: out std_logic;
		irq_o: out std_logic;
		
		signal_i: in std_logic;
		
		cc_rst_i: in std_logic;
		cc_cy_o: out std_logic
	);
end component;

end package;
