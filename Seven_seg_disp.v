
module Seven_seg_disp(
				input wire clk_12MHz,
				output reg [2:0] SevenSeg_enable, 
				output reg [6:0] SegmentSelect
				);
		
		reg [23:0]	counter;	//counter for reducing clock frequency
		reg [9:0] 	displayed_number;//number to display
		reg [1:0]	led_activating_counter;
		reg [3:0]	bcd_digit;
		
		always @(posedge clk_12MHz)
		begin
			if(counter >=11999999)
				counter<=0;
			else
				counter<=counter+1;
		end
		
		always @(posedge counter[21])
		begin
			if(displayed_number >=999)
				displayed_number<=0;
			else
				displayed_number<=displayed_number+1;
		end
		
		
		always @(posedge counter[14])
		begin
			if(led_activating_counter>=2)
				led_activating_counter<=0;
			else
				led_activating_counter<=led_activating_counter+1;
		end
		
		always @(*)
		begin
		
		case(led_activating_counter)
		2'b00:begin
				SevenSeg_enable=3'b110;	//enable at LOW
				bcd_digit=(displayed_number%10);// digit at unit position
				end
		2'b01:begin
				SevenSeg_enable=3'b101;
				bcd_digit=((displayed_number/10)%10);// digit at ten position
				end
		2'b10:begin
				SevenSeg_enable=3'b011;
				bcd_digit=displayed_number/100;// digit at hundred position
				end
		endcase
		end
		
		always @(*)
		begin
			case(bcd_digit)
			4'b0000: SegmentSelect = 7'b0000001; // "0"     
			4'b0001: SegmentSelect = 7'b1001111; // "1" 
			4'b0010: SegmentSelect = 7'b0010010; // "2" 
			4'b0011: SegmentSelect = 7'b0000110; // "3" 
			4'b0100: SegmentSelect = 7'b1001100; // "4" 
			4'b0101: SegmentSelect = 7'b0100100; // "5" 
			4'b0110: SegmentSelect = 7'b0100000; // "6" 
			4'b0111: SegmentSelect = 7'b0001111; // "7" 
			4'b1000: SegmentSelect = 7'b0000000; // "8"     
			4'b1001: SegmentSelect = 7'b0000100; // "9" 
        endcase
			
		end
		
endmodule
