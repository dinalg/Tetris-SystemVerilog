

To run this code you must open the project on Quartus.

Then you should compile the code using the Start Compilation button (or Ctrl + L).

Next you should open up Eclipse on NIOS II by going to Tools->Nios II Software Build Tools for Eclipse.

Now you should right click usb_kb_bsp and go to Nios II->Generate BSP.

In Eclipse you should then press Ctrl + B to build the project.

Now you should back to Quartus and program the FPGA Board by opening the Programmer and pressing start.

Finally, go back to Eclipse and navigate to Run->Run Configurations.

	- Under the Project tab select usb_kb as the project
	- usb_kb.elf should automatically be set as the project ELF file name
	- Go to the Target Connection tab and click Refresh Connections on the right
	- Finally press Run at the bottom of the window


The program should be functioning on the VGA monitor at this point and the USB keyboard attachment should be fully operational.
