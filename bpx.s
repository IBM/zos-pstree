#include "go_asm.h"
#include "textflag.h"

TEXT ·Bpxcall(SB), NOSPLIT|NOFRAME, $0
	MOVD  plist_base+0(FP), R1  // r1 points to plist
	MOVD  bpx_offset+24(FP), R2 // r2 offset to BPX vector table
	MOVD  R14, R7               // save r14
	MOVD  R15, R8               // save r15
	MOVWZ 16(R0), R9
	MOVWZ 544(R9), R9
	MOVWZ 24(R9), R9            // call vector in r9
	ADD   R2, R9                // add offset to vector table
	MOVWZ (R9), R9              // r9 points to entry point
	BYTE  $0x0D                 // BL R14,R9 --> basr r14,r9
	BYTE  $0xE9                 // clobbers 0,1,14,15
	MOVD  R8, R15               // restore 15
	JMP   R7                    // return via saved return address
