LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MAIN IS
    PORT (
        clock : IN STD_LOGIC; -- FPGA clock
		  ps2_CLK    : in  STD_LOGIC; -- Clock do teclado PS/2
        ps2_DATA   : in  STD_LOGIC; -- Dados do teclado PS/2
        audio_out_L : OUT STD_LOGIC;
		  audio_out_R : OUT STD_LOGIC
    );
END MAIN;

ARCHITECTURE Behavioral OF MAIN IS

    SIGNAL pixel_clk : STD_LOGIC := '0';
	 
	 SIGNAL teclado : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	 
	 SIGNAL new_tec : STD_LOGIC := '0';
	 
	 SIGNAL ps2_CLK_SYNC : STD_LOGIC := '0';
	 
	 SIGNAL freq_L_reg, freq_R_reg : NATURAL;
	 
	 SIGNAL audio_L_reg : STD_LOGIC := '0';
	 SIGNAL audio_R_reg : STD_LOGIC := '0';

BEGIN
		  
	 -- Teclado	 
	 u_teclado: ENTITY work.TECLADO(Behavioral)
		  PORT MAP(
				clk	      => clock,
				ps2_CLK     => ps2_CLK_SYNC,
				ps2_DATA    => ps2_DATA,
				new_tec     => new_tec,
				saida	      => teclado
		  );
		  
	u_SYNC: ENTITY work.SYNC(Behavioral)
		  PORT MAP(
				pixel_clk	    => clock,
				ps2_CLK         => ps2_CLK,
				ps2_CLK_SYNC    => ps2_CLK_SYNC
		  );
		  
	u_oscilador: ENTITY work.OSCILADOR(Behavioral)
		 PORT MAP(
				clk	  		=> clock,
				freq_L      => freq_L_reg,
				freq_R      => freq_R_reg,
				audio_out_L => audio_L_reg,
				audio_out_R => audio_R_reg
		  );
	
	u_tecff: ENTITY work.TEC_FF(Behavioral)
		 PORT MAP(
				clk	  		=> clock,
				new_tec     => new_tec,
				teclado	   => teclado,
				freq_L      => freq_L_reg,
				freq_R      => freq_R_reg
		  );
		  
   audio_out_L <= audio_L_reg;
   audio_out_R <= audio_R_reg;
		  
END Behavioral;
