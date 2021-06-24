----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2021 02:15:35 PM
-- Design Name: 
-- Module Name: FA - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity FA_X1 is
     Port ( A : in STD_LOGIC;
     B : in STD_LOGIC;
     CI : in STD_LOGIC;
     S : out STD_LOGIC;
     CO : out STD_LOGIC);
end FA_X1;
 
architecture gate_level of FA_X1 is
 
begin
 
 S <= A XOR B XOR CI ;
 CO <= (A AND B) OR (CI AND A) OR (CI AND B) ;
 
end gate_level;

