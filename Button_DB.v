///////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip	//
//Module: Button Debounce Module					//
//Student: Syed Zaidi								//
//Student ID: 201047894								//
//Input Clock frequency: 50Mhz					//
//Clock enable frequency: 800Hz					//
///////////////////////////////////////////////


//Clog2 pre-processor macro to be used to calculate required address width
`define clog2(x) ( \
 ((x) <= 2) ? 1 : \
 ((x) <= 4) ? 2 : \
 ((x) <= 8) ? 3 : \
 ((x) <= 16) ? 4 : \
 ((x) <= 32) ? 5 : \
 ((x) <= 64) ? 6 : \
 ((x) <= 128) ? 7 : \
 ((x) <= 256) ? 8 : \
 ((x) <= 512) ? 9 : \
 ((x) <= 1024) ? 10 : \
 ((x) <= 2048) ? 11 : \
 ((x) <= 4096) ? 12 : 16)

module Button_DB 
(
input clk_in,				//Clock input (50Mhz)
input Button_in,			//Button input
output reg Button_out	//Button output
);

localparam DB_MAX = 32;						//Set Max Counter Value for Debounce
localparam DB_WIDTH = `clog2(DB_MAX);	//Calculates required Address width based on number of counter channels required
localparam DB_HIGH = ((9*DB_MAX)/10);	//Set high threshold at 90% of counter max value
localparam DB_LOW = ((1*DB_MAX)/10);	//Set low threshold at 10% of counter max value

				
reg [DB_WIDTH-1:0] counter = 0;			//Initialise counter at 0
reg Button_db = 0;							//Initialise Button output save variable at 0
reg Button_check = 0;						//Initialise Button input save variable at 0
wire clk_en;									//Wire for clock enable signal from frequency divider


freq_div #(200000) fd1 				//Instantiate frequency divider module adjusting the parameter for frequency
(.clk_in(clk_in),					//Clock input attached to clock coming in from hardware/simulation
.clk_out(clk_en)					//Clock output atached to clock enable signal for servo motors
);


always@(posedge clk_in)			//Triggered once every positive edge of clk_in
begin

	Button_check = Button_in;	//Save Button Value incoming to check variable
	

	if ((Button_db == 0) && (counter>DB_HIGH)) begin	//If output value is already low and counter value is above the high threshold
	Button_db = 1;													//Set Button_db to high
	end		
		
	if ((Button_db == 1) && (counter<DB_LOW)) begin		//If output value is already high and counter value is below the low threshold
	Button_db = 0;													//Set Button_db to low
	end

	Button_out = Button_db;		//Set Output value to Button_db value
	
end




always@(posedge clk_en)			//Triggered once every positive edge of clk_en
begin
	Button_check = Button_in;	//Save Button Value incoming to check variable
if ((Button_check == 1) && (clk_en == 1)) begin		//If check variable is high and clk_en is 1
	if (counter < (DB_MAX - 1)) begin					//If counter value is less than DB_MAX-1
	counter = counter + 1;									//Increment the counter by 1
	end
	end
		
	if ((Button_check == 0) && (clk_en == 1)) begin	//If check variable is low and clk_en is 1
	if (counter > 0) begin									//If counter value is greater than 0
	counter = counter - 1;									//Decrement counter by 1
	end
	end
	

end
endmodule
