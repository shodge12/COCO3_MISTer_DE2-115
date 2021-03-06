////////////////////////////////////////////////////////////////////////////////
// Project Name:	CoCo3FPGA Version 4.0
// File Name:		6850rx.v
//
// CoCo3 in an FPGA
//
// Revision: 4.0 07/10/16
////////////////////////////////////////////////////////////////////////////////
//
// CPU section copyrighted by John Kent
// The FDC co-processor copyrighted Daniel Wallner.
// SDRAM Controller copyrighted by XESS Corp.
//
////////////////////////////////////////////////////////////////////////////////
//
// Color Computer 3 compatible system on a chip
//
// Version : 4.0
//
// Copyright (c) 2008 Gary Becker (gary_l_becker@yahoo.com)
//
// All rights reserved
//
// Redistribution and use in source and synthezised forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
//
// Redistributions in synthesized form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
//
// Neither the name of the author nor the names of other contributors may
// be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Please report bugs to the author, but before you do so, please
// make sure that this is not a derivative work and that
// you have the latest version of this file.
//
// The latest version of this file can be found at:
//      http://groups.yahoo.com/group/CoCo3FPGA
//
// File history :
//
//  1.0			Full Release
//  2.0			Partial Release
//  3.0			Full Release
//  3.0.0.1		Update to fix DoD interrupt issue
//	3.0.1.0		Update to fix 32/40 CoCO3 Text issue and add 2 Meg max memory
//	4.0.X.X		Full Release
////////////////////////////////////////////////////////////////////////////////
// Gary Becker
// gary_L_becker@yahoo.com
////////////////////////////////////////////////////////////////////////////////

module UART_RX(
RESET_N,
BAUD_CLK,
RX_DATA,
RX_BUFFER,
//RX_READY,
RX_WORD,
RX_PAR_DIS,
RX_PARITY,
PARITY_ERR,
//OVERRUN,
FRAME,
READY
);

input					RESET_N;
input					BAUD_CLK;
input					RX_DATA;
output	[7:0]		RX_BUFFER;
reg		[7:0]		RX_BUFFER;
//input					RX_READY;
input					RX_WORD;
input					RX_PAR_DIS;
input					RX_PARITY;
output				PARITY_ERR;
reg					PARITY_ERR;
//output				OVERRUN;
//reg					OVERRUN;
output				FRAME;
reg					FRAME;
output				READY;
reg					READY;
reg		[5:0]		STATE;
reg		[2:0]		BIT;

reg					RX_DATA0;
reg					RX_DATA1;

always @ (posedge BAUD_CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		RX_BUFFER <= 8'h00;
		STATE <= 6'b000000;
//		OVERRUN <= 1'b0;
		FRAME <= 1'b0;
		BIT <= 3'b000;
		RX_DATA0 <= 1'b1;
		RX_DATA1 <= 1'b1;
		READY <= 1'b0;
	end
	else
	begin
		RX_DATA0 <= RX_DATA;
		RX_DATA1 <= RX_DATA0;
		case (STATE)
		6'b000000:
		begin
			BIT <= 3'b000;
			if(~RX_DATA1)
				STATE <= 6'b000001;
		end
		6'b001111:								// End of start bit, flag data not ready
		begin										// If data is not retrieved before this, then overrun
			READY <= 1'b0;
			STATE <= 6'b010000;
		end
		6'b010111:								// Middle of data bits
		begin
//			READY <= 1'b0;
			RX_BUFFER[BIT] <= RX_DATA1;
//			OVERRUN <= RX_READY;
			STATE <= 6'b011000;
		end
		6'b011111:								// End of data bit
		begin
			if(BIT == 3'b111)
				STATE <= 6'b100000;
			else
			begin
				if((BIT == 3'b110) && !RX_WORD)
					STATE <= 6'b100000;
				else
				begin
					BIT <= BIT + 1;
					STATE <= 6'b010000;
				end
			end
		end
		6'b100000:							// Start of parity bit, if enabled
		begin
			if(RX_PAR_DIS)
				STATE <= 6'b110001;		// get stop
			else
				STATE <= 6'b100001;		// get parity
		end
		6'b100111:							//39 middle of parity bit
		begin
			PARITY_ERR <=((((RX_BUFFER[0] ^ RX_BUFFER[1])
							 ^  (RX_BUFFER[2] ^ RX_BUFFER[3]))
							 ^ ((RX_BUFFER[4] ^ RX_BUFFER[5])
							 ^  (RX_BUFFER[6] ^ (RX_BUFFER[7] & RX_WORD))))	// clear bit #8 if only 7 bits
							 ^  (RX_PARITY ^ RX_DATA1));
			STATE <= 6'b101000;
		end
		6'b110111:							//55 middle of stop bit
		begin
			READY <= 1'b1;					// This is the last info we need, so signal ready
			FRAME <= !RX_DATA1;			// if data != 1 then not stop bit
			STATE <= 6'b111000;
		end
// In case of a framing error, wait until data is 1 then start over
		6'b111000:
		begin
			if(RX_DATA1)						// wait until data = 1
				STATE <= 6'b000000;
		end
		default: STATE <= STATE + 1;
		endcase
	end
end

endmodule
