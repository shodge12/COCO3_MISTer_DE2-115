////////////////////////////////////////////////////////////////////////////////
// Project Name:	CoCo3FPGA Version 3.0
// File Name:		coco3fpga.v
//
// CoCo3 in an FPGA
//
// Revision: 3.0 08/15/15
////////////////////////////////////////////////////////////////////////////////
//
// CPU section copyrighted by John Kent
// The FDC co-processor copyrighted Daniel Wallner.
//
////////////////////////////////////////////////////////////////////////////////
//
// Color Computer 3 compatible system on a chip
//
// Version : 4.1.2
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
//	4.1.2.X		Fixed 6502 code for drivewire, removed timer, fixed 6551 baud 
//				rate (& DE2-115 compiler symbol)
////////////////////////////////////////////////////////////////////////////////
// Gary Becker
// gary_L_becker@yahoo.com
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// DE2-115 Conversion by Stan Hodge
// shodgefamily@yahoo.com
// Conversion is made via a defined symbol 'DE2_115'  Code of the original code
// base 4.1.2 is manipulated with `ifdef' and 'ifndef' compiler directives
////////////////////////////////////////////////////////////////////////////////

//	SRH
//	Un-comment for DE2-115
//`define DE2_115
//

//	SRH	MISTer
//	Un-comment for MISTer
`define MISTer

`ifdef MISTer

	`define INT_RAM

	`ifndef DE2_115
		`define DE2_115
	`endif
`endif
//

module coco3fpga_dw(
// Input Clocks
CLK50MHZ,
CLK27MHZ,

// SDRAM - SRH
// Commented out until later - maybe
//SDRAM_ADDRESS,
//SDRAM_BANK,
//SDRAM_DATA,
//SDRAM_LDQM,
//SDRAM_UDQM,
//SDRAM_DQM,
//SDRAM_RAS_N,
//SDRAM_CAS_N,
//SDRAM_CKE,
//SDRAM_CLK,
//SDRAM_CS_N,
//SDRAM_RW_N,

RED7,
GREEN7,
BLUE7,
RED6,
GREEN6,
BLUE6,
RED5,
GREEN5,
BLUE5,
RED4,
GREEN4,
BLUE4,
RED3,
GREEN3,
BLUE3,
RED2,
GREEN2,
BLUE2,
RED1,
GREEN1,
BLUE1,
RED0,
GREEN0,
BLUE0,
H_SYNC,
V_SYNC,
VGA_SYNC_N,
VGA_BLANK_N,
VGA_CLK,

// PS/2
ps2_clk,
ps2_data,

// RS-232
DE1TXD,
DE1RXD,
OPTTXD,
OPTRXD,

// I2C - Audio
I2C_SCL,
I2C_DAT,

//Codec - Audio
AUD_XCK,
AUD_BCLK,
AUD_DACDAT,
AUD_DACLRCK,
AUD_ADCDAT,
AUD_ADCLRCK,

// CoCo Joystick
// Needs removal.... ???
PADDLE_MCLK,
PADDLE_CLK,
P_SWITCH,

// Debug Test Points
//TEST_1,
//TEST_2,
//TEST_3,
//TEST_4,

// Buttons and Switches

//	SRH	MISTer
//	Removel of switches and buttons

HBLANK,
VBLANK,

// Needs removal....
GPIO
);

//Analog Board
parameter BOARD_TYPE = 8'h00;

`include "..\CoCo3FPGA_Common\coco3fpga_top.v"
