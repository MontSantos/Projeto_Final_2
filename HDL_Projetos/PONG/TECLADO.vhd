LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TECLADO IS
	PORT (
		ps2_CLK : IN STD_LOGIC;
		ps2_DATA : IN STD_LOGIC;
		new_tec : OUT STD_LOGIC;
		saida : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END TECLADO;

ARCHITECTURE Behavioral OF TECLADO IS
	SIGNAL Tecla : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL saida_reg : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL conta : INTEGER RANGE 0 TO 10 := 0;
	SIGNAL tec_reg : STD_LOGIC := '0';
 
BEGIN
	PROCESS (ps2_CLK)
	BEGIN
		IF falling_edge(ps2_CLK) THEN
			conta <= conta + 1;
			tec_reg <= '0';
			IF (conta = 0) THEN
				IF (ps2_DATA /= '0') THEN
					conta <= 0;
				END IF;
			ELSIF (conta > 0 AND conta < 9) THEN
				Tecla <= PS2_DATA & TECLA(7 DOWNTO 1);
			ELSIF (conta = 9) THEN
				NULL; --paridade
			ELSE -- contador = 10 = stop
				conta <= 0;
				saida_reg <= Tecla;
				tec_reg <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	saida <= saida_reg;
	new_tec <= tec_reg;
	
END Behavioral; 