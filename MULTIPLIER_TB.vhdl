LIBRARY IEEE;
USE work.CLOCKS.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
USE std.textio.all;
USE work.txt_util.all;

ENTITY tb_MULTIPLIER IS
END;

ARCHITECTURE TESTBENCH OF tb_MULTIPLIER is

CONSTANT P: INTEGER:=64;
CONSTANT MW: INTEGER:=128;
CONSTANT O: INTEGER:= 9;



COMPONENT DRAKES_DATA_PATH

GENERIC(    P: INTEGER:=64;
            MW: INTEGER:=128);

PORT(

    CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	PRODUCT_REG_EN: IN STD_LOGIC;
	ALU_SEL: IN STD_LOGIC_VECTOR(1 downto 0);
	MCAND_REG_EN: IN STD_LOGIC;
	MULT_REG_EN: IN STD_LOGIC;
	MULT_DIRECTION: IN STD_LOGIC;
	MCAND_DIRECTION: IN STD_LOGIC
    
);

END COMPONENT;

COMPONENT CLOCK
 port(  CLK:out std_logic);
END COMPONENT;


FILE in_file:TEXT open read_mode is "controlInput.txt";
FILE exo_file:TEXT open read_mode is"dummyOutput.txt";
FILE out_file:TEXT open read_mode is"AMOO_Class_Example_dataout_dacus.txt";
FILE xout_file:TEXT open read_mode is"AMOO_Class_Example_TestOut_dacus.txt";
FILE hex_out_file:TEXT open read_mode is"AMOO_Class_Example_hex_out_dacus.txt";


-- CONTROL SIGNALS
SIGNAL CLK: STD_LOGIC;
SIGNAL reset: std_logic;
SIGNAL PRODUCT_REG_EN: STD_LOGIC:='X';
SIGNAL ALU_SEL: STD_LOGIC_VECTOR(1 downto 0):=(OTHERS=>'X');
SIGNAL MCAND_REG_EN: STD_LOGIC:='X';
SIGNAL MULT_REG_EN: STD_LOGIC:='X';
SIGNAL MULT_DIRECTION: STD_LOGIC:='X';
SIGNAL MCAND_DIRECTION: STD_LOGIC:='X';

-- FILE READING SIGNALS
SIGNAL OP_Q:STD_LOGIC_VECTOR(O-1 downto 0):=(OTHERS=>'X');
SIGNAL Exp_Op_Q:STD_LOGIC_VECTOR(O-1 downto 0):=(OTHERS=>'X');
SIGNAL Test_Out_Q:STD_LOGIC:='X';
SIGNAL LineNumber:integer:=0;


BEGIN

U0:CLOCK port map(CLK);
InstDRAKES_DATA_PATH:drakes_data_path port MAP (CLK, RESET, PRODUCT_REG_EN, ALU_SEL, MCAND_REG_EN, 
MULT_REG_EN, MULT_DIRECTION, MCAND_DIRECTION);


PROCESS

variable in_line,exo_line,out_line,xout_line:LINE;
variable comment,xcomment:string(1 to 128);
variable i: integer range 1 to 128;
variable simcomplete:boolean;

variable vreset: std_logic;
variable vPRODUCT_REG_EN: STD_LOGIC:='X';
variable vALU_SEL: STD_LOGIC_VECTOR(1 downto 0):=(OTHERS=>'X');
variable vMCAND_REG_EN: STD_LOGIC:='X';
variable vMULT_REG_EN: STD_LOGIC:='X';
variable vMULT_DIRECTION: STD_LOGIC:='X';
variable vMCAND_DIRECTION: STD_LOGIC:='X';

variable vOp_Q:std_logic_vector(O-1 downto 0):=(OTHERS=>'X');
variable vExp_Op_Q:std_logic_vector(O-1 downto 0):=(OTHERS=>'X');
variable vTest_Out_Q:std_logic:='0';
variable vlinenumber:integer;


BEGIN

simcomplete:=false;
while(not simcomplete)LOOP

	if (not endfile(in_file))then
		readline(in_file,in_line);
	else
		simcomplete:=true;
	end if;

	if(not endfile(exo_file))then
		readline(exo_file,exo_line);
	else
		simcomplete:=true;
	end if;
	if(in_line(1)='-')then
		next;
	elsif(in_line(1)='.')then
		Test_Out_Q<='Z';
		simcomplete:=true;
	elsif(in_line(1)='#')then
		i:=1;
	while in_line(i)/='.'LOOP
		comment(i):=in_line(i);
		i:=i+1;
	end LOOP;

	elsif(exo_line(1)='-')then
		next;
	elsif(exo_line(1)='.')then
		Test_Out_Q<='Z';
		simcomplete:=true;
	elsif(exo_line(1)='#')then
		i:=1;
	while exo_line(i)/='.'LOOP
		xcomment(i):=exo_line(i);
		i:=i+1;
	end LOOP;

  		write(out_line, comment);
		writeline(out_file, out_line);

		write(xout_line, xcomment);
		writeline(xout_file, xout_line);

	ELSE

	
		read(in_line,vreset);--
		RESET  <=vreset;

		read(in_line,vPRODUCT_REG_EN);
		PRODUCT_REG_EN  <=vPRODUCT_REG_EN;--

		read(in_line,vALU_SEL);
		ALU_SEL  <=vALU_SEL;--
	
		read(in_line,vMCAND_REG_EN);
		MCAND_REG_EN  <= vMCAND_REG_EN;--

		read(in_line,vMULT_REG_EN);
		MULT_REG_EN  <=vMULT_REG_EN;--

		read(in_line,vMULT_DIRECTION);--
		MULT_DIRECTION  <=vMULT_DIRECTION;

		read(in_line,vMCAND_DIRECTION);--
		MCAND_DIRECTION  <=vMCAND_DIRECTION;


		--read(in_line,vgate_mdr_out);
		--gate_mdr_out  <=vgate_mdr_out;

		
		

		read(exo_line,vexp_Op_Q);
		read(exo_line,vTest_Out_Q);

	vlinenumber:=LineNumber;

	write(out_line,vlinenumber);
	write(out_line,STRING'("."));
	write(out_line,STRING'("   "));

	CYCLE(1,CLK);

	Exp_Op_Q  <=vexp_Op_Q;

	if(Exp_Op_Q=Op_Q)then
	 Test_Out_Q<='0';
	else
	 Test_Out_Q<='X';
	end if;

		vOp_Q:=Op_Q;
		vTest_Out_Q:=Test_Out_Q;

		
	END IF;
	LineNumber<=LineNumber+1;
	END LOOP;
	WAIT;


END PROCESS;


END TESTBENCH;

CONFIGURATION cfg_tb_DRAKES_MULTIPLIER_DATAPATH OF TB_MULTIPLIER is	
		FOR TESTBENCH
			FOR InstDRAKES_DATA_PATH:DRAKES_DATA_PATH
				use entity work.DRAKES_DATA_PATH(STRUCTURAL);
			END FOR;
		END FOR;
	END;