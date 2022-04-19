LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY DRAKES_DATA_PATH IS
GENERIC( P:INTEGER:=64;
	 MW:INTEGER:=128;
	 E: INTEGER:= 128;
	 M: INTEGER:= 128
);

PORT(
	CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	PRODUCT_REG_EN: IN STD_LOGIC;
	ALU_SEL: IN STD_LOGIC;
	DIRECTION: IN STD_LOGIC

);
END DRAKES_DATA_PATH;


ARCHITECTURE STRUCTURAL OF DRAKES_DATA_PATH is

-- BUFFER --
COMPONENT DRAKES_TRI_STATE IS
GENERIC(P:INTEGER:=128);
PORT(CLK:IN STD_LOGIC;
     EN: IN STD_LOGIC;
     MDR_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
     GATE_MDR_OUT:OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END COMPONENT;



-- ALU --
COMPONENT DRAKES_ALU is 
generic( width: natural := 64;
	output: natural	:= 128);
port(
	alu_in1: in std_logic_vector(output-1 downto 0);
	alu_in2: in std_logic_vector(output-1 downto 0);
	alu_sel: in std_logic_vector(1 downto 0);
	alu_out: out std_logic_vector(output-1 downto 0)
);
end COMPONENT;



-- BARREL SHIFTER --
COMPONENT shift is 
port(
		OP_A: in std_logic_vector(63 downto 0);
		direction: in std_logic;
		OP_Q: out std_logic_vector(63 downto 0)
	);
END COMPONENT;



-- SIGN EXTENDER --

COMPONENT DRAKES_SIGN_EXTENDER64_128 is
	GENERIC(
		P:INTEGER:=128); 
	port ( 
		OP_A: in std_logic_vector (63 downto 0) ;  
		SEXT64: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT;




BEGIN
END STRUCTURAL;


