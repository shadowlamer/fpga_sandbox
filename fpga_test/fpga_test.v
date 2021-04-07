module fpga_test (
  input CLK, KEY1, KEY2, KEY3, KEY4,
  output DIG1, DIG2, DIG3, DIG4, SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, LED1
 );

  reg [25:0] divider;

  reg [1:0] digit_counter;
  reg [3:0] current_digit;	
  
  reg [4:0] digit1;
  reg [4:0] digit2;
  reg [4:0] digit3;
  reg [4:0] digit4;
  
  wire [6:0] segments;
  reg [4:0] digit;
  
  wire [3:0] buttons;
  
  wire slow_clk;
  
  hex_to_7seg hs (
		.hex(digit),
		.seg(segments)
  );
  
  debouncer deb1 (
		.clk(slow_clk),
		.in(~KEY1),
		.out(buttons[0]),
		.t(4'hf)
  );

  debouncer deb2 (
		.clk(slow_clk),
		.in(~KEY2),
		.out(buttons[1]),
		.t(4'hf)
  );

  debouncer deb3 (
		.clk(slow_clk),
		.in(~KEY3),
		.out(buttons[2]),
		.t(4'hf)
  );
  
  debouncer deb4 (
		.clk(slow_clk),
		.in(~KEY4),
		.out(buttons[3]),
		.t(4'hf)
  );

  assign slow_clk = divider[16];
  
  always @(posedge CLK) divider <= divider + 1;
  always @(posedge slow_clk) digit_counter <= digit_counter + 1;

  always @(digit_counter)
	  case (digit_counter)
			0 : current_digit = 4'b1110;
			1 : current_digit = 4'b1101;
			2 : current_digit = 4'b1011;
			3 : current_digit = 4'b0111;
			default : current_digit = 4'b1111; 
	  endcase

  always @(digit_counter)
	  case (digit_counter)
			0 : digit <= digit1;
			1 : digit <= digit2;
			2 : digit <= digit3;
			3 : digit <= digit4;
			default : digit = 4'b1111; 
	  endcase
	  
  always @(posedge buttons[0]) begin
    digit1 <= digit1 + 1;
	 if (digit1 >= 9) digit1 <= 4'd0;
  end
  always @(posedge buttons[1]) begin
    digit2 <= digit2 + 1;
	 if (digit2 >= 9) digit2 <= 4'd0;
  end
  always @(posedge buttons[2]) begin
    digit3 <= digit3 + 1;
	 if (digit3 >= 9) digit3 <= 4'd0;
  end
  always @(posedge buttons[3]) begin
    digit4 <= digit4 + 1;
	 if (digit4 >= 9) digit4 <= 4'd0;
  end
  
  	  
assign { SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6 } = segments;
assign {DIG1, DIG2, DIG3, DIG4} = current_digit;
assign LED1 = slow_clk;

endmodule