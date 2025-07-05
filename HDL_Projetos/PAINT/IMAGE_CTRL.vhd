LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY IMAGE_CTRL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		image_on : IN STD_LOGIC; --display enable 
		pixel_x : IN NATURAL RANGE 0 TO 1023;  --coordenada X
		pixel_y : IN NATURAL RANGE 0 TO 767; --coordenada Y
		w_col_addr : IN NATURAL RANGE 0 TO n_blocks - 1;
		w_lin_addr : IN NATURAL RANGE 0 TO n_lin - 1;
		out_data : IN NATURAL RANGE 0 TO 9;
		tmp_data : IN NATURAL RANGE 0 TO 9;
		r_col_addr : OUT NATURAL RANGE 0 TO n_blocks - 1;
		r_lin_addr : OUT NATURAL RANGE 0 TO n_lin - 1;
		red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
      green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
      blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 2 bits

	);
END IMAGE_CTRL;
ARCHITECTURE Behavioral OF IMAGE_CTRL IS		
	SIGNAL red_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL green_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL blue_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	
	SIGNAL cnt_x : NATURAL RANGE 0 TO block_width := 0;
	SIGNAL x_ind : NATURAL RANGE 0 TO n_blocks - 1 := 0;
	SIGNAL cnt_Y : NATURAL RANGE 0 TO block_width := 0;
	SIGNAL y_ind : NATURAL RANGE 0 TO n_blocks - 1 := 0;

BEGIN
	PROCESS (pixel_clock)
	VARIABLE cor : NATURAL RANGE 0 TO 9;
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF ((pixel_x < border OR pixel_x >=  127 * border) OR (pixel_y < border OR pixel_y >= 95 * border)) THEN
				red_reg <= "011"; -- grey
				green_reg <= "011";
				blue_reg <= "01";
				
			ELSIF (pixel_x >= border AND pixel_x < h_pixels - border) AND
					(pixel_y >= border AND pixel_y < v_pixels - border) THEN
					
				IF (cnt_x = block_width - 1) THEN
					cnt_x <= 0;
					IF (x_ind = n_blocks - 1) THEN
						x_ind <= 0;
						IF (cnt_y = block_height - 1) THEN
							cnt_y <= 0;
							IF (y_ind = n_lin - 1) THEN
								y_ind <= 0;
							ELSE
								y_ind <= y_ind + 1;
							END IF;
						ELSE
							cnt_y <= cnt_y + 1;
						END IF;
					ELSE
						x_ind <= x_ind + 1;
					END IF;
				ELSE
					cnt_x <= cnt_x + 1;
				END IF;
				
				IF (pixel_x < border + (x_ind + 1) * (block_width) AND pixel_x >= border + (x_ind * block_width)) AND
					(pixel_y < border + (y_ind + 1) * (block_height) AND pixel_y >= border + (y_ind * block_height)) THEN
					
					IF (x_ind = w_col_addr AND y_ind = w_lin_addr) THEN
						cor := tmp_data;
					ELSE
						cor := out_data;
					END IF;
						
					CASE cor IS
						WHEN 0 =>
							red_reg <= "111"; -- branco
							green_reg <= "111";
							blue_reg <= "11";
						WHEN 1 =>
							red_reg <= "111"; -- vermelho
							green_reg <= "000";
							blue_reg <= "00";
						WHEN 2 =>
							red_reg <= "000"; -- verde
							green_reg <= "111";
							blue_reg <= "00";
						WHEN 3 =>
							red_reg <= "000"; -- azul
							green_reg <= "000";
							blue_reg <= "11";
						WHEN 4 =>
							red_reg <= "111"; -- amarelo
							green_reg <= "111";
							blue_reg <= "00";
						WHEN 5 =>
							red_reg <= "111"; -- rosa
							green_reg <= "000";
							blue_reg <= "11";
						WHEN 6 =>
							red_reg <= "000"; -- azul-claro
							green_reg <= "111";
							blue_reg <= "11";
						WHEN 7 =>
							red_reg <= "110"; -- marrom
							green_reg <= "010";
							blue_reg <= "00";
						WHEN 8 =>
							red_reg <= "111"; -- rosa claro
							green_reg <= "011";
							blue_reg <= "01";
						WHEN 9 =>
							red_reg <= "000"; -- preto
							green_reg <= "000";
							blue_reg <= "00";
						WHEN OTHERS =>
							NULL;
					END CASE;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	red <= red_reg WHEN image_on = '1' ELSE "000";
	green <= green_reg WHEN image_on = '1' ELSE "000";
	blue <= blue_reg WHEN image_on = '1' ELSE "00";
	r_col_addr <= x_ind;
	r_lin_addr <= y_ind;
	
end Behavioral;