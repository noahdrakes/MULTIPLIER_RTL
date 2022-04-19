Library IEEE;
use IEEE.std_logic_1164.all;
use work.All;
use IEEE.std_logic_textio.all;
use std.textio.all;

package CLOCKS is
  -- declare CLOCKS package
procedure cycle(constant N : in NATURAL;
                        signal CLK: in std_logic);
procedure InitializeMemory;
procedure DumpMemory(constant startaddress : in integer;
                     constant numwords : in integer);

type Mem_Array_Type is array (0 to 65536) of
    std_logic_vector ( 15 downto 0 );

--shared variable LC3MEM : Mem_Array_Type;        
end CLOCKS;  --All components can have access to the cycle procedure

package body CLOCKS is




 procedure cycle(constant N : in NATURAL;
                        signal CLK: in std_logic) is
      begin       
	 for i in 1 to N loop
          wait until (CLK'EVENT) and (CLK = '1');
         end loop;
      end;

procedure DumpMemory(constant startaddress : in integer;
                     constant numwords : in integer) is
--FILE variables
--FILE out_file : TEXT IS OUT "lc3_memdump.dat";
FILE out_file : TEXT open  write_mode is "lc3_memdump.dat"; --mea
variable out_line : LINE;
variable vaddress : integer;
variable vdata : std_logic_vector(15 downto 0);
variable LC3MEM : Mem_Array_Type; --mea

      begin       
	vaddress := startaddress;

	 for i in 1 to numwords loop
        vdata := LC3MEM(vaddress);
	  

		write(out_line, vaddress );
		write(out_line,' ');
		write(out_line, vdata );


	writeline(out_file, out_line);

        vaddress := vaddress + 1; 
       end loop;
end;

 procedure InitializeMemory is 
--FILE variables
--FILE in_file : TEXT IS IN "lc3_meminit.dat";
FILE in_file : TEXT open read_mode is "lc3_meminit.dat"; --mea
variable in_line : LINE;
variable vstartaddress : integer;
variable vdata : std_logic_vector(15 downto 0);
variable LC3MEM : Mem_Array_Type; --mea

 begin
 readline(in_file, in_line);
 read(in_line, vstartaddress);

while (not endfile(in_file)) LOOP	

	readline(in_file, in_line);
	read(in_line, vdata);
	LC3MEM(vstartaddress):= vdata;
	vstartaddress := vstartaddress + 1;
 END LOOP;
 end;

        
end CLOCKS;

Library IEEE;
use IEEE.std_logic_1164.all;

entity CLOCK is
  port(CLK: out std_logic);
end;

architecture BEHAVIOR of CLOCK is


begin

  START:process 
  constant CLK_PERIOD: TIME:= 10 ns; -- CLOCK PERIOD  IN picOSECONDS
     begin
    CLK <= '1';
    wait for CLK_PERIOD/2;
 
    CLK <= '0';
    wait for CLK_PERIOD/2;
   
end process;


end BEHAVIOR;

library IEEE;
use work.CLOCKS.all;   -- Entity that uses CLOCKS
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity LC3_MEMORY is
PORT (	CLK,RESET : IN STD_LOGIC;
MEM_WRITE : IN STD_LOGIC;
MEM_ADDRESS : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
MEM_DATAIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
MEM_ENABLE : IN STD_LOGIC;
MEM_DATAVALID : OUT STD_LOGIC;
MEM_DATAOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end LC3_MEMORY;


architecture behavioral of LC3_MEMORY is
begin

-- this memory takes 4 cycles to read and 2 cycles to write.

process

variable dataoutstage0,dataoutstage1,dataoutstage2,dataoutstage3,dataoutstage4 : std_logic_vector(15 downto 0);
variable validoutstage0,validoutstage1,validoutstage2,validoutstage3,validoutstage4 : std_logic;

variable datainstage0,datainstage1,datainstage2,addressinstage0,addressinstage1,addressinstage2 : std_logic_vector(15 downto 0);
variable validinstage0,validinstage1,validinstage2 : std_logic;
variable LC3MEM : Mem_Array_Type; --mea


variable iaddress : integer;
begin
wait until ( (CLK'event) and (clk = '1'));

if (reset = '1') then
	dataoutstage0 := "UUUUUUUUUUUUUUUU";
	dataoutstage1 := "UUUUUUUUUUUUUUUU";
	dataoutstage2 := "UUUUUUUUUUUUUUUU";
	dataoutstage3 := "UUUUUUUUUUUUUUUU";
	dataoutstage4 := "UUUUUUUUUUUUUUUU";


	validoutstage0 :='0';
	validoutstage1 :='0';
	validoutstage2 :='0';
	validoutstage3 :='0';
	validoutstage4 := '0';

	datainstage0 := "UUUUUUUUUUUUUUUU";
	datainstage1 := "UUUUUUUUUUUUUUUU";
	datainstage2 := "UUUUUUUUUUUUUUUU";

	addressinstage0 := "UUUUUUUUUUUUUUUU";
	addressinstage1 := "UUUUUUUUUUUUUUUU";
	addressinstage2 := "UUUUUUUUUUUUUUUU";
	
	validinstage0 := '0';
	validinstage1 := '0';
	validinstage2 := '0';


else 
	if ( (MEM_ENABLE = '1') AND (MEM_WRITE ='0') ) then --- DO A READ
		
		iaddress := CONV_INTEGER(MEM_address);
		dataoutstage0 := LC3MEM(iaddress);
		validoutstage0 := MEM_ENABLE;	

	elsif ( (MEM_ENABLE = '1') AND (MEM_WRITE ='1') ) then --- DO A WRITE
	
		datainstage0 := MEM_datain;
		validinstage0 := MEM_ENABLE;
		addressinstage0 := MEM_address;

		
	else
		dataoutstage0 := "UUUUUUUUUUUUUUUU";
		datainstage0 := "UUUUUUUUUUUUUUUU";
		validinstage0 := '0';
		validoutstage0 := '0';
		addressinstage0 := "UUUUUUUUUUUUUUUU";
	end if;
		dataoutstage4 := dataoutstage3;
		dataoutstage3 := dataoutstage2;	-- Shift Dataout for Read
		dataoutstage2 := dataoutstage1;
		dataoutstage1 := dataoutstage0;

		validoutstage4 := validoutstage3;
		validoutstage3 := validoutstage2;	-- Shift Valid Data for Read
		validoutstage2 := validoutstage1;
		validoutstage1 := validoutstage0;
		
		datainstage2 := datainstage1;
		datainstage1 := datainstage0; -- Shift DataIn for Write
		
		validinstage2 := validinstage1;
		validinstage1 := validinstage0; -- Shift Valid Datain for Write

		addressinstage2 := addressinstage1;
		addressinstage1 := addressinstage0; -- Shift Address in for Write

		if (validinstage2 = '1') then -- Update Memory if a write is in the pipe
			iaddress := CONV_INTEGER(addressinstage2);
			LC3MEM(iaddress) := datainstage2;
		end if;

end if;
MEM_DATAVALID <= validoutstage4;
MEM_DATAOUT <= dataoutstage4;

end process;


end behavioral;

