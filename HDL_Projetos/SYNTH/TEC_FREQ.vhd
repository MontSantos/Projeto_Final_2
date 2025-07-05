LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TEC_FREQ IS
    PORT (
        clk : IN  STD_LOGIC;         
		  nota_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        freq_L : OUT NATURAL;
		  freq_R : OUT NATURAL		 
    );
END TEC_FREQ;

ARCHITECTURE Behavioral OF TEC_FREQ IS
    type rom is array (0 to 47) of natural;
	 constant escala : rom := (
		  65, 69, 73, 78, 82, 87, 93, 98, 104, 110, 117, 123,
		  131, 139, 147, 156, 165, 175, 185, 196, 208, 220, 233, 247,
		  262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494,
		  523, 554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988
	 );
	 
	 SIGNAL L_REG, R_REG : NATURAL := 0;


BEGIN
    PROCESS (clk)
    BEGIN
		IF rising_edge(clk) THEN
			CASE nota_1 IS
				WHEN x"0E" => L_REG <= ESCALA(0); --do
				WHEN x"16" => L_REG <= ESCALA(1); -- do#
				WHEN x"1E" => L_REG <= ESCALA(2); --re
				WHEN x"26" => L_REG <= ESCALA(3); --re#
				WHEN x"25" => L_REG <= ESCALA(4); --mi
				WHEN x"2E" => L_REG <= ESCALA(5); --fa
				WHEN x"36" => L_REG <= ESCALA(6); --fa#
				WHEN x"3D" => L_REG <= ESCALA(7); --sol
				WHEN x"3E" => L_REG <= ESCALA(8); --sol#
				WHEN x"46" => L_REG <= ESCALA(9); --la
				WHEN x"45" => L_REG <= ESCALA(10); --la#
				WHEN x"4E" => L_REG <= ESCALA(11); --si
				
				WHEN x"0D" => L_REG <= ESCALA(12);
				WHEN x"15" => L_REG <= ESCALA(13);
				WHEN x"1D" => L_REG <= ESCALA(14);
				WHEN x"24" => L_REG <= ESCALA(15);
				WHEN x"2D" => L_REG <= ESCALA(16);
				WHEN x"2C" => L_REG <= ESCALA(17);
				WHEN x"35" => L_REG <= ESCALA(18);
				WHEN x"3C" => L_REG <= ESCALA(19);
				WHEN x"43" => L_REG <= ESCALA(20);
				WHEN x"44" => L_REG <= ESCALA(21);
				WHEN x"4D" => L_REG <= ESCALA(22);
				WHEN x"54" => L_REG <= ESCALA(23);
				
				WHEN x"58" => L_REG <= ESCALA(24);
				WHEN x"1C" => L_REG <= ESCALA(25);
				WHEN x"1B" => L_REG <= ESCALA(26);
				WHEN x"23" => L_REG <= ESCALA(27);
				WHEN x"2B" => L_REG <= ESCALA(28);
				WHEN x"34" => L_REG <= ESCALA(29);
				WHEN x"33" => L_REG <= ESCALA(30);
				WHEN x"3B" => L_REG <= ESCALA(31);
				WHEN x"42" => L_REG <= ESCALA(32);
				WHEN x"4B" => L_REG <= ESCALA(33);
				WHEN x"4C" => L_REG <= ESCALA(34);
				WHEN x"52" => L_REG <= ESCALA(35);
				
				WHEN x"12" => L_REG <= ESCALA(36);
				WHEN x"1A" => L_REG <= ESCALA(37);
				WHEN x"22" => L_REG <= ESCALA(38);
				WHEN x"21" => L_REG <= ESCALA(39);
				WHEN x"2A" => L_REG <= ESCALA(40);
				WHEN x"32" => L_REG <= ESCALA(41);
				WHEN x"31" => L_REG <= ESCALA(42);
				WHEN x"3A" => L_REG <= ESCALA(43);
				WHEN x"41" => L_REG <= ESCALA(44);
				WHEN x"49" => L_REG <= ESCALA(45);
				WHEN x"4A" => L_REG <= ESCALA(46);
				WHEN x"59" => L_REG <= ESCALA(47);
				
				WHEN OTHERS => L_REG <= 0;
			END CASE;
		END IF;
    END PROCESS;

    freq_L <= L_REG;
	 freq_R <= L_REG;

END Behavioral;
