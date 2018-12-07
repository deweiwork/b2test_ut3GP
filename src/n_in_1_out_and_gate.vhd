--ref:
--https://akomaenablog.blogspot.com/2008/03/vhdl-n-input-and-gate.html


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.DataStruct_param_def_header.all;--invoke our defined type and parameter


entity n_in_1_out_and_gate is    
    port (
        RST_N               : in  std_logic;
        n_in                : in  ser_data_men;
        sync_clock          : in  ser_data_men := (others =>'0');
        and_gate_out        : out std_logic
    ); 
end n_in_1_out_and_gate;

architecture n_in_1_out_and_gate_RTL of n_in_1_out_and_gate is
    signal temp_in      : ser_data_men;
    signal temp_out     : std_logic;
    component DFF_Custom is
    port(
        Q             : out std_logic;    
        Clk           : in  std_logic;  
        RST_N         : in  std_logic;  
        D             : in  std_logic  
    );
    end component DFF_Custom;
begin
    gen_DFFs_loop : for i in 0 to num_of_xcvr_ch -1 generate
        gen_DFFs : DFF_Custom
            port map(
                Q             => temp_in(i),    
                Clk           => sync_clock(i),  
                RST_N         => RST_N, 
                D             => n_in(i)
            );
    end generate gen_DFFs_loop;

    temp_out            <= and_reduce(temp_in);
    and_gate_out        <= temp_out;
end architecture n_in_1_out_and_gate_RTL;