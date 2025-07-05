LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

ENTITY IMAGE_CTRL IS
	PORT (
		pixel_clock : IN STD_LOGIC; 
		image_on : IN STD_LOGIC;
		pixel_x : IN NATURAL; 
		pixel_y : IN NATURAL; 
		state_a : IN STD_LOGIC;
		state_x : IN STD_LOGIC;
		state_p : IN STD_LOGIC;
		state_3 : IN STD_LOGIC;
		red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
      green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
      blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) 
	);
END IMAGE_CTRL;
ARCHITECTURE Behavioral OF IMAGE_CTRL IS

	CONSTANT h_pixels : NATURAL := 1024; 
	CONSTANT v_pixels : NATURAL := 768;
	
	SIGNAL red_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL green_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL blue_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN

PROCESS (pixel_clock)
BEGIN
	IF rising_edge(pixel_clock) THEN
		IF (image_on = '1') THEN
			IF (state_a = '1') THEN -- A
				red_reg <= "000"; -- BLUE
				green_reg <= "000";
				blue_reg <= "11";
			ELSIF (state_x = '1') THEN -- X
				red_reg <= "111"; -- Purple
				green_reg <= "111";
				blue_reg <= "00";
			ELSIF (state_p = '1')  THEN-- P
				red_reg <= "000"; -- RED
				green_reg <= "111";
				blue_reg <= "00";
			ELSIF (state_3 = '1') THEN -- 3
				red_reg <= "101"; -- Purple
				green_reg <= "000";
				blue_reg <= "11";
			ELSE
				red_reg <= "111"; -- White
				green_reg <= "111";
				blue_reg <= "11";
			END IF;
		END IF;
	END IF;
END PROCESS;

	red <= red_reg;
	green <= green_reg;
	blue <= blue_reg;
END Behavioral;