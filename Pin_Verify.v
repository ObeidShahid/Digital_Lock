/////////////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip			//
//Module: PIN Verification Module						//
//Student: Syed Zaidi										//
//Student ID: 201047894										//
//Incoming clock frequency = 50Mhz						//
/////////////////////////////////////////////////////

module Pin_Verify
(
input 			clock_in,		//Clock input
input  Button_input0,			//Button 0 input	
input  Button_input1,			//Button 1 input
input  Button_input2,			//Button 2 input
input  Button_input3,			//Button 3 input
output reg PIN_TRUE,				//PIN_TRUE flag
output reg PIN_FALSE,			//PIN_FALSE flag
output [6:0] seg0,				//7-segment digit 0
output [6:0] seg1,				//7-segment digit 1
output [6:0] seg2,				//7-segment digit 2
output [6:0] seg3,				//7-segment digit 3
output [6:0] seg4,				//7-segment digit 4
output [6:0] seg5,				//7-segment digit 5
output [6:0] redled_out			//Red led Signal for entry number
);

//Local paramaters for State names
localparam State_0 = 3'b000;
localparam State_1 = 3'b001;
localparam State_2 = 3'b010;
localparam State_3 = 3'b011;
localparam State_4 = 3'b100;


reg [2:0] savestate;					//Save state variable to save last state
reg [4:0]entry_number = 0;			//Entry number variable to select the PIN number to enter
reg [4:0]entry_number2 = 0;		//Entry number variable 2 for locking stage
reg [7:0] redled;						//red led Value saved to output to red led pins
reg [2:0] state = State_0;			//Initialise state variable at state 0
reg [3:0] PIN_LI [11:0];			//4-bit Pin input array for locking state
reg [3:0] PIN [5:0];					//4-bit PIN Value array for setting the PIN
reg [3:0] PIN_INPUT [5:0];			//4-bit PIN input array for unlockig state
reg [3:0] PIN_STORE = 0;			//Initialise PIN Store value at 0 for storing incoming pin value
reg [3:0] PIN_STORE2 = 0;			//Initialise PIN Store 2 value at 0 for storing previous pin value
wire [3:0] PIN_Value;				//PIN Value output from Button Decryption module
reg pin_test = 0;						//Initialise pin_test at 0 for entry number adjustment
wire rst;								//Reset flag output from timeout timer in Button Decryption module
reg reset = 1;							//Initialise reset at 1 to reset once at start
reg pin_entry = 0;					//Initialise pin entry at 0 to set the PIN once at start			
reg p_press = 0;						//Initialise p press at 0 for PIN False flag
reg seg_out = State_0;				//Initialise seg out variable at state 0 for 7-segment module state 0
reg pin_flag = 0;						//Initialise pin false flag at 0
assign redled_out = redled;		//Continuous assign statement to assign redled to the output redled_out



