library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.DataStruct_param_def_header.all;--invoke our defined type and parameter

entity lane_up_condition_checker is
generic (
    constant power_on_wait_clks         : integer := 2**16 -1;
    constant wait_locked_clks           : integer := 2**16 -1;
    constant wait_alignment_done_clks   : integer := 2**8 -1;
    constant pre_lane_up_clks           : integer := 2**8 -1
);
Port (
    Reset_n                  : in  std_logic;
    all_locked               : in  std_logic;
    XCVR_Manual_rst_out      : out std_logic; --arria 10
    align_en                 : out std_logic; --arria 10
    INIT_CLK                 : in  std_logic;
    lane_up                  : out std_logic;
    RX_errdetect             : in  std_logic_vector((ctrl_code_length_per_ch -1) downto 0) := (others =>'0');
    RX_disperr               : in  std_logic_vector((ctrl_code_length_per_ch -1) downto 0) := (others =>'0')
);
end entity lane_up_condition_checker;


architecture Behavioral of lane_up_condition_checker is

    type lane_up_condition_type is --for stratix-4
        (power_on ,wait_locked,comma_align,pre_lane_up,now_xcvr_init_done);
    signal lane_up_status            : lane_up_condition_type := power_on;

    signal lane_up_r                 : std_logic := '0';
    signal XCVR_Manual_rst_out_r     : std_logic := '0';
    signal align_en_r                : std_logic := '0';
begin
    lane_up_FSM : process(INIT_CLK,Reset_n)
        variable power_on_cnt               : integer range 0 to power_on_wait_clks         := 0 ;
        variable locked_cnt                 : integer range 0 to wait_locked_clks           := 0 ;
        variable comma_align_cnt            : integer range 0 to wait_alignment_done_clks   := 0 ;
        variable pre_lane_up_cnt            : integer range 0 to pre_lane_up_clks           := 0 ;
    begin
        if (Reset_n = '0') then
            lane_up_status <= power_on ;

            lane_up_r                  <= '0';
            XCVR_Manual_rst_out_r      <= '1';
            align_en_r                 <= '0';

            power_on_cnt    := 0;
            locked_cnt      := 0;
            comma_align_cnt := 0;
            pre_lane_up_cnt  := 0;
        else
            if (rising_edge(INIT_CLK)) then
                case( lane_up_status ) is
                    when power_on =>
                        if (power_on_cnt = power_on_wait_clks) then
                            power_on_cnt            := 0;
                            lane_up_status          <= wait_locked;
                            XCVR_Manual_rst_out_r   <= '0';
                        else
                            power_on_cnt            := power_on_cnt + 1;
                            lane_up_status          <= power_on;

                            XCVR_Manual_rst_out_r   <= '1';
                            lane_up_r               <= '0';
                            align_en_r              <= '0';
                        end if;

                    when wait_locked =>
                        if (all_locked = '1') then
                            if (locked_cnt = wait_locked_clks) then
                                lane_up_status  <= comma_align;
                                locked_cnt      := 0;
                            else
                                locked_cnt      := locked_cnt + 1;
                                lane_up_status  <= wait_locked;
                            end if;
                        else
                            lane_up_status      <= wait_locked;
                            locked_cnt          := 0;
                        end if;

                    when comma_align =>
                        align_en_r <= '1';

                        if (comma_align_cnt = wait_alignment_done_clks) then
                            comma_align_cnt := 0;
                            lane_up_status <= pre_lane_up;
                        else
                            comma_align_cnt := comma_align_cnt + 1;
                            lane_up_status  <= comma_align;
                        end if;

                    when pre_lane_up =>
                        lane_up_r <= '1';

                        if (pre_lane_up_cnt = pre_lane_up_clks) then
                            pre_lane_up_cnt := 0;
                            lane_up_status <= now_xcvr_init_done;
                        else
                            pre_lane_up_cnt := pre_lane_up_cnt + 1;
                            lane_up_status  <= pre_lane_up;
                        end if;

                    when now_xcvr_init_done =>
                        if ((RX_errdetect = (RX_errdetect'range => '0')) and (RX_disperr = (RX_disperr'range => '0')) and all_locked = '1') then
                            lane_up_r               <= '1';
                            lane_up_status          <= now_xcvr_init_done ;
                            XCVR_Manual_rst_out_r   <= '0';
                        else
                            lane_up_r               <= '0';
                            lane_up_status          <= power_on ;
                            XCVR_Manual_rst_out_r   <= '1';
                        end if;
                    when others =>

                end case ;
            end if;
        end if;
    end process lane_up_FSM;

    --connect reg of output
    lane_up                     <= lane_up_r ;
    XCVR_Manual_rst_out         <= XCVR_Manual_rst_out_r;
    align_en                    <= align_en_r;
end architecture Behavioral;
