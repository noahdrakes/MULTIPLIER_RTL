# MULTIPLIER_RTL
64x64 Multiplier using vhdl

BY NOAH DRAKES AND ILEANA BOCAGE

BACKGROUND (Components)

  We created our Multiplier using a couple of basic logic components.
  - The first component is a basic ALU. For the ALU we only used the add function of it to perform the combination addition for our multiplier
  - The second component are the Shift registers. We used two types of shift registers. The first one is a 64 bit shift-right register for the 64 bit multiplier. 
    We used a 128 bit shift-left register for the 128bit multiplicand
  - The third component is the 128 bit Product register. This register block works as a regular register with the first bit of the multiplier-shift-register being 
  routed to the Enable pin on the product register. So if that first bit of the multiplier is a 1, the product value latches to its input and stores the value. If it is
  0, it latches to the value. This is an essential wiring for the Multiplier which gives it its most essential functionality.


![image](https://user-images.githubusercontent.com/83146040/164145354-11bdada8-8f9b-4708-a438-fb5a78dd2d15.png)
