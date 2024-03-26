.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
load_palettes:
  LDA palettes,X
  STA PPUDATA
  INX
  CPX #$20
  BNE load_palettes

  ; write sprite data
  LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$c0   ; number of sprites that will be displayed
  BNE load_sprites

	; write nametables
	; big stars first
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$6b
	STA PPUADDR
	LDX #$2f
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$57
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$23
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$52
	STA PPUADDR
	STX PPUDATA

	; next, small star 1
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$74
	STA PPUADDR
	LDX #$2d
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$43
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$5d
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$73
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$2f
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$f7
	STA PPUADDR
	STX PPUDATA

	; finally, small star 2
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$f1
	STA PPUADDR
	LDX #$2e
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$21
	STA PPUADDR
	LDA #$a8
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$22
	STA PPUADDR
	LDA #$7a
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$44
	STA PPUADDR
	STX PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$7c
	STA PPUADDR
	STX PPUDATA

	; finally, attribute table
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$c2
	STA PPUADDR
	LDA #%01000000
	STA PPUDATA

	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$e0
	STA PPUADDR
	LDA #%00001100
	STA PPUDATA

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
;background pallete
.byte $0f, $12, $23, $27
.byte $0f, $2b, $3c, $39 
.byte $0f, $0c, $07, $13
.byte $0f, $19, $09, $29

;sprite pallete
.byte $0f, $0f, $02, $38 ; 00 attr
.byte $0f, $19, $09, $29 
.byte $0f, $19, $09, $29
.byte $0f, $19, $09, $29

sprites:
;      y   tile attr  x		; static front
.byte $70, $01, $00, $78  ;right side of face
.byte $70, $00, $00, $70  ;left side of face
.byte $78, $10, $00, $70  ;left side of body
.byte $78, $11, $00, $78  ;right side of face
; attr $03 = %0000 0011

.byte $70, $02, $00, $80
.byte $70, $03, $00, $88   ; moving front (left hand)
.byte $78, $12, $00, $80
.byte $78, $13, $00, $88

.byte $70, $04, $00, $90
.byte $70, $05, $00, $98   ; moving front (right hand)
.byte $78, $14, $00, $90
.byte $78, $15, $00, $98

.byte $80, $06, $00, $70   ; back static
.byte $80, $07, $00, $78   
.byte $88, $16, $00, $70
.byte $88, $17, $00, $78

.byte $80, $08, $00, $80   ; moving back (left hand)
.byte $80, $09, $00, $88   
.byte $88, $18, $00, $80
.byte $88, $19, $00, $88

.byte $80, $0a, $00, $90   ; moving back (right hand)
.byte $80, $0b, $00, $98   
.byte $88, $1a, $00, $90
.byte $88, $1b, $00, $98

.byte $90, $0c, $00, $70   ; right static
.byte $90, $0d, $00, $78   
.byte $98, $1c, $00, $70
.byte $98, $1d, $00, $78

.byte $90, $0e, $00, $80   ; moving right (left hand)
.byte $90, $0f, $00, $88   
.byte $98, $1e, $00, $80
.byte $98, $1f, $00, $88

.byte $90, $20, $00, $90   ; moving right (right hand)
.byte $90, $21, $00, $98   
.byte $98, $30, $00, $90
.byte $98, $31, $00, $98

.byte $a0, $22, $00, $70   ; left static
.byte $a0, $23, $00, $78   
.byte $a8, $32, $00, $70
.byte $a8, $33, $00, $78

.byte $a0, $24, $00, $80   ; moving left (left hand)
.byte $a0, $25, $00, $88   
.byte $a8, $34, $00, $80
.byte $a8, $35, $00, $88

.byte $a0, $26, $00, $90   ; moving left (right hand)
.byte $a0, $27, $00, $98   
.byte $a8, $36, $00, $90
.byte $a8, $37, $00, $98

.segment "CHR"
.incbin "graphics.chr"
