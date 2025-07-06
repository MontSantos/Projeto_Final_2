LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE PKG_PARAM IS
	CONSTANT h_pixels : NATURAL := 1024; 
	CONSTANT v_pixels : NATURAL := 768; 
	CONSTANT border : NATURAL := 8; --h_pixels / 128;
	
	CONSTANT n_blocks : NATURAL := 63; -- (1024 - (2 * border)) / 16;
	CONSTANT n_lin : NATURAL := 47; -- (768 - (2 * border)) / 16;
	CONSTANT block_height : NATURAL := 16;
	CONSTANT block_width : NATURAL := 16;
	
	TYPE grid_mat IS ARRAY(0 TO n_lin - 1, 0 TO n_blocks - 1) OF NATURAL RANGE 0 TO 15;
END PACKAGE PKG_PARAM;