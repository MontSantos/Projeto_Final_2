LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY AUDIO IS
    PORT (
        pixel_clk       : IN  STD_LOGIC;         -- clock de 65 MHz
		  audio_val : IN  NATURAL;  
        audio_out_L : OUT STD_LOGIC;
		  audio_out_R : OUT STD_LOGIC		  -- saída de audio
    );
END AUDIO;

ARCHITECTURE Behavioral OF AUDIO IS

    CONSTANT clk_freq : NATURAL := 65000000;
	 SIGNAL freq  : NATURAL := 0;
	 
    SIGNAL cnt_onda : NATURAL := 0;
	 SIGNAL freq_IN : NATURAL := 0;
	 
    SIGNAL audio_reg  : STD_LOGIC := '0';

BEGIN
    PROCESS (pixel_clk)
    BEGIN
        IF rising_edge(pixel_clk) THEN
				CASE audio_val IS
					WHEN 1 => freq <= 440;
					WHEN 2 => freq <= 220;
					WHEN 3 => freq <= 659;
					WHEN OTHERS => freq <= 0;
				END CASE;
				
				IF freq > 0 THEN
                freq_IN <= clk_freq / (freq * 2);
				ELSE
					 freq_IN <= 0;
				END IF;
				
				IF	freq_IN <= 0 THEN
					audio_reg  <= '0';
					
				ELSIF cnt_onda >= freq_IN THEN
                cnt_onda  <= 0;
                audio_reg  <= NOT audio_reg;

            ELSE
                cnt_onda <= cnt_onda + 1;
            END IF;

        END IF;
    END PROCESS;

    audio_out_L <= audio_reg;
	 audio_out_R <= audio_reg;

END Behavioral;
