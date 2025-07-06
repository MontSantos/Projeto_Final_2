LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
USE work.PKG_PARAM.ALL;

ENTITY GRID IS
    PORT (
        pixel_clock : IN STD_LOGIC; -- pixel clock real
		  state_space : IN STD_LOGIC;
		  w_col_addr : IN NATURAL RANGE 0 TO n_blocks - 1;
		  w_lin_addr : IN NATURAL RANGE 0 TO n_lin - 1;
		  r_col_addr : IN NATURAL RANGE 0 TO n_blocks - 1;
		  r_lin_addr : IN NATURAL RANGE 0 TO n_lin - 1;
		  color_data : IN NATURAL RANGE 0 TO 15;
		  rw_en : IN STD_LOGIC;
        out_data : OUT NATURAL RANGE 0 TO 15
    );
END GRID;

ARCHITECTURE Behavioral OF GRID IS

    SIGNAL grid_reg : grid_mat := (OTHERS => (OTHERS => 0));

BEGIN
    PROCESS (pixel_clock)
    BEGIN
        IF rising_edge(pixel_clock) THEN
				IF state_space = '1' THEN
					grid_reg <=(OTHERS => (OTHERS => 0));
				END IF;
				IF rw_en = '1' THEN
					grid_reg(w_lin_addr, w_col_addr) <= color_data;
				END IF;
        END IF;
    END PROCESS;

    out_data <= grid_reg(r_lin_addr, r_col_addr);

END Behavioral;
