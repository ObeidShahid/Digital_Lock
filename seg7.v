///////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip	//
//Module: 7-Segment Display module				//
//Student: Syed Zaidi								//
//Student ID: 201047894								//
//Input Clock frequency: 505Mhz					//
//Clock enable frequency: 1Hz						//
///////////////////////////////////////////////

module seg7
(
input [2:0]in_seg,				//State variable value incoming
input clock_in,					//Input clock at 50Mhz
input error,						//input error flag
input [16:0] count_in,			//Counter for hardware testing purposes
output reg [6:0] segm_disp0,	//Output for 7-segment digit 0
output reg [6:0] segm_disp1,	//Output for 7-segment digit 1
output reg [6:0] segm_disp2,	//Output for 7-segment digit 2
output reg [6:0] segm_disp3,	//Output for 7-segment digit 3
output reg [6:0] segm_disp4,	//Output for 7-segment digit 4
output reg [6:0] segm_disp5	//Output for 7-segment digit 5
);

//Local paramaters for State names
localparam State_0 = 3'b000;
localparam State_1 = 3'b001;
localparam State_2 = 3'b010;
localparam State_3 = 3'b011;
localparam State_4 = 3'b100;
localparam State_5 = 3'b101;

//local parameters for 7-segment values to display letters and numbers
localparam seg_C = 7'b0100111;		//Display letter C
localparam seg_L = 7'b1000111;		//Display letter L
localparam seg_O = 7'b1000000;		//Display letter O
localparam seg_S = 7'b0010010;		//Display letter S
localparam seg_E = 7'b0000110;		//Display letter E
localparam seg_D = 7'b0100001;		//Display letter D
localparam seg_P = 7'b0001100;		//Display letter P
localparam seg_N = 7'b0101011;		//Display letter N
localparam seg_R = 7'b0101111;		//Display letter R
localparam seg_CL = 7'b1111111;		//Clear 7-Segment display
localparam seg_0 = 7'b1000000;		//Display number 0
localparam seg_1 = 7'b1111001;		//Display number 1
localparam seg_2 = 7'b0100100;		//Display number 2
localparam seg_3 = 7'b0110000;		//Display number 3
localparam seg_4 = 7'b0011001;		//Display number 4
localparam seg_5 = 7'b0010010;		//Display number 5
localparam seg_6 = 7'b0000010;		//Display number 6
localparam seg_7 = 7'b1111000;		//Display number 7
localparam seg_8 = 7'b0000000;		//Display number 8
localparam seg_9 = 7'b0010000;		//Display number 9

integer Value_in = 0;					//Initialise Value in at 0 for counter testing

reg [2:0] seg7_state = State_0;		//Initialise State variable at state 0
reg [4:0] e_count = 0;					//Initialise error counter at 0
wire clk_en;								//Clock enable wire for error counter
reg c_flag = 0;							//Initialise Clock flag at 0
reg error_flag = 0;						//Initialise error flag at 0

always@(posedge clock_in) begin		//Triggered at positive edge of each clock cycle (50Mhz)

if (error_flag == 1) begin				//If error flag is set to high
if (clk_en == 1) begin					//If clk_en is set to high
if (c_flag == 0) begin					//If c_flag is set to low
	e_count = e_count+1;					//Increment e_count by 1
	c_flag = 1;								//Set c_flag to 1 to stop multiple detections

end
end
else if (clk_en == 0) begin			//If clk_en is set to low
	c_flag = 0;								//Rest c_flag to 0 for next clk_en detection

end
end


if (e_count == 2) begin					//If error counter reaches 2 (2 seconds)
	e_count = 15;							//Set counter to known high value
	error_flag = 0;						//Reset error flag
end

if (error_flag == 0) begin				//If error flag is 0 so no error detected
seg7_state = in_seg;						//set state to incoming state
e_count = 15;								//Set error count to known high value
end

if (error == 1) begin					//If error is detected
	seg7_state = State_2;				//Set state to state 2 (error)
	error_flag = 1;						//Set error flag to high
	e_count = 0;							//reset error counter
end
		
