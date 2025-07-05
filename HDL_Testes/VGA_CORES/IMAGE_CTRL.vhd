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

	CONSTANT col_size : NATURAL := 128; -- 1024 / 8 -> 8 bits vermelhos
	CONSTANT lin_size : NATURAL := 96; -- 768 / 8 -> 8 bits verdes
	
	SIGNAL pixel_reg : NATURAL := 0;
	
	SIGNAL red_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL green_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL blue_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN

PROCESS (pixel_clock)
	VARIABLE place_x, place_y, place_b, counter : NATURAL;
BEGIN
	IF rising_edge(pixel_clock) THEN
		IF (image_on = '1') THEN
			place_x := pixel_x / col_size;
			place_y := pixel_y / lin_size;
			
			IF (counter = 96) THEN
				counter := 0;
			END IF;
				
			place_b := counter / (lin_size / 4); -- cada linha tem tamanho 96 divide nos 4 valores possiveis de azul
			
			red_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(place_x, 3));
			green_reg <= STD_LOGIC_VECTOR(TO_UNSIGNED(place_y, 3));
			blue_reg <= STD_LOGIc_VECTOR(TO_UNSIGNED(place_b, 2));
			
			IF (pixel_reg /= pixel_y) THEN -- apenas incrementa quando y muda, para contar até 96 coerentemente
				counter := counter + 1;
			END IF;
			
			pixel_reg <= pixel_y;
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