always@(posedge clock_in) begin	//Triggered once at each positive edge of the clock

		if (rst == 1) begin			//If reset flag from Button decryption
		reset = 1;						//Set reset to 1
		end
		
		if (reset == 1) begin				//If reset is set to high set all relevant values to 0
			PIN_INPUT[0] = 0;
			PIN_INPUT[1] = 0;
			PIN_INPUT[2] = 0;
			PIN_INPUT[3] = 0;
			PIN_INPUT[4] = 0;
			PIN_INPUT[5] = 0;
			PIN_LI[0] = 0;
			PIN_LI[1] = 0;
			PIN_LI[2] = 0;
			PIN_LI[3] = 0;
			PIN_LI[4] = 0;
			PIN_LI[5] = 0;
			PIN_LI[6] = 0;
			PIN_LI[7] = 0;
			PIN_LI[8] = 0;
			PIN_LI[9] = 0;
			PIN_LI[10] = 0;
			PIN_LI[11] = 0;
			entry_number = 0;
			PIN_STORE = 0;
			reset = 0;
		end
		
		pin_flag = 0;					//reset pin flag to 0
		if (PIN_FALSE == 1) begin	//If PIN FALSE is high
		if (p_press == 0) begin		//If p press is low
		pin_flag = 1;					//Set pin flag to 1
		p_press = 1;					//Set p press to 1 to stop multiple detections of PIN FALSE
		end
		end
		else begin						//If PIN FALSE is low
		pin_flag = 0;					//reset pin flag to 0
		p_press = 0;					//reset p press to 0 for next detection of PIN FALSE
		end
		
		if (pin_entry != 1) begin	//If pin entry is not high
		PIN[0] = 4'b0001;				//Set PIN Value 0 as Key 0
		PIN[1] =	4'b0010;				//Set PIN Value 1 as Key 1
		PIN[2] =	4'b0100;				//Set PIN Value 2 as Key 2
		PIN[3] = 4'b1000;				//Set PIN Value 3 as Key 3
		PIN[4] =	4'b0100;				//Set PIN Value 4 as Key 2
		PIN[5] = 4'b1000;				//Set PIN Value 5 as Key 3
		PIN_TRUE = 0;					//Reset PIN TRUE to 0
		PIN_FALSE = 0;					//Reset PIN FALSE to 0
		pin_entry = 1;					//Set pin entry to high to ensure pin is only set once
		end

		if(pin_test == 1) begin					//If pin test is set high (locking state once first set of PIN values entered)
		entry_number2 = entry_number - 6;	//entry number 2 set to entry number-6 as second set of PIN Values are entered
		end else begin								//If pin test is set low
		entry_number2 = entry_number;			//entry number 2 is set to entry number
		end
		
		if(entry_number2 == 0)  begin			//Entry number = 0
		redled = 6'b100000;						//All red leds are off
		end
		if(entry_number2 == 1)  begin			//Entry number = 1
		redled = 6'b110000;						//Turn on first red led
		end
		if(entry_number2 == 2)  begin			//Entry number = 2
		redled = 6'b111000;						//Turn on 2 red leds
		end
		if(entry_number2 == 3)  begin			//Entry number = 3
		redled = 6'b111100;						//Turn on 3 red leds
		end
		if(entry_number2 == 4) begin			//Entry number = 4
		redled = 6'b111110;						//Turn on 4 red leds
		end
		if(entry_number2 == 5) begin			//Entry number = 5
		redled = 6'b111111;						//Turn on 5 red leds
		end







case(state)						//Case Setup for state machine
	
	State_0: begin				//State 0 (Unlock state)
		
		seg_out = State_0;	//Set seven segment state to State 0


		PIN_STORE = PIN_Value;	//Store PIN value for PIN Entry
		

		if ((PIN_STORE != 4'b0000)&&(PIN_STORE != 0)&&(PIN_STORE2 == 4'b0000)) begin	//If stored PIN value is not 0 and previous pin value set to low
		PIN_INPUT[entry_number] = PIN_STORE;		//Save current PIN Value at element value based on entry number
		entry_number = entry_number+1;				//Increment entry number by 1 for next PIN Value input
		end		
		PIN_STORE2 = PIN_Value;							//Store previous PIN Value to be used in next loop
		
				
		if (entry_number >= 6) begin			//If entry number is 6 or more
		entry_number = 0;							//Reset entry number to 0
		PIN_TRUE = 0;								//Reset PIN TRUE to 0
		PIN_FALSE = 0;								//Reset PIN FALSE to 0
		
		//Check Each PIN Value element-by-element
			if (PIN_INPUT[0] == PIN[0]) begin	
				if (PIN_INPUT[1] == PIN[1]) begin
					if (PIN_INPUT[2] == PIN[2]) begin
						if (PIN_INPUT[3] == PIN[3]) begin
							if (PIN_INPUT[4] == PIN[4]) begin
								if (PIN_INPUT[5] == PIN[5]) begin //If All PIN Values are correct
						PIN_TRUE = 1;			//Set PIN TRUE to high
						state = State_1;		//Set state to state 1
						reset = 1;				//Set reset to high

								end 
							end
						end
					end
				end
			end
			
			
			if ((PIN_TRUE == 0) && (PIN_FALSE == 0)) begin //If both PIN TRUE and PIN False are set to low
			PIN_FALSE = 1;				//Set PIN FALSE to 1 
			p_press = 0;				//Reset p_press to 0
			savestate = state;		//save current state
			state = State_4;			//Set state to state 4
			reset = 1;					//Set reset to high
			end

		
end
		
end // End State_0 Unlock

State_1: begin //State 1 (Unlock->Lock transition state)

		seg_out = State_1;	//State 1 (lock state)
		

		if (((PIN_TRUE == 1) || (PIN_FALSE == 1))) begin	//If PIN TRUE or PIN FALSE are set to high
		reset = 1;				//Set reset to high
		state = State_3;		//Set state to state 3
		end
		
end // END State_1 (Transition to lock state)

