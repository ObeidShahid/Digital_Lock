///////////////////////////////////////////////
//ELEC 5566M: FPGA Design for System on Chip	//
//Module: Frequency Divider Module				//
//Student: Syed Zaidi								//
//Student ID: 201047894								//
//Input Clock frequency: 50Mhz					//
//Output clock frequency: Set by parameter	//
///////////////////////////////////////////////

module freq_div #(
parameter FREQUENCY = 50000000 	//Set initial value to 50Mhz
)
(
input clk_in,							//clock input (50Mhz)
output clk_out						//adjusted clock output
						
);

localparam FREQ_DIV = 50000000/FREQUENCY;		//Divide clock frequency by required frequency to get the limit for counter
reg [26:0] counter = FREQ_DIV*2;					//counter set to limit calculated earlier
reg [26:0] FREQ_LIMIT = FREQ_DIV*2;				//Set Frequency limit to double the counter starting value
wire count_out;										//count_out wire used mainly for testing

always@(posedge clk_in)begin 							//always at positive edge of clock in decrement counter by one

if (counter > 0) begin counter <= counter - 1;	//If counter is greater than 0 decrement counter by 1
end else begin 											//until counter reaches zero
counter <= FREQ_DIV*2; 									//once counter reaches zero reset counter to max value
end
end
assign clk_out = (counter>=((FREQ_DIV)))?1:0;	//clock out sends a high signal if counter is below the limit calculated earlier
assign count_out = counter;							//Test variable

endmodule