case(seg7_state)
	State_0: begin //Display message 'Closed'


		segm_disp0 = seg_C;
		segm_disp1 = seg_L;
		segm_disp2 = seg_O;
		segm_disp3 = seg_S;
		segm_disp4 = seg_E;
		segm_disp5 = seg_D;
	
	end
	
	State_1: begin //Display message 'Open'
		segm_disp0 = seg_O;
		segm_disp1 = seg_P;
		segm_disp2 = seg_E;
		segm_disp3 = seg_N;
		segm_disp4 = seg_CL;
		segm_disp5 = seg_CL;
	end
	
	State_2: begin //Display message 'Error'
		segm_disp0 = seg_E;
		segm_disp1 = seg_R;
		segm_disp2 = seg_R;
		segm_disp3 = seg_O;
		segm_disp4 = seg_R;
		segm_disp5 = seg_CL;
	
	end
	
	State_3: begin	//Display message 'Reset'
		segm_disp0 = seg_CL;
		segm_disp1 = seg_CL;
		segm_disp2 = seg_CL;
		segm_disp3 = seg_CL;
		segm_disp4 = seg_CL;
		segm_disp5 = seg_CL;
	
	end
	
	State_4: begin	//Display counter value (Only for hardware testing of Button outputs)
	
	Value_in = count_in;				//Read Value in into count_in
	
	//Calculates value to display for Digit 0
	if(Value_in >= 900000) begin
	segm_disp0 = seg_9;
	Value_in = Value_in - 900000;
	end else
	if(Value_in >= 800000) begin
	segm_disp0 = seg_8;
	Value_in = Value_in - 800000;
	end else
	if(Value_in >= 700000) begin 
	segm_disp0 = seg_7;
	Value_in = Value_in - 700000;
	end else
	if(Value_in >= 600000) begin 
	segm_disp0 = seg_6;
	Value_in = Value_in - 600000;
	end else
	if(Value_in >= 500000) begin 
	segm_disp0 = seg_5;
	Value_in = Value_in - 500000;
	end else
	if(Value_in >= 400000) begin 
	segm_disp0 = seg_4;
	Value_in = Value_in - 400000;
	end else
	if(Value_in >= 300000) begin 
	segm_disp0 = seg_3;
	Value_in = Value_in - 300000;
	end else
	if(Value_in >= 200000) begin 
	segm_disp0 = seg_2;
	Value_in = Value_in - 200000;
	end else
	if(Value_in >= 100000) begin 
	segm_disp0 = seg_1;
	Value_in = Value_in - 100000;
	end else segm_disp0 = seg_0;
	
	
	//Calculates value to display for Digit 1
	if(Value_in >= 90000) begin 
	segm_disp1 = seg_9;
	Value_in = Value_in - 90000;
	end else
	if(Value_in >= 80000) begin 
	segm_disp1 = seg_8;
	Value_in = Value_in - 80000;
	end else
	if(Value_in >= 70000) begin 
	segm_disp1 = seg_7;
	Value_in = Value_in - 70000;
	end else
	if(Value_in >= 60000) begin 
	segm_disp1 = seg_6;
	Value_in = Value_in - 60000;
	end else
	if(Value_in >= 50000) begin 
	segm_disp1 = seg_5;
	Value_in = Value_in - 50000;
	end else
	if(Value_in >= 40000) begin 
	segm_disp1 = seg_4;
	Value_in = Value_in - 40000;
	end else
	if(Value_in >= 30000) begin 
	segm_disp1 = seg_3;
	Value_in = Value_in - 30000;
	end else
	if(Value_in >= 20000) begin 
	segm_disp1 = seg_2;
	Value_in = Value_in - 20000;
	end else
	if(Value_in >= 10000) begin 
	segm_disp1 = seg_1;
	Value_in = Value_in - 10000;
	end else segm_disp1 = seg_0;
	
	
	//Calculates value to display for Digit 2
	if(Value_in >= 9000) begin 
	segm_disp2 = seg_9;
	Value_in = Value_in - 9000;
	end else
	if(Value_in >= 8000) begin 
	segm_disp2 = seg_8;
	Value_in = Value_in - 8000;
	end else
	if(Value_in >= 7000) begin 
	segm_disp2 = seg_7;
	Value_in = Value_in - 7000;
	end else
	if(Value_in >= 6000) begin 
	segm_disp2 = seg_6;
	Value_in = Value_in - 6000;
	end else
	if(Value_in >= 5000) begin 
	segm_disp2 = seg_5;
	Value_in = Value_in - 5000;
	end else
	if(Value_in >= 4000) begin 
	segm_disp2 = seg_4;
	Value_in = Value_in - 4000;
	end else
	if(Value_in >= 3000) begin 
	segm_disp2 = seg_3;
	Value_in = Value_in - 3000;
	end else
	if(Value_in >= 2000) begin 
	segm_disp2 = seg_2;
	Value_in = Value_in - 2000;
	end else
	if(Value_in >= 1000) begin 
	segm_disp2 = seg_1;
	Value_in = Value_in - 1000;
	end else segm_disp2 = seg_0;
	
	//Calculates value to display for Digit 3
	if(Value_in >= 900) begin 
	segm_disp3 = seg_9;
	Value_in = Value_in - 900;
	end else
	if(Value_in >= 800) begin 
	segm_disp3 = seg_8;
	Value_in = Value_in - 800;
	end else
	if(Value_in >= 700) begin 
	segm_disp3 = seg_7;
	Value_in = Value_in - 700;
	end else
	if(Value_in >= 600) begin 
	segm_disp3 = seg_6;
	Value_in = Value_in - 600;
	end else
	if(Value_in >= 500) begin 
	segm_disp3 = seg_5;
	Value_in = Value_in - 500;
	end else
	if(Value_in >= 400) begin 
	segm_disp3 = seg_4;
	Value_in = Value_in - 400;
	end else
	if(Value_in >= 300) begin 
	segm_disp3 = seg_3;
	Value_in = Value_in - 300;
	end else
	if(Value_in >= 200) begin 
	segm_disp3 = seg_2;
	Value_in = Value_in - 200;
	end else
	if(Value_in >= 100) begin 
	segm_disp3 = seg_1;
	Value_in = Value_in - 100;
	end else segm_disp3 = seg_0;
	
	
	//Calculates value to display for Digit 4
	if(Value_in >= 90) begin 
	segm_disp4 = seg_9;
	Value_in = Value_in - 90;
	end else
	if(Value_in >= 80) begin 
	segm_disp4 = seg_8;
	Value_in = Value_in - 80;
	end else
	if(Value_in >= 70) begin 
	segm_disp4 = seg_7;
	Value_in = Value_in - 70;
	end else
	if(Value_in >= 60) begin 
	segm_disp4 = seg_6;
	Value_in = Value_in - 60;
	end else
	if(Value_in >= 50) begin 
	segm_disp4 = seg_5;
	Value_in = Value_in - 50;
	end else
	if(Value_in >= 40) begin 
	segm_disp4 = seg_4;
	Value_in = Value_in - 40;
	end else
	if(Value_in >= 30) begin 
	segm_disp4 = seg_3;
	Value_in = Value_in - 30;
	end else
	if(Value_in >= 20) begin 
	segm_disp4 = seg_2;
	Value_in = Value_in - 20;
	end else
	if(Value_in >= 10) begin 
	segm_disp4 = seg_1;
	Value_in = Value_in - 10;
	end else segm_disp4 = seg_0;
	
	
	//Calculates value to display for Digit 5
	if(Value_in >= 9) begin 
	segm_disp5 = seg_9;
	Value_in = Value_in - 9;
	end else
	if(Value_in >= 8) begin 
	segm_disp5 = seg_8;
	Value_in = Value_in - 8;
	end else
	if(Value_in >= 7) begin 
	segm_disp5 = seg_7;
	Value_in = Value_in - 7;
	end else
	if(Value_in >= 6) begin 
	segm_disp5 = seg_6;
	Value_in = Value_in - 6;
	end else
	if(Value_in >= 5) begin 
	segm_disp5 = seg_5;
	Value_in = Value_in - 5;
	end else
	if(Value_in >= 4) begin 
	segm_disp5 = seg_4;
	Value_in = Value_in - 4;
	end else
	if(Value_in >= 3) begin 
	segm_disp5 = seg_3;
	Value_in = Value_in - 3;
	end else
	if(Value_in >= 2) begin 
	segm_disp5 = seg_2;
	Value_in = Value_in - 2;
	end else
	if(Value_in >= 1) begin 
	segm_disp5 = seg_1;
	Value_in = Value_in - 1;
	end else segm_disp5 = seg_0;
	
	end

endcase

end

freq_div #(1) fd1 			//Instantiate frequency divider submodule adjusting the parameter for clock rate desired
(.clk_in(clock_in),			//Clock input attached to clock coming in from hardware/simulation
.clk_out(clk_en)				//Clock output atached to clock enable signal for error timer
);


endmodule
