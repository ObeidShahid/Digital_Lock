/////////////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip			//
//Module: Button Decryption Module 						//
//Student: Syed Zaidi										//
//Student ID: 201047894										//
//Incoming clock frequency = 50Mhz						//
/////////////////////////////////////////////////////

module b_test
(
input clock_in,					//Clock input
input Button_input0,				//Key 0 input
input Button_input1,				//Key 1 input
input Button_input2,				//Key 2 input
input Button_input3,				//Key 3 input
output reg [3:0]Button_press,	//Output value
output reg reset					//reset value
);

reg b_flag = 0;								//Initialise button flag to 0 
reg c_flag = 0;								//Initialise counter flag to 0
reg [3:0] timeout = 0;						//Initialise timeout counter to 0
wire [3:0] Button_in;						//Create Button in wire to assign inverted values of buttons
wire Button_out0;								//Output wire for Key 0
wire Button_out1;								//Output wire for Key 1
wire Button_out2;								//Output wire for Key 2
wire Button_out3;								//Output wire for Key 3
wire clk_en;									//Clock enable wire from Frequency divider

assign Button_in0 = ~Button_input0;		//Button in 0 is assigned the bit-wise inverted value as the buttons are active low
assign Button_in1 = ~Button_input1;		//Button in 1 is assigned the bit-wise inverted value as the buttons are active low
assign Button_in2 = ~Button_input2;		//Button in 2 is assigned the bit-wise inverted value as the buttons are active low
assign Button_in3 = ~Button_input3;		//Button in 3 is assigned the bit-wise inverted value as the buttons are active low



always@(posedge clock_in) begin

Button_press = 4'b0000; 			//Reset output value for next loop run

if ((Button_out0 == 1)&&(Button_out1 == 0)&&(Button_out2 == 0)&&(Button_out3 == 0)) begin //If only Key 0 is set to high and other keys are set to low
		if (b_flag == 0) begin		//If b_flag is set to 0
		Button_press = 4'b0001;		//Set output to 4'b0001 corresponding to Key 0 pressed
		b_flag = 1;						//Set Button pressed flag to 1 to ensure value is set for only 1 clock cycle
		timeout = 0;					//Reset timeout timer due to button press detection
		end
end
else 
if ((Button_out1 == 1)&&(Button_out0 == 0)&&(Button_out2 == 0)&&(Button_out3 == 0)) begin //If only Key 1 is set to high and other keys are set to low
		if (b_flag == 0) begin		//If b_flag is set to 0
		Button_press = 4'b0010;		//Set output to 4'b0010 corresponding to Key 1 pressed
		b_flag = 1;						//Set Button pressed flag to 1 to ensure value is set for only 1 clock cycle
		timeout = 0;					//Reset timeout timer due to button press detection
		end
end
else 
if ((Button_out2 == 1)&&(Button_out0 == 0)&&(Button_out1 == 0)&&(Button_out3 == 0)) begin	//If only Key 2 is set to high and other keys are set to low
		if (b_flag == 0) begin		//If b_flag is set to 0
		Button_press = 4'b0100;		//Set output to 4'b0100 corresponding to Key 2 pressed
		b_flag = 1;						//Set Button pressed flag to 1 to ensure value is set for only 1 clock cycle
		timeout = 0;					//Reset timeout timer due to button press detection
		end
end
else 
if ((Button_out3 == 1)&&(Button_out0 == 0)&&(Button_out1 == 0)&&(Button_out2 == 0)) begin	//If only Key 3 is set to high and other keys are set to low
		if (b_flag == 0) begin		//If b_flag is set to 0
		Button_press = 4'b1000;		//Set output to 4'b1000 corresponding to Key 3 pressed
		b_flag = 1;						//Set Button pressed flag to 1 to ensure value is set for only 1 clock cycle
		timeout = 0;					//Reset timeout timer due to button press detection
		end
end
else 
if ((Button_out3 == 0)&&(Button_out0 == 0)&&(Button_out1 == 0)&&(Button_out2 == 0))begin //If no Key presses are detected
		b_flag = 0;						//Reset b_flag to 0 once no Key presses are detected
		Button_press = 4'b0000;		//Reset output to 4'b0000 corresponding to no Key press detected
		
end

if (clk_en == 1) begin				//If clk_en is detected as high
if (c_flag == 0) begin				//If c_flag is set to 0
	timeout = timeout +1;			//Increment timeout counter by 1
	c_flag = 1;							//Set counter flag to 1 to ensure only 1 increment per clk_en clock cycle
end
end
else 
if (clk_en == 0) begin				//If clk_en is detected as low
	c_flag = 0;							//Reset c_flag to 0 for next clock cycle detection
end

if (timeout >= 5) begin				//If timeout counter is greater than 5(1Hz clock tied to increment results in 5 seconds)
	reset = 1;							//Set reset value high
	timeout = 0;						//Reset timeout counter to 0 for next timeout detection
end 
else begin								//If timeout is less than 5
	reset = 0;							//Set reset value back to 0 for next clock cycle
end

	
end



freq_div #(1) fd1 			//Instantiate frequency divider submodule adjusting the parameter for clock rate desired
(.clk_in(clock_in),			//Clock input attached to clock coming in from hardware/simulation
.clk_out(clk_en)				//Clock output atached to clock enable signal for timeout timer
);



Button_DB Button0 (			//Button Debounce Submodule for KEY 0
.clk_in(clock_in),			//clock input from 50Mhz clock
.Button_in(Button_in0), 	//Button input from top-level module to debounce submodule
.Button_out(Button_out0)	//Button output from Debounce submodule
);


Button_DB Button1 (			//Button Debounce Submodule for KEY 1
.clk_in(clock_in),			//clock input from 50Mhz clock
.Button_in(Button_in1), 	//Button input from top-level module to debounce submodule
.Button_out(Button_out1)	//Button output from Debounce submodule
);

Button_DB Button2 (			//Button Debounce Submodule for KEY 2
.clk_in(clock_in),			//clock input from 50Mhz clock
.Button_in(Button_in2), 	//Button input from top-level module to debounce submodule
.Button_out(Button_out2)	//Button output from Debounce submodule
);

Button_DB Button3 (			//Button Debounce Submodule for KEY 3
.clk_in(clock_in),			//clock input from 50Mhz clock
.Button_in(Button_in3), 	//Button input from top-level module to debounce submodule
.Button_out(Button_out3)	//Button output from Debounce submodule
);

endmodule
