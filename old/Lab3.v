module Lab3(clk_50mhz, left_leds, right_leds, left_switch, right_switch, ss_display, key_zero_reset, key_one_start);

input clk_50mhz;

input right_switch;
input left_switch;

output [9:5] left_leds;
output [4:0] right_leds;
reg [9:0] led_pattern;

output [0:7] ss_display; 

input key_zero_reset, key_one_start;

reg [0:4] repeat_count;

wire clk_01hz;
wire [0:3] tens;
wire [0:3] ones;
wire [0:5] pattern_step;
assign ones = (repeat_count % 10);
assign tens = (repeat_count - ones) / 10;
reg[0:4] delay;

clock_divider clocktest ( .clk_in(clk_50mhz),.clk_out(clk_01hz));


if (!left_switch) begin
			left_leds[9:5] = led_pattern[9:5];
	end else begin
			left_leds[9:5] = 0;
end
		
if (!right_switch) begin
			right_leds[4:0] = led_pattern[4:0];
	end else begin
			left_leds[4:0] = 0;
end


always @(negedge clk_01hz) begin
	
		if (pattern > 45) begin
			pattern_step = 1;
			repeat_count = repeat_count + 1;
		end else if (pattern == 32 || pattern == 12) begin
			if (delay >= 10) begin
				delay = 0;
				pattern_step = pattern_step + 1;
			end else begin
				delay = delay + 1;
			end
		end else
			pattern_step = pattern_step + 1;
		end
		

	 

endmodule



module translate(current_step, pattern);
	input wire current_step
	output reg [9:0] pattern;
	
	case (current_step)
    1: pattern = ;
    2: pattern = ;
    3: pattern = ;
    4: pattern = ;
	 5: pattern = ;
    6: pattern = ;
    7: pattern = ;
    8: pattern = ;
    9: pattern = ;
    10: pattern = ;
    11: pattern = ;
    12: pattern = ;
    13: pattern = ;
    14: pattern = ;
    15: pattern = ;
    16: pattern = ;
    17: pattern = ;
    18: pattern = ;
    19: pattern = ;
    20: pattern = ;
    21: pattern = ;
    22: pattern = ;
    23: pattern = ;
    24: pattern = ;
    25: pattern = ;
    26: pattern = ;
    27: pattern = ;
    28: pattern = ;
    29: pattern = ;
    30: pattern = ;
    31: pattern = ;
	 32: pattern = ;
	 33: pattern = ;
	 34: pattern = ;
	 35: pattern = ;
	 36: pattern = ;
	 37: pattern = ;
	 38: pattern = ;
	 39: pattern = ;
	 40: pattern = ;
	 41: pattern = ;
	 42: pattern = ;
	 43: pattern = ;
	 44: pattern = ;
	 45: pattern = ;

    
	
endmodule



module clock_divider(clk_in, clk_out);

	reg [0:25] counter;
	 input wire clk_in;       
    output reg clk_out; 
          

    always @(posedge clk_in) begin
		if (counter == 2500000 - 1) begin
            clk_out <= ~clk_out;
				counter <= 0;
        end 
		  else begin
            counter <= counter + 1;
        end
    end

endmodule


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
