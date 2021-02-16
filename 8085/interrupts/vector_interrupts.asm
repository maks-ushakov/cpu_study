#{
	mem{
	// Fill data to memory
		reset;
		
		// interrupts
		// RST 0
		0000=c3;
		0001=04;
		0002=20;
		
		// RST 1
		0008=c3;
		0009=08;
		000a=20;
		
		// RST 2
		0010=c3;
		0011=0c;
		0012=20;
		
		// RST 3
		0018=c3;
		0019=10;
		001a=20;
		
		// RST 4
		0020=c3;
		0021=14;
		0022=20;
		
		// trap
		0024=c3;
		0025=30;
		0026=20;
		
		// RST 5
		0028=c3;
		0029=18;
		002a=20;
		
		// RST 5.5
		002c=c3;
		002d=24;
		002e=20;
		
		// RST 6
		0030=c3;
		0031=1c;
		0032=20;
		
		// RST 6.5
		0034=c3;
		0035=28;
		0036=20;
		
		// RST 7
		0038=c3;
		0039=20;
		003a=20;
		
		// RST 7.5
		003c=c3;
		003d=2c;
		003e=20;
	}
}

	JMP start
	NOP
	JMP int0 // goto RST0 handler
	NOP
	JMP int1 //goto RST1 handler
	NOP
	JMP int2 // goto RST2 handler
	NOP
	JMP int3 //3
	NOP
	JMP int4 //4
	NOP
	JMP int5
	NOP
	JMP int6
	NOP
	JMP int7
	NOP
	JMP int55
	NOP
	JMP int65
	NOP
	JMP int75
	NOP
	JMP int
	NOP
		
start: MVI A, 08H // Set masked interruption
	SIM
	EI // Enable interruption

	LXI BC 00ffH // load loop counter
loop: XRA A // clean Acc
	IN 80H // read keyboard port to Acc
	STA 8010H // show on display

	MOV E, A // save Acc to E
	XRA A // empty Acc
	OUT 80H // empty keyboard port

	MOV A, E // restore Acc

// switch by Acc value
	CPI 08H  // case 0x08, key 8 on kbd
	JNZ rst1chck
	RST0 // burn softwear interrupt RST0
	JMP default // break
	
rst1chck: MOV A, E 
	CPI 01H // case = key 1
	JNZ rst2chck
	RST1 // burn softwear interrupt RST1
	JMP default

rst2chck: MOV A, E
	CPI 02H // case= key 2
	JNZ rst3chck
	RST2 // burn softwear interrupt RST2
	JMP default

rst3chck: MOV A, E
	CPI 03H // case = key 3
	JNZ rst4chck
	RST3 // burn softwear interrupt RST3
	JMP default
	
rst4chck: MOV A, E
	CPI 04H // case = key 4
	JNZ rst5chck
	RST4 // burn softwear interrupt RST4
	JMP default
	
rst5chck: MOV A, E
	CPI 05H
	JNZ rst6chck
	RST5  // burn softwear interrupt RST5
	JMP default
	
rst6chck: MOV A, E 
	CPI 06H
	JNZ clrchck
	RST6 // burn softwear interrupt RST6
	JMP default
	
clrchck: MOV A, E
	CPI 0CH // case key C, clean display
	JNZ stopchck
	XRA A // clean Acc
	STA 800BH // clean used display memory
	STA 8010H
	JMP default
	
stopchck: MOV A, E
	CPI 0FH // case = key F, stop loop
	JNZ rst7chck
	HLT // full stop
	
rst7chck: MOV A, E
	CPI 07H // case = key 7
	JNZ default
	RST7 // burn softwear interrupt RST7
	
default: MOV A, B // Show counter data on display
	STA 8004H
	MOV A, C
	sta 8005H
	
	DCX BC // counter --
	MOV A, C // check 16 bit counter is 0
	ORA B
	JNZ loop // continue if not 0
	HLT
	
	// other interrupt handler
int: HLT
	
	// RST0 hndler
int0: DI
	MVI A, A0H
	STA 800BH
	EI
	RET
	
	// RST1 handler
int1: DI
	MVI A, A1H
	STA 800BH
	EI
	RET
	
	// RST2 handler
int2: DI
	MVI A, A2H
	STA 800BH
	EI
	RET
	
	// RST3 handler
int3: DI
	MVI A, A3H
	STA 800BH
	EI
	RET
	
	// RST 4 handler
int4: DI
	MVI A, A4H
	STA 800BH
	EI
	RET
	
	// RST 5 handler
int5: DI
	MVI A, A5H
	STA 800BH
	EI
	RET
	
	// RST 6 handler
int6: DI
	MVI A, A6H
	STA 800BH
	EI
	RET
	
	// RST 7 handler
int7: DI
	MVI A, A7H
	STA 800BH
	EI
	RET
	
	// Hardware masked interrupts
   // RST 7.5 handler
int75: DI
	MVI A, 75h
	STA 800BH
	EI
	HLT
	
	// RST 6.5 handler
int65: DI
	MVI A, 65H
	STA 800BH
	EI
	HLT
	
	// RST 5.5 handler
int55: DI
	MVI A, 55H
	STA 800BH
	EI
	HLT
		