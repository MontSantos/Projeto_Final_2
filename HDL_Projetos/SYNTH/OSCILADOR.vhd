LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY OSCILADOR IS
    PORT (
        clk       : IN  STD_LOGIC;         -- clock de 50 MHz
		  freq_L : IN NATURAL;
		  freq_R : IN NATURAL;
        audio_out_L : OUT STD_LOGIC;
		  audio_out_R : OUT STD_LOGIC		  -- saída de audio
    );
END OSCILADOR;

ARCHITECTURE Behavioral OF OSCILADOR IS

    CONSTANT clk_freq : NATURAL := 50000000;

    SIGNAL cnt_onda_L : NATURAL := 0;
	 SIGNAL cnt_onda_R : NATURAL := 0;
	 SIGNAL freq_L_IN : NATURAL := 0;
	 SIGNAL freq_R_IN : NATURAL := 0;
	 
    SIGNAL audio_L_reg  : STD_LOGIC := '0';
	 SIGNAL audio_R_reg  : STD_LOGIC := '0';

BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN

            IF freq_L > 0 THEN
                freq_L_IN <= clk_freq / (freq_L * 2);
				ELSE
					 freq_L_IN <= 0;
				END IF;
				
				IF	freq_L_IN <= 0 THEN
					audio_L_reg  <= '0';
					audio_R_reg <= '0';
					
				ELSIF cnt_onda_L >= freq_L_IN THEN
                cnt_onda_L  <= 0;
                audio_L_reg  <= NOT audio_L_reg;
					 audio_R_reg  <= NOT audio_R_reg;

            ELSE
                cnt_onda_L <= cnt_onda_L + 1;
            END IF;

        END IF;
    END PROCESS;

    audio_out_L <= audio_L_reg;
	 audio_out_R <= audio_R_reg;

END Behavioral;
