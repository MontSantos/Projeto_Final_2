LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY IMAGE_CTRL IS
	PORT (
		pixel_clock : IN STD_LOGIC; --pixel clock
		image_on : IN STD_LOGIC; --display enable
		pixel_x : IN NATURAL; --coordenada x
		pixel_y : IN NATURAL; --coordenada y
		p1x : IN NATURAL;
		bx : IN INTEGER;
		by : IN INTEGER;
		score1 : IN NATURAL;
		score2 : IN NATURAL;
		life : IN NATURAL;
		parede : IN block_mat;
		red : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
		green : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- 3 bits
		blue : OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- 2 bits

	);
END IMAGE_CTRL;
ARCHITECTURE Behavioral OF IMAGE_CTRL IS
	SIGNAL rom1_addr1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL rom1_data1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL rom1_addr2 : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL rom1_data2 : STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL rom2_addr1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL rom2_data1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL rom2_addr2 : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL rom2_data2 : STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL red_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL green_reg : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL blue_reg : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

BEGIN
	u_ROM1 : ENTITY work.ROM(behavioral)
		PORT MAP(
			pixel_clock => pixel_clock,
			addr1 => rom1_addr1,
			addr2 => rom1_addr2,
			data1 => rom1_data1,
			data2 => rom1_data2
		);
	u_ROM2 : ENTITY work.ROM(behavioral)
		PORT MAP(
			pixel_clock => pixel_clock,
			addr1 => rom2_addr1,
			addr2 => rom2_addr2,
			data1 => rom2_data1,
			data2 => rom2_data2
		);

	PROCESS (pixel_clock)
		VARIABLE x_ind, y_ind : INTEGER;
	BEGIN
		IF rising_edge(pixel_clock) THEN
			IF ((pixel_x < border OR pixel_x >= 127 * border) OR (pixel_y < border OR pixel_y >= 95 * border)) THEN
				red_reg <= "011"; -- grey
				green_reg <= "011";
				blue_reg <= "01";
			ELSIF (((p1y + paddle_height) > pixel_y AND pixel_y >= p1y) AND ((p1x + paddle_width) > pixel_x AND pixel_x >= p1x)) THEN
				red_reg <= "111"; -- White
				green_reg <= "111";
				blue_reg <= "11";
			ELSIF ((pixel_x < (b_size + bx) AND pixel_x >= bx) AND (pixel_y < (b_size + by) AND pixel_y >= by)) THEN
				red_reg <= "001";
				green_reg <= "000";
				blue_reg <= "11";
			ELSIF (((pixel_x >= score1x) AND (pixel_x < (score1x + score_width))) AND
				((pixel_y >= scorey) AND ((pixel_y < (scorey + score_height))))) THEN

				rom1_addr1 <= STD_LOGIC_VECTOR(to_unsigned(score1 * 16 + (pixel_y - scorey), 11));
				IF rom1_data1(7 - (pixel_x - score1x)) = '1' THEN
					red_reg <= "111";
					green_reg <= "111";
					blue_reg <= "11";
				ELSE
					red_reg <= "000";
					green_reg <= "000";
					blue_reg <= "00";
				END IF;

			ELSIF (((pixel_x >= score2x) AND (pixel_x < (score2x + score_width))) AND
				((pixel_y >= scorey) AND ((pixel_y < (scorey + score_height))))) THEN

				rom1_addr2 <= STD_LOGIC_VECTOR(to_unsigned(score2 * 16 + (pixel_y - scorey), 11));
				IF rom1_data2(7 - (pixel_x - score2x)) = '1' THEN
					red_reg <= "111";
					green_reg <= "111";
					blue_reg <= "11";
				ELSE
					red_reg <= "000";
					green_reg <= "000";
					blue_reg <= "00";
				END IF;

			ELSIF (((pixel_x >= life1x) AND (pixel_x < (life1x + score_width))) AND
				((pixel_y >= scorey) AND ((pixel_y < (scorey + score_height))))) THEN

				rom2_addr1 <= STD_LOGIC_VECTOR(to_unsigned(life * 16 + (pixel_y - scorey), 11));
				IF rom2_data1(7 - (pixel_x - life1x)) = '1' THEN
					red_reg <= "111";
					green_reg <= "111";
					blue_reg <= "11";
				ELSE
					red_reg <= "000";
					green_reg <= "000";
					blue_reg <= "00";
				END IF;

			ELSIF (((pixel_x >= life2x) AND (pixel_x < (life2x + score_width))) AND
				((pixel_y >= scorey) AND ((pixel_y < (scorey + score_height))))) THEN

				rom2_addr2 <= STD_LOGIC_VECTOR(to_unsigned(10 * 16 + (pixel_y - scorey), 11));
				IF rom2_data2(7 - (pixel_x - life2x)) = '1' THEN
					red_reg <= "111";
					green_reg <= "000";
					blue_reg <= "00";
				ELSE
					red_reg <= "000";
					green_reg <= "000";
					blue_reg <= "00";
				END IF;
				
			ELSIF (pixel_x >= block_x AND pixel_x < block_x + (n_blocks) * block_width) AND
					(pixel_y >= block_y AND pixel_y < block_y + n_lin * block_height) THEN

				x_ind := (pixel_x - block_x) / block_width;
				y_ind := (pixel_y - block_y) / block_height;

				IF x_ind >= 0 AND x_ind < n_blocks AND
					y_ind >= 0 AND y_ind < n_lin THEN

					IF (pixel_x < block_x + (x_ind + 1) * block_width AND pixel_x >= block_x + x_ind * block_width) AND
						(pixel_y < block_y + (y_ind + 1) * block_height AND pixel_y >= block_y + y_ind * block_height) THEN

						IF parede(y_ind)(x_ind) = '1' THEN
							CASE y_ind IS
								WHEN 0 =>
									red_reg <= "111"; 
									green_reg <= "000"; 
									blue_reg <= "00";
								WHEN 1 =>
									red_reg <= "111"; 
									green_reg <= "001"; 
									blue_reg <= "00";
								WHEN 2 =>
									red_reg <= "111"; 
									green_reg <= "111"; 
									blue_reg <= "00";
								WHEN 3 =>
									red_reg <= "000"; 
									green_reg <= "111"; 
									blue_reg <= "00";
								WHEN 4 =>
									red_reg <= "000"; 
									green_reg <= "111"; 
									blue_reg <= "11";
								WHEN 5 =>
									red_reg <= "000"; 
									green_reg <= "000"; 
									blue_reg <= "11";
								WHEN OTHERS => NULL;
							END CASE;
						ELSE
							red_reg <= "000"; 
							green_reg <= "000"; 
							blue_reg <= "00";
						END IF;
					END IF;
				END IF;

			ELSE
				red_reg <= "000"; -- black
				green_reg <= "000";
				blue_reg <= "00";
			END IF;
		END IF;
	END PROCESS;

	red <= red_reg WHEN image_on = '1' ELSE "000";
	green <= green_reg WHEN image_on = '1' ELSE "000";
	blue <= blue_reg WHEN image_on = '1' ELSE "00";

END Behavioral;