State_2: begin	//State 2 (Lock->Unlock transition state)

		seg_out = State_0;	//State 0 (Unlock state)

		
		if (((PIN_TRUE == 1) || (PIN_FALSE == 1))) begin	//If PIN TRUE or PIN FALSE are set to high
		reset = 1;				//Set reset to high
		state = State_0;		//Set state to state 0
		end
		
end // END State_2 (Transition to Unlock state)

State_3: begin	//State 3 (Lock State)


		seg_out = State_1;	//State 1 (Lock state)

		
		PIN_STORE = PIN_Value;					//Store PIN value for PIN Entry
		if ((PIN_STORE != 4'b0000)&&(PIN_STORE != 0)&&(PIN_STORE2 == 4'b0000)) begin	//If stored PIN value is not 0 and previous pin value set to low
		PIN_LI[entry_number] = PIN_STORE;	//Save current PIN Value at element value based on entry number
		entry_number = entry_number+1;		//Increment entry number by 1 for next PIN Value input
		end
		PIN_STORE2 = PIN_Value;					//Store previous PIN Value to be used in next loop
		
		if (entry_number >= 6) begin			//If entry number is greater than 6
		pin_test = 1;								//Set pin test to high to reset red leds for next set of PIN Values
		end else begin								//otherwise
		pin_test = 0;								//Set pin test
		end
		
		if (entry_number >= 12) begin			//If entry number is 12 or more
		entry_number = 0;							//Reset entry number to 0
		pin_test = 0;								//Reset pin test to 0
		PIN_TRUE = 0;								//Reset PIN TRUE to 0
		PIN_FALSE = 0;								//Reset PIN FALSE to 0
		
		//Check Each PIN Value element-by-element
			if (PIN_LI[0] == PIN[0]) begin
				if (PIN_LI[1] == PIN[1]) begin
					if (PIN_LI[2] == PIN[2]) begin
						if (PIN_LI[3] == PIN[3]) begin
							if (PIN_LI[4] == PIN[4]) begin
								if (PIN_LI[5] == PIN[5]) begin
									if (PIN_LI[6] == PIN[0]) begin
										if (PIN_LI[7] == PIN[1]) begin
											if (PIN_LI[8] == PIN[2]) begin
												if (PIN_LI[9] == PIN[3]) begin
													if (PIN_LI[10] == PIN[4]) begin
														if (PIN_LI[11] == PIN[5]) begin	//If All PIN Values are correct
														PIN_TRUE = 1;			//Set PIN TRUE to high
														state = State_2;		//Set state to state 2
														reset = 1;				//Set reset to high
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end	

			if ((PIN_TRUE == 0) && (PIN_FALSE == 0)) begin	//If both PIN TRUE and PIN False are set to low
			PIN_FALSE = 1;			//Set PIN FALSE to high
			p_press = 0;			//Set p press to low
			savestate = state;	//Save current state in savestate variable
			state = State_4;		//Set state to state 4
			reset = 1;				//Set reset to high
			end
end						

end // END State_3	(Lock state)

State_4: begin	//State 4 (Error state)
		seg_out = State_2;		//Set 7-segment state to State 2 (Error state)
		
		if (((PIN_TRUE == 1) || (PIN_FALSE == 1))) begin	//If PIN TRUE or PIN FALSE are set to high
		reset = 1;				//Set reset to high
		state = savestate;	//set state to savestate
		end
end // END State_4 (Error state)

default: begin

end

endcase
end



//Instantiate Button Decryption submodule
b_test Button_Check(	
.clock_in(clock_in),							//Clock input from 50Mhz base clock
.Button_input0(Button_input0), 			//Button 0 input 
.Button_input1(Button_input1), 			//Button 1 input 
.Button_input2(Button_input2), 			//Button 2 input 
.Button_input3(Button_input3),  			//Button 3 input 
.Button_press(PIN_Value),					//Decrypted PIN Value out
.reset(rst)										//Reset flag for timeout
);

//Instantiate 7-Segment display driver submodule
seg7 Segment_Display(
.in_seg(seg_out),								//variable to set state for 7-segment state machine
.clock_in(clock_in),							//Clock input from 50Mhz base clock
.error(pin_flag),								//Error flag to display error message
.count_in(entry_number),					//Entry number count display for hardware testing only
.segm_disp0(seg5),							//Output for Segment 0
.segm_disp1(seg4),							//Output for Segment 1
.segm_disp2(seg3),							//Output for Segment 2
.segm_disp3(seg2),							//Output for Segment 3
.segm_disp4(seg1),							//Output for Segment 4
.segm_disp5(seg0)								//Output for Segment 5
);

endmodule 