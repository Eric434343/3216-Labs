
//Eric and Elyse EECS 3216 lab3

module lab3(
    input clk_50mhz,
    input control_switch1,
    input control_switch2,
    input key_zero_reset,
    input key_one_start,

    output reg [9:5] led_set1,
    output reg [4:0] led_set2,
    output [0:6] ss_display
);

// ------------------------------
// RESET + START (buttons are active low)
// ------------------------------
wire reset = ~key_zero_reset;
wire start = ~key_one_start;


// ------------------------------
// CLOCK DIVIDER (0.1 second tick)
// 50MHz → toggle every 2.5M → 5M = 0.1s
// ------------------------------
wire clk_01hz;

clock_divider clkdiv(
    .clk_in(clk_50mhz),
    .clk_out(clk_01hz)
);


// ------------------------------
// REGS
// ------------------------------
reg [9:0] led_pattern;
reg [5:0] pattern_step;
reg [5:0] delay;

reg [4:0] repeat_count = 9;   
reg started;


// ------------------------------
// PATTERN TABLE 
// ------------------------------
wire [9:0] pattern [0:43];

assign pattern[0]  = 10'b0000110000;
assign pattern[1]  = 10'b0001111000;
assign pattern[2]  = 10'b0011111100;
assign pattern[3]  = 10'b0111111110;
assign pattern[4]  = 10'b1111111111;
assign pattern[5]  = 10'b0000000000;
assign pattern[6]  = 10'b0000110000;
assign pattern[7]  = 10'b0001111000;
assign pattern[8]  = 10'b0011111100;
assign pattern[9]  = 10'b0111111110;
assign pattern[10] = 10'b1111111111;
assign pattern[11] = 10'b1000000001;
assign pattern[12] = 10'b1100000001;
assign pattern[13] = 10'b1110000001;
assign pattern[14] = 10'b1011000001;
assign pattern[15] = 10'b1001100001;
assign pattern[16] = 10'b1000110001;
assign pattern[17] = 10'b1000011001;
assign pattern[18] = 10'b1000001101;
assign pattern[19] = 10'b1000000111;
assign pattern[20] = 10'b1000000011;
assign pattern[21] = 10'b1000000001;
assign pattern[22] = 10'b1000000011;
assign pattern[23] = 10'b1000000111;
assign pattern[24] = 10'b1000001101;
assign pattern[25] = 10'b1000011001;
assign pattern[26] = 10'b1000110001;
assign pattern[27] = 10'b1001100001;
assign pattern[28] = 10'b1011000001;
assign pattern[29] = 10'b1110000001;
assign pattern[30] = 10'b1100000001;
assign pattern[31] = 10'b1100000011;
assign pattern[32] = 10'b1110000111;
assign pattern[33] = 10'b1111001111;
assign pattern[34] = 10'b1111111111;
assign pattern[35] = 10'b0000110000;
assign pattern[36] = 10'b0001111000;
assign pattern[37] = 10'b0011001100;
assign pattern[38] = 10'b0110000110;
assign pattern[39] = 10'b1100000011;
assign pattern[40] = 10'b1000000001;
assign pattern[41] = 10'b0000000000;
assign pattern[42] = 10'b0000000000;
assign pattern[43] = 10'b0000000000;


// ------------------------------
// LIVE CLOCK LOGIC
// ------------------------------
always @(posedge clk_01hz or posedge reset) begin

    if(reset) begin
        pattern_step <= 0;
        delay <= 0;
        started <= 0;
        led_pattern <= 10'b0;
    end

    else begin

        // wait for KEY1 start
        if(start) begin
            started <= 1;
		end
        
		  if(started) begin

            led_pattern <= pattern[pattern_step];
				
            // 2 second initial delay (20 × 0.1s)
            if(pattern_step == 0) begin
					if (delay < 20) begin
						delay <= delay + 1;
					end else begin
					delay <= 0;
					pattern_step <= 1;
					end
				end
				
            else if(pattern_step == 11 || pattern_step == 31) begin
                if(delay > 9) begin
                    delay <= 0;
                    pattern_step <= pattern_step + 1;
                end else
                    delay <= delay + 1;
            end

            // normal stepping
            else begin
                pattern_step <= pattern_step + 1;
            end

            // finished sequence
            if(pattern_step > 43) begin
                pattern_step <= 0;
                repeat_count <= repeat_count + 1;
            end
        end
    end
end


// ------------------------------
// LED SWITCHES
// ------------------------------
always @(*) begin
    led_set1  = (control_switch1)  ? 5'b00000 : led_pattern[9:5];
    led_set2 = (control_switch2) ? 5'b00000 : led_pattern[4:0];
end


// ------------------------------
// 7 SEG DISPLAY
// ------------------------------
display disp0(
    .bit(repeat_count[3:0]),
    .out(ss_display)
);

endmodule


// ------------------------------
// CLOCK DIVIDER MODULE
// ------------------------------
module clock_divider(
    input clk_in,
    output reg clk_out
);

reg [25:0] counter = 0;

always @(posedge clk_in) begin 
    if(counter == 2_500_000-1) begin 
        clk_out <= ~clk_out; 
        counter <= 0; 
    end else 
        counter <= counter + 1; 
end 
 
endmodule 




// ------------------------------
// 7 SEG DECODER
// ------------------------------
module display(out, bit,);
	input [3:0] bit;
	output [0:6] out;
	
	//Top middle.
	assign out[0] = (~bit[3] & ~bit[2] & ~bit[1] & bit[0])|(~bit[3] & bit[2] & ~bit[1] & ~bit[0])|(bit[3] & ~bit[2] & bit[1] & bit[0])|(bit[3] & bit[2] & ~bit[1] & bit[0]);
	
	//Top right.                                  
	assign out[1] = (~bit[3] & bit[2] & ~bit[1] & bit[0])|(~bit[3] & bit[2] & bit[1] & ~bit[0])|(bit[3] & ~bit[2] & bit[1] & bit[0])|(bit[3] & bit[2] & ~bit[1] & ~bit[0]) |(bit[3] & bit[2] & bit[1]);
	
	//Bottom right.        
	assign out[2] = (~bit[3] & ~bit[2] & bit[1] & ~bit[0])| (bit[3] & bit[2] & ~bit[1] & ~bit[0])| (bit[3] & bit[2] & bit[1]) ;
	
	//Bottom middle.
	assign out[3] = (bit[2] & bit[1] & bit[0])| (~bit[2] & ~bit[1] & bit[0]) |(~bit[3] & bit[2] & ~bit[1] & ~bit[0])|(bit[3] & ~bit[2] & bit[1] & ~bit[0]);
	
	//Bottom left.
	assign out[4] = (~bit[3] & ~bit[2] & bit[0]) | (~bit[3] & bit[2] & ~bit[1]) | (~bit[3] & bit[2] & bit[1] & bit[0]) | (bit[3] & ~bit[2] & ~bit[1] & bit[0]) ;
	
	//Top left.
	assign out[5] = (~bit[3] & ~bit[2] & ~bit[1] & bit[0])|(~bit[3] & ~bit[2] & bit[1] & ~bit[0])|(~bit[3] & ~bit[2] & bit[1] & bit[0])|(~bit[3] & bit[2] & bit[1] & bit[0])|(bit[3] & bit[2] & ~bit[1] & bit[0]);
	
	//Middle Middle.    
	assign out[6] = (~bit[3] & ~bit[2] & ~bit[1])|(~bit[3] & bit[2] & bit[1] & bit[0])|(bit[3] & bit[2] & ~bit[1] & ~bit[0]);
	
endmodule 


