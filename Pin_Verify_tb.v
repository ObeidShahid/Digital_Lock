/////////////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip			//
//Module: PIN Verification test bench  				//
//Student: Syed Zaidi										//
//Student ID: 201047894										//
//Base clock frequency = 50Mhz	   					//
/////////////////////////////////////////////////////

`timescale 1ns/100ps

module Pin_Verify_tb;


//
// Parameter Declarations
//
localparam NUM_CYCLES = 20000000; //Simulate this many clock cycles. Max. 1 billion
localparam CLOCK_FREQ = 50000000; //Clock frequency (in Hz)
localparam RST_CYCLES = 2; //Number of cycles of reset at beginning.
//
// Test Bench Generated Signals
//

//wire [3:0]Button_in_inv;
reg clock;
reg reset;

//
// Reset Logic
//
initial begin
 reset = 1'b1; //Start in reset.
 repeat(RST_CYCLES) @(posedge clock); //Wait for a couple of clocks
 reset = 1'b0; //Then clear the reset signal.
end
//
//Clock generator + simulation time limit.
//
initial begin
 clock = 1'b0; //Initialise the clock to zero.
end
//Next we convert our clock period to nanoseconds and half it
//to work out how long we must delay for each half clock cycle
//Note how we convert the integer CLOCK_FREQ parameter it a real
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
//Now generate the clock
integer half_cycles = 0;
always begin
 //Generate the next half cycle of clock
 #(HALF_CLOCK_PERIOD); //Delay for half a clock period.
 clock = ~clock; //Toggle the clock
 half_cycles = half_cycles + 1; //Increment the counter

 //Check if we have simulated enough half clock cycles
 if (half_cycles == (2*NUM_CYCLES)) begin
 //Once the number of cycles has been reached
 $stop; //Break the simulation
 //Note: We can continue the simualation after this breakpoint using
 //"run -continue" or "run ### ns" in modelsim.
 end
end

//Signal Initialision
reg [3:0]Button_in;			//4-bit wide button input register
wire PIN_TRUE;					//PIN TRUE flag
wire PIN_FALSE;				//PIN FALSE flag
wire [6:0] seg0;				//7-Segment display digit 0
wire [6:0] seg1;				//7-Segment display digit 1
wire [6:0] seg2;				//7-Segment display digit 2
wire [6:0] seg3;				//7-Segment display digit 3
wire [6:0] seg4;				//7-Segment display digit 4
wire [6:0] seg5;				//7-Segment display digit 5
wire [6:0]redled;				//Red led output


always@(negedge Button_in[0]) begin	//Every Negative Edge of Key 0 
$display("KEY 0 PRESSED!\n");		//Display KEY 0 pressed message
end

always@(negedge Button_in[1]) begin	//Every Negative Edge of Key 1 
$display("KEY 1 PRESSED!\n");		//Display KEY 1 pressed message
end

always@(negedge Button_in[2]) begin	//Every Negative Edge of Key 2 
$display("KEY 2 PRESSED!\n");		//Display KEY 2 pressed message
end
always@(negedge Button_in[3]) begin	//Every Negative Edge of Key 3 
$display("KEY 3 PRESSED!\n");		//Display KEY 3 pressed message
end

always@(posedge PIN_FALSE) begin	//Every Positive Edge of PIN FALSE
$display("ERROR! The entered PIN Was incorrect!\n");		//Display incorrect PIN message
end

always@(posedge PIN_TRUE) begin	//Every Positive Edge of PIN FALSE
$display("SUCCESS! The PIN was entered correctly!\n");		//Display correct PIN message
end


Pin_Verify PINTEST				//Top level module instantiation
(
.clock_in(clock),					
.Button_input0(Button_in[0]),
.Button_input1(Button_in[1]),
.Button_input2(Button_in[2]),
.Button_input3(Button_in[3]),
.PIN_TRUE(PIN_TRUE),
.PIN_FALSE(PIN_FALSE),
.seg0(seg0),
.seg1(seg1),
.seg2(seg2),
.seg3(seg3),
.seg4(seg4),
.seg5(seg5),
.redled_out(redled)
);


initial

begin

	
	Button_in = ~4'b0000;
	#2000000;
	
	//First Unlocking sequence (incorrect)
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;
	#2000000;
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	
	//Second Unlocking sequence (correct)
	Button_in[0] = 0;
	#2000000;
	Button_in[0] = 1;	
	#2000000;	
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	
	//First locking sequence (incorrect)
	Button_in[0] = 0;
	#2000000;
	Button_in[0] = 1;	
	#2000000;	
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;
	#2000000;
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	
	//Second locking sequence (correct)
	Button_in[0] = 0;
	#2000000;
	Button_in[0] = 1;	
	#2000000;	
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[0] = 0;
	#2000000;
	Button_in[0] = 1;	
	#2000000;	
	Button_in[1] = 0;
	#2000000;
	Button_in[1] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	Button_in[2] = 0;
	#2000000;
	Button_in[2] = 1;	
	#2000000;
	Button_in[3] = 0;
	#2000000;
	Button_in[3] = 1;	
	#2000000;
	
end

endmodule
