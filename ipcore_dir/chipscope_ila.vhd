-------------------------------------------------------------------------------
-- Copyright (c) 2018 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : chipscope_ila.vhd
-- /___/   /\     Timestamp  : Mon Aug 20 23:44:15 �x�_�зǮɶ� 2018
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY chipscope_ila IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(15 downto 0);
    TRIG1: in std_logic_vector(15 downto 0);
    TRIG2: in std_logic_vector(15 downto 0);
    TRIG3: in std_logic_vector(15 downto 0);
    TRIG4: in std_logic_vector(15 downto 0);
    TRIG5: in std_logic_vector(15 downto 0);
    TRIG6: in std_logic_vector(15 downto 0);
    TRIG7: in std_logic_vector(15 downto 0);
    TRIG8: in std_logic_vector(15 downto 0);
    TRIG9: in std_logic_vector(15 downto 0));
END chipscope_ila;

ARCHITECTURE chipscope_ila_a OF chipscope_ila IS
BEGIN

END chipscope_ila_a;