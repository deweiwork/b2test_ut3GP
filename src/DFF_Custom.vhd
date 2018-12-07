--ref:
--https://www.fpga4student.com/2017/02/vhdl-code-for-d-flip-flop.html

Library IEEE;
USE IEEE.Std_logic_1164.all;

entity DFF_Custom is 
   port(
      Q             : out std_logic;    
      Clk           : in  std_logic;  
      RST_N         : in  std_logic;  
      D             : in  std_logic  
   );
end DFF_Custom ;

architecture DFF_Behavioral of DFF_Custom is  
begin  
    process(Clk,RST_N)
    begin 
        if(RST_N='0') then 
            Q <= '0';
        elsif(rising_edge(Clk)) then
            Q <= D; 
        end if;      
    end process;  
end DFF_Behavioral; 