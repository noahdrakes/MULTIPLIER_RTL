# MULTIPLIER_RTL
64x64 Multiplier using vhdl

BY NOAH DRAKES AND ILEANA BOCAGE

BACKGROUND (Components)

  We created our Multiplier using a couple of basic logic components.
  - The first component is a basic ALU. For the ALU we only used the add function of it to perform the combination addition for our multiplier
  - The second component are the Shift registers. We used two types of shift registers. The first one is a 64 bit shift-right register for the 64 bit multiplier. 
    We used a 128 bit shift-left register for the 128bit multiplicand. Both of these registers are read only (They do not contain any inputs). They are initialized with the multiplier and multiplicand values once the reset pin is asserted.
  - The third component is the 128 bit Product register. This register block works as a regular register with the first bit of the multiplier-shift-register being 
  routed to the Enable pin on the product register. So if that first bit of the multiplier is a 1, the product value latches to its input and stores the value. If it is
  0, it latches to the value. This is an essential wiring for the Multiplier which gives it its most essential functionality.


CONTROL 
- An input file (controlInput.txt) with the Top level ENABLE and Select Pins are used for our control. The order of the pins are as follows: 

RESET   PRODUCT_REG_EN    ALU_SEL   MCAND_REG_EN    MULT_REG_EN

*NOTE -> the product_reg_en pin does not need to be in this control file, because the enable for the product register is solely 
controlled by the first bit of the multiplier reg. That value of the product_reg_en in the text file does not control the multiplier. 
This was left in there for troubleshooting reasons.

SIMULATION

The Product register is loaded with a 0. The multiplicand register is loaded with 0x20 (32 decimal) and the multiplier register is loaded with 0x06 (6 decimal).
![image](https://user-images.githubusercontent.com/83146040/164147328-34cfd391-2a1d-43e7-9fbe-224d4352695f.png)


After the multiplication occurs, the product register latches to C0 (192 decimal) which is the correct answer.
![image](https://user-images.githubusercontent.com/83146040/164146712-5b4caa9f-c251-4dd7-b632-94cc9e5607aa.png)
