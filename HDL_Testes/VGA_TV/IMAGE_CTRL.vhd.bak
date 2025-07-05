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
		red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
      green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
      blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) 
	);
END IMAGE_CTRL;
ARCHITECTURE Behavioral OF IMAGE_CTRL IS

	CONSTANT h_pixels : NATURAL := 1024; 
	CONSTANT v_pixels : NATURAL := 768;

	CONSTANT col_size : NATURAL := NATURAL(ceil(REAL(h_pixels)/7.0));
	CONSTANT black_bar : NATURAL := v_pixels - col_size;
	
	
	SIGNAL red_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL green_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL blue_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN

PROCESS (pixel_clock)
BEGIN
	IF rising_edge(pixel_clock) THEN
		IF (image_on = '1' AND pixel_y <= black_bar) THEN
			IF (pixel_x < col_size) THEN
				red_reg <= "111"; -- branco
				green_reg <= "111";
				blue_reg <= "11";
			ELSIF (pixel_x < 2 * col_size) THEN
				red_reg <= "111"; -- amarelo
				green_reg <= "111";
				blue_reg <= "00";
			ELSIF (pixel_x < 3 * col_size) THEN
				red_reg <= "000"; -- azul-claro
				green_reg <= "111";
				blue_reg <= "11";
			ELSIF (pixel_x < 4 * col_size) THEN
				red_reg <= "000"; -- verde
				green_reg <= "111";
				blue_reg <= "00";
			ELSIF (pixel_x < 5 * col_size) THEN
				red_reg <= "111"; -- rosa
				green_reg <= "000";
				blue_reg <= "11";
			ELSIF (pixel_x < 6 * col_size) THEN
				red_reg <= "111"; -- vermelho
				green_reg <= "000";
				blue_reg <= "00";
			ELSE
				red_reg <= "000"; -- azul-escuro
				green_reg <= "000";
				blue_reg <= "11";
			END IF;
		ELSE
			red_reg <= "000";  -- preto
			green_reg <= "000";
			blue_reg <= "00";
		END IF;
	END IF;
END PROCESS;

	red <= red_reg;
	green <= green_reg;
	blue <= blue_reg;
END Behavioral;