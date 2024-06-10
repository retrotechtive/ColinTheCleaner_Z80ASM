; Colin The Cleaner - ASM version (SAVE "M/C"CODE 45056,20480)
;
; REQUIRES: the machine code to be loaded from the original game, then this .asm file should be assembled and loaded, then the SAVE above used to combine them.
; The original m/c provides some helper functions, level layout data and the character set - all used by this code.
;
; NONE of the original BASIC is required, just a simple program to do the following:
;
;	CLEAR 45055: LOAD "" CODE: RANDOMIZE USER 45056
;
; This version written by @retrotechtive (aka Mark Hogben) 2024
;
; Original BASIC version from which this was derived written by:
; DARREN FARMER and ANDREW DUNNE, for the game Ralph On Alpha 2.
; Modifications for Colin The Cleaner's BASIC release by Harry S Price (sold non-legitimately!)
;

	org 0xB000 ; 45056
start:
	; save the current character set ptr
	ld hl,(23606)
	ld (orig_char_set),hl

	; use Colin's char set
	ld a,88
	ld (23606),a
	ld a,251
	ld (23607),a

	; create 0.008 value
	ld a,8
	ld bc,1000
	ld hl,point_zero_zero_eight
	call do_divide

	; create 0.005 value
	ld a,5
	ld bc,1000
	ld hl,point_zero_zero_five
	call do_divide

	; create 0.003 value
	ld a,3
	ld bc,1000
	ld hl,point_zero_zero_three
	call do_divide

	; create 0.002 value
	ld a,2
	ld bc,1000
	ld hl,point_zero_zero_two
	call do_divide

	; create 0.02 value
	ld a,2
	ld bc,100
	ld hl,point_zero_two
	call do_divide

	; create 0.01 value
	ld a,1
	ld bc,100
	ld hl,point_zero_one
	call do_divide

	; create 0.5 value
	ld a,5
	ld bc,10
	ld hl,point_five
	call do_divide
	
	; create 0.2 value
	ld a,2
	ld bc,10
	ld hl,point_two
	call do_divide
	
	; create 0.1 value
	ld a,1
	ld bc,10
	ld hl,point_one
	call do_divide

reset_game:
	xor a
	call 0x229b ; set border to black (and INK to 7)

	ld a,0x47 ; 0%01000111 ; BRIGHT 1: PAPER 0: INK 7
	ld (23693),a

	call 0x0d6b ; CLS

	call intro_beep
	
	call 65380 ; draw IJK SOFTWARE logo
	call 54970 ; make main buzz-beep sound
	
	ld a,0xF2 ; 0%11110010 ; FLASH 1, PAPER 6, INK 2
	ld (23693),a

	ld a,2
	call 0x1601 ; OPEN CHANNEL 2 (screen)

	ld a,8
teleport_title_screen_vertical_loop:
	push af
	
	; draw left vertical line of teleporters
	
	ld a,0x16 ; AT
	rst 0x10

	pop af
	push af
	rst 0x10

	ld a,4
	rst 0x10

	ld a,'%'
	rst 0x10

	; draw right vertical line of teleporters

	ld a,0x16 ; AT
	rst 0x10

	pop af
	push af
	rst 0x10

	ld a,26
	rst 0x10

	ld a,'%'
	rst 0x10

	pop af
	inc a
	cp 16
	jr nz,teleport_title_screen_vertical_loop
	
	ld a,3
teleport_title_screen_horizontal_loop:
	push af
	
	ld a,0x16 ; AT
	rst 0x10

	ld a,8
	rst 0x10

	pop af
	push af
	sla a
	dec a
	dec a
	rst 0x10

	ld a,'%'
	rst 0x10
	
	;
	
	ld a,0x16 ; AT
	rst 0x10

	ld a,15
	rst 0x10

	pop af
	push af
	sla a
	dec a
	dec a
	rst 0x10

	ld a,'%'
	rst 0x10
	
	pop af
	inc a
	cp 14
	jr nz,teleport_title_screen_horizontal_loop
	
	; print Colin The Cleaner title
	ld a,0x45 ;0%01000101 ; BRIGHT 1, PAPER 0, INK 5
	ld (23693),a

	ld a,2
	call 0x1601 ; OPEN CHANNEL 2 (screen)
	
	ld hl,colin_title_msg
colin_title_loop:
	ld a,(hl)
	and a
	jp z,after_colin_title
	
	push hl
	rst 0x10
	pop hl

	inc hl
	jr colin_title_loop

colin_title_msg:
	db 0x16,10,7 ; AT 10,7
	db 'COLIN THE CLEANER'
	db 0x16,12,7 ; AT 12,7
	db 'STARRING  ]'
	db 0x16,13,7 ; AT 13,7
	db 'COLIN     ]'
	db 0x10,7 ; INK 7
	db 0x16,12,22 ; AT 12,22
	db 'i'
	db 0x16,13,22 ; AT 13,22
	db 'w'
	db 0x16,21,1 ; AT 21,0 (but 1 because of backspace below)
	db 0 ; string terminator

title_screen_scrolltext:
	db 'HELLO THERE! THIS IS',0
	db 'COLIN THE CLEANER',0
	db ' ',0
	db ' ',0
	db 'AUTHORS :',0
	db 'DARREN FARMER',0
	db 'ANDREW DUNNE',0
	db ' ',0
	db 'GRAPHICS RESKIN / RIPOFF :',0
	db 'HARRY S PRICE',0
	db ' ',0
	db 'MUSIC :',0
	db 'THE COLOURBLIND HEDGEHOGS',0
	db ' ',0
	db 'ASSEMBLY REWRITE AND BUGFIX :',0
	db 'RETROTECHTIVE IN 2024',0
	db ' ',0
	db ' ',0
	db "TO START THE GAME :",0
	db "PRESS THE 'S' KEY.",0
	db ' ',0
	db ' ',0
	db "MOVEMENT KEYS CAN BE DEFINED.",0
	db " ",0
	db "KEYS CURRENTLY SET AS :-",0
	db "'k",0,"' .... MOVE LEFT.",0
	db "'k",1,"' .... MOVE RIGHT.",0
	db "'k",2,"' .... ACTION KEY.",0
	db "'k",3,"' .... HOLD KEY.",0
	db "'k",4,"' .... ABORT KEY.",0
	db ' ',0
	db "TO RE-DEFINE MOVEMENT KEYS :",0
	db "PRESS THE 'D' KEY.",0
	db "PRESS THE 'J' KEY",0
	db "TO USE INTERFACE2 JOYSTICK",0
	db "KEMPSTON USERS",0
	db "JUST PRESS THE 'S' KEY",0
	db ' ',0
	db "YOUR TASK IN LIFE IS :",0
	db "TO GUIDE COLIN AROUND EACH",0
	db "LEVEL OF THE MUSEUM,",0
	db "COLLECTING ALL THE LITTER",0
	db "SCATTERED AROUND BY THE",0
	db "CHILDREN FROM THE SCHOOLTRIP",0
	db "THIS WILL RESULT IN A FLASHING",0
	db "EXIT SIGN WHICH YOU MUST TOUCH",0
	db "THIS WILL THEN ALLOW YOU TO",0
	db "PASS ONTO THE NEXT ROOM.",0
	db ' ',0
	db ' ',0
	db "BEWARE OF THE FOLLOWING :",0
	db "1...FALLING ONTO OBJECTS.",0
	db "2...DROPPING DOWN A STEP",0
	db "3...FALLING ONTO LIFTS",0
	db "4...BECOMING STRANDED.",0
	db "REMEMBER TO USE THE",0
	db "LADDERS TO COME DOWN",0
	db "DO NOT GO DOWN A STEP",0
	db "USE THE WHITE LIFTS",0
	db "TO MOVE TO A DIFFERENT",0
	db "LEVEL ON THE SAME SCREEN",0
	db ' ',0
	db ' ',0
	db "WARNING :",0
	db "ANYONE CAUGHT COPYING THIS",0
	db "GAME WILL BE HUMILIATED",0
	db "FORTY YEARS LATER BY RETRO",0
	db "FANS ON THE INTERNET.",0
	db ' ',0
	db ' ',0
	db ' ',0
	db ' ',0
	db "NOW ENTERING DEMO MODE ....",0
	db ' ',0
	db 0 ; terminator, double zero

keys_defined:
left_key:
	db 'Z' ; left
right_key:
	db 'X' ; right
action_key:
	db 'M' ; action
hold_key:
	db 'H' ; hold
abort_key:
	db 'A' ; abort

after_colin_title:
	; set up scrolly whatnot
	xor a
	ld (23613),a ; turn off errors
	ld (23692),a ; turn off Scroll? message
	ld a,2
	ld (23659),a ; two lines for bottom of screen
	
	ld hl,title_screen_scrolltext
title_screen_scrolltext_loop:
	ld a,8 ; backspace (remove the hand thing)
	rst 0x10
	ld a,(hl)
	inc hl
	ld (char_comparison_value),a ; save for check later

	and a
	jr nz,title_screen_scrolltext_print_char
	ld a,32 ; space to erase hand thing
	rst 0x10
	
	ld a,07
	ld (0xff94),a 	; number of character lines to scroll (normally 8)
					; this prevents crap scrolling in from the bottom of the screen
	
	ld a,8
scroll_title_lines:
	push af
	push hl
	call 65420 ; scroll pixel line
	pop hl
	pop af
	dec a
	jr nz,scroll_title_lines
	
	ld a,0x16
	rst 0x10
	ld a,21
	rst 0x10
	xor a
	rst 0x10
	
	ld a,(hl)
	and a ; is it a double zero?
	jr z,title_screen_scrolltext_done
	inc hl
title_screen_scrolltext_print_char:
	cp 'k' ; little k means key defined, next character is the index
	jr nz, not_a_key_definition
	ld a,(hl) ; index of key to show
	inc hl
	
	; replace placeholder "'k',index" with actual defined key
	ex de,hl
	ld hl,keys_defined
	add l
	ld l,a
	ld a,0 ; take into account carry
	adc a,h
	ld h,a
	ld a,(hl)
	ex de,hl
	
not_a_key_definition:
	rst 0x10 ; draw the character
	
	ld a,0x10 ; INK
	rst 0x10
	ld a,5 ; CYAN
	rst 0x10
	
	ld a,'*' ; should be hand thing
	rst 0x10

	ld a,0x10 ; INK
	rst 0x10
	ld a,7 ; WHITE
	rst 0x10

	; Check key presses
	push hl
	call 0x028e ; KEY_SCAN
	pop hl
	ld a,e
	
	; Debug keys
	;cp 0x25 ; Q key
	;jp z,exit_game
	;cp 0x0d ; R key
	;jp z,reset_game
	
	; DEBUG
	;jp z,debug_completed_TEST
	
	; check keys for starting game etc.
	cp 0x1e ; S key
	jp z,start_game_loop
	
	cp 0x16 ; D key
	jp z,redefine_keys
	
	cp 0x09 ; J key
	jp z,redefine_keys_as_interface2
	
	; type writer beep thing noises
	db 0x3e ; ld a
char_comparison_value:
	db 32 ; operand (character value)
	cp ' ' ; space?
	jr z,title_screen_scrolltext_loop
	
	push hl
	call typey_beeps
	pop hl
	
	jr title_screen_scrolltext_loop

title_screen_scrolltext_done:
	; TODO: maybe do the crappy pre-demo music?
	
	ld a,1 ; delay high scores rather than wait for a key
	ld (high_score_delay_instead_of_key),a
	call draw_high_scores
	xor a
	ld (high_score_delay_instead_of_key),a

	call demo_mode

	jp reset_game

demo_mode:
	ld a,1
	ld (level),a
	
demo_mode_loop:
	ld a,0x47 ; 0%01000111 ; BRIGHT 1: PAPER 0: INK 7
	ld (23693),a
	call 0x0d6b ; CLS

	; DEMO MODE msg
	ld a,1
	call 0x1601 ; OPEN CHANNEL #1 - bottom screen area

	ld hl,demo_mode_msg
	call draw_message
	
	ld hl,demo_mode_banner_msg
	call draw_message	

	ld a,0x12
	rst 0x10
	xor a
	rst 0x10
	
	ld hl,demo_mode_level_info_msg
	call draw_message	

	ld a,(level)
	call 0x2d28 ; STACK_A
	call 0x2de3 ; PRINT TOP CALC NUMBER

	call draw_level
	
	call get_anykey
	ret c
	
	ld a,(level)
	inc a
	cp 16
	ld (level),a
	jr nz,demo_mode_loop
	
	ret

demo_mode_msg:
	db 0,0,"PRESS A KEY WHEN THE BEEP SOUNDS",0
demo_mode_banner_msg:
	db 1,3,0x12,1,"DEMO MODE",0
demo_mode_level_info_msg:
	db 1,16,"LEVEL NO : ",0

redefine_key_beeps:
	push hl
	push de
	push bc
	ld hl,point_zero_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	ld a,10
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep
	pop bc
	pop de
	pop hl
	ret

redefine_keys_as_interface2:
	ld hl,keys_defined
	ld a,'6'	; LEFT
	ld (hl),a
	inc hl
	ld a,'7'	; RIGHT
	ld (hl),a
	inc hl
	ld a,'0'	; ACTION
	ld (hl),a
	inc hl
	ld a,'H'	; HOLD
	ld (hl),a
	inc hl
	ld a,'A'	; ABORT
	ld (hl),a
	jp reset_game

redefine_keys:
	call 0x0d6b ; CLS
	call 65380 ; logo
	ld a,2
	call 0x1601 ; OPEN CHANNEL 2 (screen)
	
	xor a
key_redefine_beeps:
	push af

	call redefine_key_beeps
	
	; print redefining keys message
	ld a,0x10 ; INK
	rst 0x10
	pop af
	push af
	sra a ; divide by 2
	rst 0x10
	
	ld hl,key_selection_title_msg
	call draw_message
	
	ld hl,key_selection_msg
	call draw_message
	
	pop af
	inc a
	cp 14
	jr nz,key_redefine_beeps
	
	ld de,keys_defined
	ld hl,key_selection_messages
	xor a ; keyindex for outer loop
key_selection_loop:
	push af

	inc a
	inc a ; keyindex + 2 for colour loop
	inc a ; plus 1, since BASIC index starts at 1, not zero
	sla a ; double so we don't need fractions
	ld c,a ; colour loop count

	pop af
	push af

	sla a
	ld b,a ; keyindex * 2 for PRINT AT
	
	xor a ; colour loop starts at zero
	
	push de
key_text_colour_loop:
	push hl
	push af
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,12
	add b
	rst 0x10
	ld a,3
	rst 0x10
	
	ld a,0x10 ; INK
	rst 0x10
	pop af ; retrieve colour loop current value
	push af
	sra a ; halve for colour effect
	rst 0x10
	
	call redefine_key_beeps
	
	call draw_message_loop
	
	pop af ; restore colour loop counter
	pop hl ; reset msg ptr during colour loop
	
	inc a
	cp c
	jr nz,key_text_colour_loop

	ld a,0x16 ; AT
	rst 0x10
	ld a,12
	add b
	rst 0x10
	ld a,3
	rst 0x10
redefine_keys_TEST:
	call draw_message_loop
	inc hl
	
	; Wait for key press
	push hl
	push bc
redefine_keys_wait:
	call 0x028e ; KEY SCAN
	
	jr nz,redefine_keys_wait ; no valid key press

	; convert key to useful info
	call 0x031e ; KEY TEST
	jr nc,redefine_keys_wait ; no valid key press
	
	ld e,a
	ld c,0
	ld d,8
	call 0x0333 ; KEY CODE
	
	xor 0x20 ; make capital
	ld b,a
	rst 0x10 ; print it
	ld a,b
	
	pop bc
	pop hl
	
	pop de ; retrieve key definition pointer
	; store new key
	ld (de),a
	inc de ; next key
	
	pop af
	inc a
	cp 5
	jr nz, key_selection_loop
	
	scf
	ccf
	
	ld de,4
outer_key_check_loop:
	ld hl,keys_defined
	adc hl,de
	ld a,(hl) ; key to compare to
	ld b,a ; save it
	push de
key_check_loop:
	dec hl
	ld a,(hl)
	cp b ; same key?
	jr z,keys_conflict
	dec de
	ld a,d
	or e
	jr nz,key_check_loop
	pop de
	dec de
	ld a,d
	or e
	jr nz,outer_key_check_loop
	
	; keys defined okay if it reaches here
	ld a,1
	call 0x1601 ; OPEN CHANNEL 1 (lower screen)
	
	ld hl,keys_fine_msg
	call draw_message

	call wait_for_anykey
	
	jp reset_game

keys_conflict:
	pop de ; throw this away

	ld a,1
	call 0x2d28 ; STACK_A
	ld a,12
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	ld a,1
	call 0x1601 ; OPEN CHANNEL 1 (lower screen)
	ld hl,key_conflict_msg
	call draw_message
	
	ld a,2
	call 0x2d28 ; STACK_A
	ld a,0
	call 0x2d28 ; STACK_A
	ld a,12
	call 0x2d28 ; STACK_A
	rst 0x28
	db 0x03 ; subtract (0 - 12)
	db 0x38

	call 0x03f8 ; beep
	
	jp redefine_keys

; where's the anykey?
wait_for_anykey:
	call 0x028e ; KEY SCAN
	call 0x031e ; KEY TEST
	
	jr c,keys_good_wait_no_press ; wait until no key is pressed

	xor a
	ld (repeating_key_held),a
	ld (current_key_repeat_delay),a

keys_good_wait_press:
	call 0x028e ; KEY SCAN
	jr nz,keys_good_wait_press ; no valid key press
	call 0x031e ; KEY TEST
	jr nc,keys_good_wait_press ; no valid key press
	
	ld (last_key_pressed),a
	ret

keys_good_wait_no_press:
	ld (current_key_pressed),a
	
	ld a,(repeating_key_held)
	and a
	jr z,more_key_waiting
	
	ld b,80
silly_delay:
	djnz silly_delay
	
	ld a,(current_key_pressed)
	ret
	
more_key_waiting:	
	ld a,(do_key_repeat)
	and a
	jr z,wait_for_anykey
	
	ld a,(current_key_pressed)
	ld b,a
	ld a,(last_key_pressed)
	cp b
	jr z,same_key_pressed
	ld a,(current_key_pressed)
	ld (last_key_pressed),a
	xor a
	ld (current_key_repeat_delay),a
	jr wait_for_anykey

same_key_pressed:
	ld a,(current_key_repeat_delay)
	inc a
	ld (current_key_repeat_delay),a
	cp 255
	jr nz,wait_a_bit_longer
	ld a,1
	ld (repeating_key_held),a
	xor a
	ld (current_key_repeat_delay),a
	ld a,(current_key_pressed)
	ret

wait_a_bit_longer:
	ld b,255
wabl_loop1:
	djnz wabl_loop1
	jr wait_for_anykey

last_key_pressed:
	db 0
current_key_pressed:
	db 0
do_key_repeat:
	db 0
current_key_repeat_delay:
	db 0
repeating_key_held:
	db 0

; OUT:	Carry - set if a key was pressed
get_anykey:
	call 0x028e ; KEY SCAN
	ret nz
	call 0x031e ; KEY TEST
	ret	

key_selection_msg:
	db 10,6,"KEY SELECTION PHASE"
	db 0
key_selection_title_msg:
	db 8,1,"C O L I N T H E C L E A N E R"
	db 0
keys_fine_msg:
	db 0,4,0x12,1,"ALL THE KEYS ARE FINE !"
	db 0
key_conflict_msg:
	db 1,4,0x11,2,0x12,1,"SORRY, CAN'T DO THAT !!"
	db 0
key_selection_messages:
	db "KEY TO MOVE LEFT ?  ",0
	db "KEY TO MOVE RIGHT ? ",0
	db "THE ACTION KEY ?    ",0
	db "THE HOLD KEY ?      ",0
	db "THE ABORT KEY ?     ",0

; ENTRY: HL - ptr to text, zero terminated. Starts with AT coords (Y,X)
draw_message:
	ld a,0x16 ; AT
	rst 0x10
	ld a,(hl) ; Y
	rst 0x10
	inc hl
	ld a,(hl) ; X
	rst 0x10
	inc hl
draw_message_loop:
	ld a,(hl)
	and a
	jr z, draw_message_done
	inc hl
	push hl
	rst 0x10
	pop hl
	jr draw_message_loop
draw_message_done:	
	ret

level:
	db 1 ; current level
oc:
	db 0 ; current number of collected items
ob:
	db 0 ; current level's total number of objects
lives:
	db 0 ; current number of lives
time:
	dw 0 ; current time remaining (2 bytes)
time_minor:
	db 0 ; sub count used to slow down time decay
r1:	db 0
l1:	db 0
x:	db 1	; current player x coord (reversed from BASIC's X variable)
y:	db 18	; current player y coord (reversed from BASIC's Y variable)
score:
	dw 0	; current player score (2 bytes)
flag_end_level:
	db 0

start_game_loop:
	; reset all the variables
	ld a,1 ; starting level
	ld (level),a
	ld a,3 ; starting number of lives
	ld (lives),a
	ld bc,5000 ; starting time remaining
	ld (time),bc
	ld bc,0
	ld (score),bc
start_new_level:
	ld a,1 ; starting player X coord
	ld (x),a
	ld a,18 ; starting player Y coord
	ld (y),a
	xor a
	ld (oc),a
	ld (flag_end_level),a
	ld (time_minor),a

game_loop_draw_level:
	ld a,0x47 ; 0%01000111 ; BRIGHT 1: PAPER 0: INK 7
	ld (23693),a

	call 0x0d6b ; CLS

	; draw TIME, SCORE, LIVES LEFT, LEVEL
	ld a,1
	call 0x1601 ; OPEN CHANNEL #1 - bottom screen area

	ld a,0x67 ; 0%01100111 ; BRIGHT 1: PAPER 4: INK 7
	ld (23693),a
	
	ld a,0x11 ; PAPER
	rst 0x10
	ld a,4
	rst 0x10

	ld hl,time_left_msg
	call draw_message
	ld hl,score_msg
	call draw_message
	ld hl,lives_left_msg
	call draw_message
	ld hl,level_msg
	call draw_message

	call draw_level

	ld a,'v'
	ld (player_feet_char),a
	ld a,'i'
	ld (player_head_char),a
	call draw_player

; TEST CODE - draw exit immediately
;	ld a,1
;	ld (ob),a
;	ld (oc),a

; **********************
; *** MAIN GAME LOOP ***
; **********************
game_loop:
	call draw_current_stats

	ld a,(flag_end_level)
	and a
	jr z,update_time
	
	call 54970
	xor a
	ld (flag_end_level),a
	ld a,(level)
	inc a
	cp 16
	jp z,completed_game
	ld (level),a
	jp start_new_level
	
update_time:
	ld a,(time_minor)
	inc a
	ld (time_minor),a
	cp 2 ; 1 might be better for hard core mode
	jr nz,time_decrement_skip
	xor a
	ld (time_minor),a

	ld bc,(time)
	ld a,b
	or c
	jp z,out_of_time_end_game
	dec bc
	ld (time),bc

time_decrement_skip:
	; check if all objects are collected, and if so, show exit.
	ld a,(oc)
	ld b,a
	ld a,(ob)
	cp b
	jr nz,not_collected_everything
	
	xor a
	ld (ob),a ; reset for next level
	call draw_exit
	
not_collected_everything:

	; Gameplay! (such as it is :D)
	
	; Check key presses
	call 0x028e ; KEY SCAN
	
	jr nz, key_checks_done ; no valid key press
	
	; debug
	;ld a,e
	;cp 0x25 ; Q key
	;jp z,exit_game
	;cp 0x0d ; R key
	;jp z,reset_game
	;jp z,completed_game
	
	; convert key to useful info
	call 0x031e ; KEY TEST
	jr nc,key_checks_done ; no valid key press
	
	ld e,a
	ld c,0
	ld d,8
	call 0x0333 ; KEY CODE
	
	xor 0x20 ; make capital
	
	ld b,a
	ld a,(abort_key)
	cp b
	jp z,abort_game
	
	ld a,(hold_key)
	cp b
	jr nz,check_left_key

	call hold_wait_key_release

hold_loop:
	ld a,(hold_border_colour)
	inc a
	and 7
	ld (hold_border_colour),a
	out (0xfe),a

	ld b,25
hold_delay:
	djnz hold_delay

	call 0x028e ; KEY SCAN
	ld a,e
	cp 0xFF
	jr z,hold_loop
	
	xor a
	ld (hold_border_colour),a
	out (0xfe),a

	call hold_wait_key_release
	
check_left_key:
	; check for movement keys or joystick
	ld a,(left_key)
	cp b
	jr nz,check_right_key

	call move_left
	jr key_checks_done
check_right_key:
	ld a,(right_key)
	cp b
	jr nz,check_action_key

	call move_right
	jr key_checks_done
check_action_key:
	ld a,(action_key)
	cp b
	jr nz,key_checks_done
	
	call do_action
	
key_checks_done:
	halt; to avoid conflict with the ULA
	in a,(31) ; KEMPSTON check
	bit 5,a
	jr nz,joystick_checks_done ; not valid for Kempston, probably not connected
	
check_joy_left:
	bit 1,a ; left
	jr z,check_joy_right
	
	call move_left
	jr joystick_checks_done
check_joy_right:
	bit 0,a ; right
	jr z,check_joy_action
	
	call move_right
	jr joystick_checks_done
check_joy_action:
	bit 4,a ; fire
	jr z,joystick_checks_done
	
	call do_action

joystick_checks_done:
	jp game_loop

hold_wait_key_release:
	call 0x028e ; KEY SCAN
	ld a,e
	cp 0xFF
	jr nz,hold_wait_key_release
	ret

squelch_noise:
	push bc
	push de
	push hl
	call 55030
	pop hl
	pop de
	pop bc
	ret

completed_game:
	; congrats message.
	ld a,0x07 ; 0%00000111 ; BRIGHT 0: PAPER 0: INK 7
	ld (23693),a
	call 0x0d6b ; CLS
	
	ld a,2
	call 0x1601 ; OPEN CHANNEL #2 - main screen
	
	ld a,2 ; outer loop count (M value from BASIC version)
completed_congrats_outer_loop:
	push af
	xor a ; N value from BASIC version
completed_congrats_inner_loop:
	push af

	; Calculate N/3
	call 0x2d28 ; STACK_A
	ld a,3
	call 0x2d28 ; STACK_A
	rst 0x28
	db 0x05 ; divide
	db 0x27
	db 0x38
	call 0x2dd5 ; FP_TO_A
	
	ld (52204),a ; POKE equivalent

	ld a,0x10 ; INK
	rst 0x10
	pop af
	push af
	ld b,a
	ld a,7
	sub b
	ld b,a ; save for later (below)
	rst 0x10

	ld hl,congrats_stars_msg1
	call draw_message

	ld a,0x10 ; INK
	rst 0x10
	pop af
	push af
	rst 0x10

	ld hl,congrats_msg
	call draw_message

	ld a,0x10 ; INK
	rst 0x10
	ld a,b ; restore from save
	rst 0x10

	ld hl,congrats_stars_msg2
	call draw_message
	
	call 52200 ; sound thing
	
	pop af
	inc a
	cp 7
	jr nz,completed_congrats_inner_loop
	
	pop af
	inc a
	cp 7
	jr nz,completed_congrats_outer_loop
	
	; beep loop
	xor a
completed_beep_loop:
	push af
	
	ld hl,point_zero_zero_three
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep
	
	ld hl,point_zero_zero_five
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	add 24
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,10
	rst 0x10
	pop af
	push af
	rst 0x10
	ld a,' '
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,12
	rst 0x10
	pop af
	push af
	ld b,a
	ld a,31
	sub b
	rst 0x10
	ld a,' '
	rst 0x10

	pop af
	inc a
	cp 32
	jr nz,completed_beep_loop
	
	call check_if_score_qualifies_for_table
	jp nc,high_score_entry_done

high_score_entry:
	call 55000

	ld hl,entered_score_name
	xor a
	ld b,20
wipe_typed_high_score_name:
	ld (hl),a
	inc hl
	djnz wipe_typed_high_score_name
	
	; check high score
	call 0x0d6b ; CLS

	ld a,2
	call 0x1601 ; OPEN CHANNEL #2 - main screen
	
	ld hl,list_of_success_msg
	call draw_message
	
	ld hl,high_score_instructions_msg
	call draw_message_loop ; skip the AT

	ld hl,high_score_letter_pointer
	call draw_message

	ld hl,high_score_name_area_msg
	call draw_message_loop

	ld a,0x10 ; INK
	rst 0x10
	ld a,7
	rst 0x10

	ld a,0x11 ; PAPER
	rst 0x10
	ld a,0
	rst 0x10

	xor a
	ld (entered_score_name_index),a
	
	ld hl,high_score_letter_choices
	ld b,0	; index from left hand side, into letter array
	ld c,15	; index for letter pointer,  into letter array
	
	ld a,1
	ld (do_key_repeat),a
	
letter_choice_update:
	push hl
	push bc
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,10
	rst 0x10
	ld a,0
	rst 0x10

	scf
	ccf

	ld d,0
	ld e,b
	adc hl,de ; offset into letters

	ld a,31 ; number of letters to draw counter
letter_choice_character_draw_loop:
	push af
	ld a,(hl)
	inc hl
	rst 0x10 ; print character from letter choice string
	
	inc b
	ld a,b
	cp 41
	jr nz,keep_drawing_letters

	ld b,0
	ld hl,high_score_letter_choices

keep_drawing_letters:
	pop af
	dec a
	jr nz,letter_choice_character_draw_loop

	; TODO: beep 0.005,9

	; check keys to move letters
	call wait_for_anykey

	pop bc
	pop hl ; restore current ptr into letters

	ld e,a ; save it for checking
	
	ld a,(right_key)
	cp e
	jr nz,letter_choice_check_left
	
	inc c
	ld a,c
	cp 41
	jr nz,letter_choice_update_b_right
	ld c,0
letter_choice_update_b_right:
	inc b
	ld a,b
	cp 41
	jr nz,letter_choice_update
	ld b,0
	jr letter_choice_update
	
letter_choice_check_left:
	ld a,(left_key)
	cp e
	jr nz,letter_choice_check_action
	
	ld a,c
	and a
	jr nz,letter_choice_update_c_left
	ld c,41
letter_choice_update_c_left:
	dec c

	ld a,b
	and a
	jr nz,letter_choice_update_b_left
	ld b,41
letter_choice_update_b_left:
	dec b
	
	jr letter_choice_update
	
letter_choice_check_action:
	ld a,(action_key)
	cp e
	jr nz,letter_choice_check_done

	call squelch_noise

	; get letter at c index
	scf
	ccf
	
	push hl
	ld d,0
	ld e,c
	adc hl,de
	ld a,(hl)
	
	; not sure I need these...?
	scf
	ccf
	
	ld hl,entered_score_name
	ld d,0
	push af
	ld a,(entered_score_name_index)
	ld e,a
	pop af
	adc hl,de
	ld (hl),a
	inc hl
	xor a
	ld (hl),a

	pop hl
	
	ld a,(entered_score_name_index)
	cp 18
	jr z,dont_increase_name_index
	inc a
	ld (entered_score_name_index),a
dont_increase_name_index:
	push hl
	ld hl,entered_score_name_msg_start
	call draw_message
	pop hl
	
	jp letter_choice_update

letter_choice_check_done:
	; Commit the name to wherever it fits in the high score table!
	; (if ENTER is pressed)
	ld a,e
	cp '0' ; backspace
	jr nz,high_score_check_for_enter
	
	ld a,(entered_score_name_index)
	and a
	jp z,letter_choice_update

	dec a
	ld (entered_score_name_index),a
	ld (letter_choice_ix_offset),a
	ld a,32 ; space
	ld ix,entered_score_name
	db 0xdd,0x77 ; LD (IX+n),a
letter_choice_ix_offset:
	db 0 ; n for LD (IX+n),a
	ld (ix+18),a ; always do the final character when backspacing
	
	call squelch_noise
	
	jp dont_increase_name_index
	
high_score_check_for_enter:
	cp 13 ; ENTER pressed?
	jp nz,letter_choice_update

	; commit score to table
	ld ix,high_score_table
	
	ld b,10
high_score_check_loop:
	ld l,(ix+21)
	ld h,(ix+22)
	ld de,(score)
	
	scf
	ccf
	
	sbc hl,de
	jr c,insert_high_score_entry
	
	ld de,23 ; size of each entry
	add ix,de ; get next entry
	djnz high_score_check_loop

high_score_entry_done:
	ld a,0
	ld (do_key_repeat),a
	
	jp reset_game

; Returns Carry Set if the score qualifies for the high score table
; (HL and DE corrupt on return)
check_if_score_qualifies_for_table:
	ld hl,(last_high_score_entry+21)
	ld de,(score)
	scf
	ccf
	sbc hl,de
	ret

insert_high_score_entry:
	; move entries down 1, lose the last
	ld hl,last_high_score_entry-1
	ld ix,last_high_score_entry-1
	
	dec b
	ld a,b
	and a
	jr z,copy_name_and_score
	
insert_high_score_entry_loop:
	push bc ; number of entries in b

	ld b,23
insert_high_score_entry_copy_loop:
	ld a,(hl)
	ld (ix+23),a
	dec ix
	dec hl
	djnz insert_high_score_entry_copy_loop
	
	pop bc
	djnz insert_high_score_entry_loop

copy_name_and_score:
	inc ix ; will be one less than entry start, so correct that

	; copy name into entry
	ld hl,entered_score_name
	ld b,20
copy_high_score_name:
	ld a,(hl)
	ld (ix+00),a
	inc ix
	inc hl
	djnz copy_high_score_name

	; copy in the score
	ld de,(score)
	ld (ix+01),e
	ld (ix+02),d

	call draw_high_scores

	jr high_score_entry_done

draw_high_scores:
	ld a,0x10 ; 0%00010000 ; BRIGHT 0: PAPER 2: INK 0
	ld (23693),a
	call 0x0d6b ; CLS
	
	ld a,2
	call 0x1601 ; OPEN CHANNEL #2 - main screen area
	
	call draw_lines_for_high_score
	
	ld hl,high_score_table_msg
	call draw_message
	
	; beeps and colour cycling, showing scores
	ld a,0x11 ; PAPER
	rst 0x10
	ld a,4
	rst 0x10
	
	ld hl,high_score_table
	ld a,1
high_score_print_loop:
	push af

	push hl
	ld hl,point_zero_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop hl
	pop af
	push af
	push hl
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep
	pop hl

	ld a,0x16 ;AT
	rst 0x10
	pop af
	push af
	sla a ; * 2
	inc a ; + 1
	rst 0x10
	ld a,3
	rst 0x10
	
	push hl
	call draw_message_loop
	pop hl
	
	scf
	ccf
	
	ld de,21 ; advance to score
	adc hl,de
	
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	
	ld a,0x16 ;AT
	rst 0x10
	pop af
	push af
	sla a ; * 2
	inc a ; + 1
	rst 0x10
	ld a,25
	rst 0x10

	push hl
	ld hl,999
	sbc hl,bc
	
	jr c,no_padding
	ld a,32
	rst 0x10

no_padding:
	call 0x2d2b ; STACK_BC
	call 0x2de3 ; PRINT TOP CALC NUMBER
	pop hl
	
	pop af
	inc a
	cp 11
	jr nz,high_score_print_loop
	
	ld a,(high_score_delay_instead_of_key)
	and a
	jr nz,high_score_delay
	
	ld a,1
	call 0x1601 ; OPEN CHANNEL #1 - bottom screen
	
	ld hl,press_a_key_msg
	call draw_message
	
	call wait_for_anykey
	ret
	
high_score_delay:
	ld b,200
high_score_delay_loop1:
	halt
	
	push bc
	call 0x028e ; KEY SCAN
	call 0x031e ; KEY TEST
	pop bc
	ret c ; return immediately if a key is pressed
	
	djnz high_score_delay_loop1
	ret

high_score_delay_instead_of_key:
	db 0

high_score_table_msg:
	db 1,8,0x13,1,"HIGH SCORE TABLE",0

press_a_key_msg:
	db 1,11,0x10,7,0x13,1,"PRESS A KEY",0

entered_score_name_msg_start:
	db 15,6
entered_score_name:
	ds 20
good_measure:
	db 0 ; for good measure
entered_score_name_index:
	db 0

congrats_stars_msg1:
	db 10,0,"*******************************",0
congrats_msg:
	db 11,0," C O N G R A T U L A T I O N S",0
congrats_stars_msg2:
	db 12,0,"*******************************",0

list_of_success_msg:
	db 0,0,0x10,6,0x13,1
	db " YOUR NAME CAN NOW BE SCRIBED   "
	db "  ONTO THE LIST OF HEROES",0
	
high_score_instructions_msg:
	db 0x10,0x03 ; ink
	db 0x06,0x06,0x06 ; comma control
	db "   PRESS <LEFT> AND <RIGHT>"
	db 0x06
	db " TO SELECT THE CORRECT LETTER"
	db 0x06
	db "      THEN PRESS <ACTION>"
	db 0
high_score_letter_pointer:
	db 9,15,0x10,7,"\\"
	db 0x16,11,15,"["
	db 0

high_score_name_area_msg:
	db 0x11,3 ; PAPER
	db 0x16,14,5
	db "                     "
	db 0x16,15,5
	db " "
	db 0x16,15,25
	db " "
	db 0x16,16,5
	db "                     "
	db 0

high_score_letter_choices:
	db "ABCDEFGHIJKLMNOPQRSTUVWXYZ !*,.0123456789" ; 41 characters

high_score_table:
	db "MATTHEW             ",0
	dw 6543
	db "JEFF                ",0
	dw 5432
	db "MICKY               ",0
	dw 4321
	db "MOUSE               ",0
	dw 3210
	db "WINSTON             ",0
	dw 3100
	db "CHURCHILL           ",0
	dw 2109
	db "GRUMPY              ",0
	dw 1500
	db "SLEEPY              ",0
	dw 1000
	db "SNEEZY              ",0
	dw 545
last_high_score_entry:
	db "ME                  ",0
	dw 400
	
abort_game:
	call abort_beep
	jp reset_game

exit_game:
	ld hl,(orig_char_set)
	ld (23606),hl ; restore the original char set ptr
	ret

move_left:
	ld a,(x)
	and a
	ret z ; early return if at left edge of screen
	
	ld c,a ; save for checks later
	
	xor a
	ld (r1),a ; not facing right
	ld a,(l1)
	inc a
	cp 5
	jr nz,move_left_update_l1
	ld a,1
move_left_update_l1:
	ld (l1),a
	; code mods for inc/dec and HL
	ld a,33
	ld (move_left_right_DE_value),a
	; inc/dec mods
	ld a,0x2b ; dec hl
	ld (move_left_right_HL_change_for_X),a
	ld a,0x3d ; dec a
	ld (move_left_right_horizontal_delta),a
	
	jr move_left_right

move_right:
	ld a,(x)
	cp 31
	ret z ; early return if at right edge of screen

	ld c,a ; save for checks later

	xor a
	ld (l1),a ; not facing left
	ld a,(r1)
	inc a
	cp 5
	jr nz,move_right_update_r1
	ld a,1
move_right_update_r1:
	ld (r1),a
	; code mods for inc/dec and HL
	ld a,31
	ld (move_left_right_DE_value),a
	; inc/dec mods
	ld a,0x23 ; inc hl
	ld (move_left_right_HL_change_for_X),a
	ld a,0x3c ; inc a
	ld (move_left_right_horizontal_delta),a

move_left_right:
	ld a,(y)
	ld b,a
	call get_attr_ptr
	
	; HL contains the address to the attribute
	push hl
	db 0x11 ; ld de,
move_left_right_DE_value:
	db 0
	db 0
	; take DE from HL to get attr to the left/right and above of X,Y, i.e. X-1, Y-1, or X+1, Y-1
	scf
	ccf
	sbc hl,de
	ld a,(hl)
	ld (move_left_right_attr),a ; save for check later
	pop hl
	cp 122 ; wall block at head height so no movement
	ret z
	cp 7 ; head height teleporter (for one particular level)
	ret z ; note, this will also prevent head height collection of white objects!
	
move_left_right_HL_change_for_X:
	db 0x2b; dec hl ; one attr before X,Y i.e. X-1,Y
	
	; check for exit (at head height)
	cp 207
	jr z,move_left_right_exit_hit
	
	ld a,(hl) ; annoying duplication of operand here grrr - but get foot height block
	
	; check for exit (at foot height)
	cp 207
	jp nz,move_left_right_not_exit
move_left_right_exit_hit:	
	ld a,1
	ld (flag_end_level),a ; picked up in main game loop
	ret
	
move_left_right_not_exit:
	; we will be moving left, so can erase the player here.
	call erase_player

	ld a,(hl)
	cp 122 ; block at foot level, so climb?
	jr z,move_left_right_and_up
	
	ld (move_left_right_attr),a ; save for check later
	jr move_left_right_horizontal

move_left_right_and_up:
	scf
	ccf
	ld de,2*32 ; two blocks above foot block
	sbc hl,de
	ld a,(hl)
	cp 122 ; block two blocks above foot block means head won't fit!
	jr nz,move_left_right_and_up_for_certain
	call draw_player
	ret
move_left_right_and_up_for_certain:
	ld a,(y)
	dec a
	ld (y),a
	ld (flag_moved_up),a
	
	; move only left/right if we jump to here
move_left_right_horizontal:
	ld a,(x)
move_left_right_horizontal_delta:
	dec a ; will be modified according to left/right direction
	ld (x),a
	
	; check for collectibles at new position before moving
	db 0x3e ; ld a,
move_left_right_attr:
	db 0    ; NN - placeholder for attribute to check (set above)
	
	call check_for_collectibles_range
	jr nc,move_left_right_draw_player
	
	; add to total objects collected
	ld a,(oc)
	inc a
	ld (oc),a

	ld (flag_object_collected),a

move_left_right_draw_player:
	call update_player_chars
	call draw_player

	; if object was collected, update score and do beep.
	ld a,(flag_object_collected)
	and a
	ld a,0
	ld (flag_object_collected),a
	jr z,move_left_right_skip_collection_beep ; the 'and a' triggers this
	ld hl,(score)
	ld de,10 ; score increase
	adc hl,de
	ld (score),hl
	call 55030 ; beep for object collection
	
move_left_right_skip_collection_beep:
	; check for no block under feet, and fall if so
	ld a,(x)
	ld c,a
	ld a,(y)
	inc a ; block under feet
	ld b,a
	call get_attr_ptr
	ld a,(hl)
	cp 71
	jp nz,move_left_right_finish_move
	
	; fall animation, death
move_left_right_fall_loop:
	call erase_player
	ld a,(x)
	ld c,a
	ld a,(y)
	inc a
	ld b,a
	push bc
	call get_attr_ptr
	pop bc
	ld a,(hl)
	cp 71
	jr nz,move_left_right_death
	ld a,b
	ld (y),a
	
	call draw_dropping_player
	
	ld a,(y)
	call falling_beep
	
	call get_rnd
	cp 200
	jr c,do_falling_border
	add 56 ; make it 0-200
do_falling_border:
	out (254),a
	
	jr move_left_right_fall_loop
move_left_right_death:
	call draw_dropping_player
	
	xor a
	out (254),a
	call 55060
	
	call death_beeps
	
	ld a,(23624)
	ld (border_save),a
	
	ld a,0x3C ; inc a
	ld (drl_count_op),a
	ld a,8
	ld (drl_cp),a
	xor a
	ld b,2

outer_death_rip_loop:
	push bc
death_rip_loop:
	push af
	sla a
	sla a
	sla a
	ld (23624),a ; BORDER (as part of lower screen colours)

	ld a,0x10 ; INK
	rst 0x10
	pop af
	push af
	rst 0x10 ; loop value for INK
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,'m'
	rst 0x10
	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,'n'
	rst 0x10
	
	pop af
	push af
	ld (52204),a
	call 52200
	pop af
drl_count_op:
	inc a
	db 0xFE ; cp NN
drl_cp:
	db 8
	jr nz,death_rip_loop
	
	ld a,0x3D ; dec a
	ld (drl_count_op),a
	ld a,0
	ld (drl_cp),a
	ld a,8
	
	pop bc
	djnz outer_death_rip_loop
	
	ld a,(border_save)
	ld (23624),a
	
	call erase_player
	
	call 54970
	ld a,(lives)
	dec a
	jr z,lost_all_lives
	ld (lives),a
	
	ld a,18
	ld (y),a
	ld a,1
	ld (x),a
	ld (r1),a
	xor a
	ld (l1),a

	call update_player_chars
	call draw_player
	ret

out_of_time_end_game:
	call 0x0d6b ; CLS
	ld a,2
	call 0x1601 ; OPEN CHANNEL 2 (screen)

	ld hl,out_of_time_msg
	call draw_message

	call end_game_beeps
	
	call check_if_score_qualifies_for_table
	jr nc,out_of_time_done
	
	; goto high score table function
	jp high_score_entry

out_of_time_done:	
	call wait_for_anykey
	
	jp reset_game

;debug_completed_TEST:
;	ld hl,2050
;	ld (score),hl
;	push hl ; instead of the RET stack value, debugging only!
lost_all_lives:
	call 0x0d6b ; CLS
	ld a,2
	call 0x1601 ; OPEN CHANNEL 2 (screen)

	call check_if_score_qualifies_for_table
	jr nc,lost_all_lives_done

	ld hl,lost_all_lives_msg
	call draw_message	
	
	call end_game_beeps

	; goto high score table function
	pop HL ; not gonna RET
	jp high_score_entry
	
lost_all_lives_done:
	ld hl,lost_all_lives_no_high_msg
	call draw_message	
	
	call end_game_beeps

	call wait_for_anykey
	
	pop HL ; not gonna RET
	jp reset_game

out_of_time_msg:
	db 0,0,"WHAT A WALLY...YOU HAVE LEFT       IT FAR TOO LATE. TRY AGAIN!!",0
	
lost_all_lives_no_high_msg:
	db 0,0,0x06,0x06," WHAT A DISASTER...YOU WEREN'T  "
	db " EVEN GOOD ENOUGH TO QUALIFY FOR         THE HIGH SCORE TABLE!       ",0

lost_all_lives_msg:
	db 0,0,0x06,0x06," WHAT A DISASTER...             "
	db " BETTER LUCK NEXT TIME!!",0

border_save:
	db 0

move_left_right_finish_move:
	ld a,(flag_moved_up)
	and a
	ld a,0
	ld (flag_moved_up),a
	jr z,do_normal_footsteps
	call climb_beep
	ret
do_normal_footsteps:
	call footstep_beep
	ret

draw_dropping_player:
	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,0x7f ; dropping down feet
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,'~' ; dropping down head
	rst 0x10
	ret

flag_object_collected:
	db 0
flag_moved_up:
	db 0

do_action:
	ld a,(x)
	ld c,a
	ld a,(y)
	inc a
	ld b,a
	call get_attr_ptr
	ld a,(hl)
	
	cp 7
	jr nz,do_action_check_for_ladder

	call 55000 ; make teleport activation noise

	ld b,8
teleport_away_loop:
	ld a,b
	dec a
	ld (teleport_away_sound_beep),a
	ld (player_colour),a
	call draw_player
	push bc
	ld hl,point_zero_zero_three
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	;ld a,NN
	db 0x3e
teleport_away_sound_beep:
	db 00
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	pop bc
	djnz teleport_away_loop
	call erase_player ; to make sure the attributes are correct

do_action_find_platform_loop:
	ld a,(x)
	ld c,a
	ld a,(y)
	dec a
	ld b,a
	ret z ; should never happen!
	ld (y),a
	call get_attr_ptr
	ld a,(hl)
	cp 122 ; brick floor?
	jr nz,do_action_find_platform_loop

	ld a,(y)
	dec a
	ld (y),a

	ld b,8
teleport_back_loop:
	ld a,8
	sub b
	ld (teleport_back_sound_beep),a
	ld (player_colour),a
	call draw_player
	push bc
	ld hl,point_zero_zero_three
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	;ld a,NN
	db 0x3e
teleport_back_sound_beep:
	db 00
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	pop bc
	djnz teleport_back_loop
	
	ret

do_action_check_for_ladder:
	cp 70
	ret nz

	ld a,(y)
	ld (temporary_y),a

	call 55000

do_action_drop_down_ladder_loop:
	call erase_player
	ld a,(x)
	ld c,a
	ld a,(temporary_y)
	inc a ; block under feet
	ld b,a
	cp 22
	ret z ; should never happen!
	push bc
	call get_attr_ptr
	pop bc
	ld a,(hl)

	cp 207
	jp nz,do_action_ladder_check_for_solid_block

	; exit!
	ld a,1
	ld (flag_end_level),a ; picked up in main game loop
	ret

do_action_ladder_check_for_solid_block:
	cp 122 ; found solid block? (TODO: wonder whether to handle teleport detection!)
	jp z,ladder_drop_done

	call check_for_collectibles_range
	jr nc,no_collectible_below_ladder

	; add to total objects collected
	ld a,(oc)
	inc a
	ld (oc),a

	ld (flag_object_collected),a

no_collectible_below_ladder:
	ld a,b
	ld (temporary_y),a

	; draw updates during ladder drop
	ld a,0x16 ; AT
	rst 0x10
	ld a,(temporary_y)
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,0x7f ; dropping down feet
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,(temporary_y)
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,'~' ; dropping down head
	rst 0x10

	ld a,0x10 ; INK 
	rst 0x10
	ld a,6 ; colour for ladder
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,(temporary_y)
	dec a
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,'&' ; ladder
	rst 0x10

	ld a,(flag_object_collected)
	and a
	ld a,0
	ld (flag_object_collected),a
	jr z,do_ladder_beeps

	ld hl,(score)
	ld de,10 ; score increase
	adc hl,de
	ld (score),hl
	call 55030 ; beep for object collection

do_ladder_beeps:
	ld hl,point_zero_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	ld a,(temporary_y)
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	
	ld hl,point_zero_two
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	ld a,24
	call 0x2d28 ; STACK_A
	ld a,(temporary_y)
	call 0x2d28 ; STACK_A

	; use the calc for sub op since just putting a-24 on the stack crashes the thing :D
	rst 0x28
	db 0x03
	db 0x38

	call 0x03f8 ; beep

	jp do_action_drop_down_ladder_loop
	
ladder_drop_done:
	ld a,(temporary_y)
	ld (y),a
	call draw_player
	
	ret

temporary_y:
	db 0

; IN:	A - value to check for range, within 2 and 7
; OUT:	Carry set if within range, clear if not.
check_for_collectibles_range:
	cp 1 ; > 1
	jr c,not_in_collectible_range
	cp 8 ; <= 7
	jr nc,not_in_collectible_range
	scf ; flag within range
	ret
not_in_collectible_range:
	scf
	ccf ; flag not in range
	ret

erase_player:
	ld a,0x10 ; INK
	rst 0x10
	ld a,7
	rst 0x10
	ld a,0x11 ; PAPER
	rst 0x10
	xor a
	rst 0x10
	ld a,0x12 ; FLASH
	rst 0x10
	xor a
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,32 ; erase player feet
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	ld a,32 ; erase player head
	rst 0x10

	ret

; IN:	B - Y coord
;		C - X coord
; OUT	HL - address of attribute
;		DE - corrupt (contains the offset from start)
;		AF - corrupt
get_attr_ptr:
	ld hl,0x5800 ; start of attributes area
	ld de,0 ; this will become the offset

	ld a,b ; get the Y coordinate
	rlca ; rotating multiples by 32, i.e. 32 chars per line
	rlca
	rlca
	rlca
	rlca

	ld e,a ; temp save result
	and 3 ; rotating would rotate two bits from the right in on the left
	ld d,a ; these two bits will be the high byte of DE now
	ld a,e ; get back temp result
	and 0xfc ; the remaining part without the lower two bits goes in E 
	or c ; then OR in the X coordinate
	ld e,a

	add hl,de ; this should produce the address of the correct attribute in HL
	ret

hold_border_colour:
	db 0 ; black

seed:
	dw 0

time_left_msg:
	db 0,1,'TIME LEFT ',0
score_msg:
	db 0,18,'SCORE',0
lives_left_msg:
	db 1,1,'LIVES LEFT',0
level_msg:
	db 1,18,'LEVEL',0

; OUT: A - contains RND(256) i.e. 0 to 255
; 	   B - corrupt
get_rnd:
	ld a, (seed)
	ld b, a

	rrca ; multiply by 32
	rrca
	rrca
	xor 0x1f

	add a, b
	sbc a, 255 ; carry

	ld (seed), a
	ret

abort_beep:
	ld hl,point_two
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	ld a,5
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep
	ret

death_beeps:
	ld hl,point_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	xor a
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	ld b,20
death_beeps_loop:
	djnz death_beeps_loop
	
	ld hl,point_five
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	xor a
	call 0x2d28 ; STACK_A
	ld a,20
	call 0x2d28 ; STACK_A
	rst 0x28
	db 0x03 ; subtract (top stack item from next stack item)
	db 0x38
	call 0x03f8 ; beep

	ret

; IN:	A - Y coordinate
falling_beep:
	push af
	ld hl,point_zero_zero_eight
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	ld hl,point_zero_zero_eight
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	pop af
	call 0x2d28 ; STACK_A
	ld a,12
	call 0x2d28 ; STACK_A
	rst 0x28
	db 0x03 ; subtract (top stack item from next stack item)
	db 0x38

	call 0x03f8 ; beep
	
	ret

end_game_beeps:
	ld a,1
end_game_beeps_loop:
	push af
	
	ld hl,point_zero_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	ld hl,point_zero_two
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	add 12
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	ld hl,point_zero_one
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB
	pop af
	push af
	add 6
	call 0x2d28 ; STACK_A
	call 0x03f8 ; beep

	pop af
	inc a
	cp 11
	jr nz,end_game_beeps_loop
	ret

climb_beep:
	ld hl,point_zero_zero_five
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	ld a,10
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep

	ret

footstep_beep:
	ld hl,point_zero_zero_two
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call 0x2ab6 ; STACK_AEDCB

	ld a,9
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep

	ret

typey_beeps:
	ld hl,point_zero_zero_three
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)

	call 0x2ab6 ; STACK_AEDCB

	ld a,5
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	
	ld hl,point_zero_zero_five
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)

	call 0x2ab6 ; STACK_AEDCB

	ld a,10
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	
	ld hl,point_zero_zero_three
	ld a,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)

	call 0x2ab6 ; STACK_AEDCB

	ld a,5
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep
	
	ret

intro_beep:
	ld b,8
beep_loop:
	push bc
	
	ld a,0x7C
	ld de,0x6666
	ld bc,0x6666
	call 0x2ab6 ; STACK_AEDCB - hopefully 0.05 if I got that right (I bet I didn't)

	ld a,18
	pop bc
	sub b
	push bc
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep

	ld a,0x7C
	ld de,0x6666
	ld bc,0x6666
	call 0x2ab6 ; STACK_AEDCB - hopefully 0.05 if I got that right (I bet I didn't)

	ld a,17
	pop bc
	sub b
	push bc
	call 0x2d28 ; STACK_A

	call 0x03f8 ; beep

	pop bc
	djnz beep_loop

	ret
	
draw_32_platform_lines:
	ld a, 0x7A; 0%01111010 ; BRIGHT 1: PAPER 7: INK 2
	ld (23693),a
	
	ld a,19 ; y
	ld (52000),a
	ld a,0 ; y
	ld (52001),a
	ld a,32
	ld (52002),a
	call 52100 ; draw left-right line of platforms
	ret

; Calculator generated floating point values.
point_one:
	ds 5
	
point_two:
	ds 5
	
point_five:
	ds 5
	
point_zero_one:
	ds 5

point_zero_two:
	ds 5

point_zero_zero_two:
	ds 5

point_zero_zero_three:
	ds 5

point_zero_zero_five:
	ds 5

point_zero_zero_eight:
	ds 5

orig_char_set:
	ds 2

draw_teleporters:
	ld a,71
	ld (23693),a

	ld a,0x10 ; INK
	rst 0x10
	ld a,7
	rst 0x10
	ld a,0x13 ; BRIGHT
	rst 0x10
	xor a
	rst 0x10

	CALL get_level_base_ptr
	
	; 194 (to get to the teleporters)
	; -1 to get actual start
	LD DE,194-1
	ADD HL,DE

	ld a,(hl)
	ld b,a ; number of teleporters
draw_teleporters_loop:
	ld a,0x16 ; AT
	rst 0x10

	inc hl
	ld a,(hl) ; Y coord
	rst 0x10
	
	inc hl
	ld a,(hl) ; X coord
	rst 0x10
	
	ld a,'%' ; teleporter character
	rst 0x10
	
	djnz draw_teleporters_loop

	ret

draw_collectibles:
	CALL get_level_base_ptr
	
	; 194 (to get to the teleporters)
	; 41 (to get to the collectibles)
	; -1 to get actual start
	LD DE,194+41-1
	ADD HL,DE
	
	ld a,(hl) ; number of collectibles for level
	ld (ob),a ; save it for later use
draw_collectibles_loop:
	push af
	
	; get AT, print it
	ld a,0x16
	rst 0x10
	
	inc hl
	ld a,(hl) ; Y
	rst 0x10
	
	inc hl
	ld a,(hl) ; X
	rst 0x10
	
	push hl ; save data ptr

	call get_rnd
	and 7
	jr nz,rnd_not_black
	inc a ; randomly choose an INK colour (between 1 and 7)
rnd_not_black:
	ld b,a
	push bc

	call get_rnd
	and 7 ; randomly choose one of eight collectible characters (0-7 index)
	pop bc
	ld c,a
	
	ld a,0x10 ; INK
	rst 0x10
	ld a,b
	rst 0x10

	ld hl,collectible_chars
	ld a,l
	add c
	ld l,a
	ld a,h
	adc a,0 ; in case index increment forces a carry

	ld a,(hl)
	rst 0x10 ; print random collectible

	pop hl ; restore data ptr
	
	pop af
	dec a
	jr nz,draw_collectibles_loop

	ret

collectible_chars:
	db '_opqrstu'

update_player_chars:
	ld a,(l1)
	and a
	jr z,check_r1
	add 'a'-1
	ld (player_head_char),a
	add 4 ; move to 'e',...
	ld (player_feet_char),a
	ret
check_r1:
	ld a,(r1)
	and a
	jr z,update_player_chars_done
	add 'i'-1
	ld (player_head_char),a
	add 13 ; move to 'v',...
	ld (player_feet_char),a
update_player_chars_done:
	ret

draw_player:
	ld a,0x10 ; INK
	rst 0x10
	;ld a,7 ; default is 7, can be changed by teleport
	db 0x3e
player_colour:
	db 7
	rst 0x10
	ld a,0x11 ; PAPER
	rst 0x10
	ld a,0
	rst 0x10
	ld a,0x13 ; BRIGHT
	rst 0x10
	ld a,1
	rst 0x10
	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	rst 0x10
	ld a,(x)
	rst 0x10
	;ld a,'v'
	db 0x3e
player_feet_char:
	db 'v'
	rst 0x10
	ld a,0x16 ; AT
	rst 0x10
	ld a,(y)
	dec a
	rst 0x10
	ld a,(x)
	rst 0x10
	;ld a,'i'
	db 0x3e
player_head_char:
	db 'i'
	rst 0x10
	ret

draw_exit:
	call get_level_base_ptr
	; 194 (to get to the teleporters)
	; 41 (to get to the collectibles)
	; 61 (to get to the ladders)
	; 60 (to get to the exit)
	ld de,194+41+61+60
	add hl,de
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,(hl) ; exit Y
	rst 0x10
	inc hl
	ld a,(hl) ; exit X
	rst 0x10
	
	ld a,0x10 ; INK
	rst 0x10
	ld a,7
	rst 0x10
	ld a,0x11 ; PAPER
	rst 0x10
	ld a,1
	rst 0x10
	ld a,0x12 ; FLASH
	rst 0x10
	ld a,1
	rst 0x10
	
	ld a,'$'
	rst 0x10
	
	ret

draw_current_stats:
	ld a,1
	call 0x1601 ; OPEN CHANNEL #1 - bottom screen area

	ld a,0x16 ; AT
	rst 0x10
	ld a,0  ; Y
	rst 0x10
	ld a,12 ; X
	rst 0x10

	ld bc,(time)
	call 0x2d2b ; STACK_BC
	call 0x2de3 ; PRINT TOP CALC NUMBER
	
	ld a,32 ; space
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,1  ; Y
	rst 0x10
	ld a,12 ; X
	rst 0x10
	
	ld a,(lives)
	or 0x30 ; turn into ASCII
	rst 0x10

	ld a,0x16 ; AT
	rst 0x10
	ld a,0  ; Y
	rst 0x10
	ld a,24 ; X
	rst 0x10

	ld bc,(score)
	call 0x2d2b ; STACK_BC
	call 0x2de3 ; PRINT TOP CALC NUMBER
	
	ld a,32 ; space
	rst 0x10
	
	ld a,0x16 ; AT
	rst 0x10
	ld a,1  ; Y
	rst 0x10
	ld a,24 ; X
	rst 0x10
	
	ld a,(level)
	call 0x2d28 ; STACK_A
	call 0x2de3 ; PRINT TOP CALC NUMBER
	
	ld a,2
	call 0x1601 ; OPEN CHANNEL #2 - main screen area
	ret

draw_level:
	ld a,2
	call 0x1601 ; OPEN CHANNEL #2 - main screen area

	call draw_32_platform_lines
	call draw_level_name
	
	; draw level itself
	ld a,35 ; wall
	ld (52029),a
	call draw_platforms
	
	ld a,70
	ld (23693),a
	ld a,38 ; ladder
	ld (52029),a
	call draw_ladders
	call draw_teleporters
	call draw_collectibles
	
	call 54970 ; make main buzz-beep sound
	ret

draw_level_name:
	ld a,0x16 ; AT
	rst 0x10
	ld a,21 ; Y
	rst 0x10
	xor a   ; X
	rst 0x10

	ld a,0x10 ; INK
	rst 0x10
	ld a,7
	rst 0x10
	ld a,0x11 ; PAPER
	rst 0x10
	xor a
	rst 0x10

	CALL get_level_base_ptr

	ld b,32
draw_level_name_loop:
	ld a,(hl)
	inc hl
	rst 0x10
	
	cp 32 ; space?
	jr z,draw_level_name_skip_beep
	
	push bc
	push hl
	call typey_beeps
	pop hl
	pop bc
draw_level_name_skip_beep:
	djnz draw_level_name_loop

	ret

draw_platforms:
	CALL get_level_base_ptr
	
	; HL is now base level data pointer

	LD DE,32 ; skip past the level name message
	ADD HL,DE
	
; base now points to total number of draw operations in level data
	LD A,(HL)
	LD B,A ; counter for operations
loop2:
	PUSH BC
	INC HL
	LD A,(HL) ; op type code
	INC HL
	
	CP 4
	JP Z,do_up_left_diag
	CP 3
	JP Z,do_left_right
	CP 2
	JP Z,do_up_right
	CP 1
	JP Z,do_up
	
count_ops:	
	POP BC
	DJNZ loop2
	RET
	
do_up:
	LD A,(HL) ; y-start
	LD (52000),A
	PUSH AF
	INC HL
	LD A,(HL) ; x-start
	LD (52001),A
	INC HL
	POP AF
	SUB (HL) ; take the end position off the start (start is further down the screen, and so a larger number)
	INC A ; add 1 coz that's what the BASIC version does
	LD (52002),A
	PUSH HL
	CALL 52005 ; draw that line thang!
	POP HL
	JP count_ops	
	
do_up_right:
	LD A,(HL) ; y-start
	LD (52000),A ;a(2)
	INC HL
	LD A,(HL) ; x-start
	LD (52001),A ;a(3)
	LD B,A ;SAVE IT, a(3)
	INC HL
	LD A,(HL) ;a(4)
	LD C,A ;SAVE IT, a(4)
	EX DE,HL
	LD HL,52000
	SUB (HL) ; SUBTRACT A(2) FROM A(4)
	EX DE,HL
	JR NC,do_up_right_pt2 ; JUMP IF A(2) IS LESS THAN OR EQUAL TO A(4)
	
	; AT THIS POINT, A(2) IS GREATER THAN A(4)
	LD A,(52000) ;A(2)
	SUB C ;A(2) - A(2)
	INC A ;+1 AS BASIC DOES
	LD (52002),A
	JR do_up_right_pt3
do_up_right_pt2: ; A(2) <= A(4)
	LD A,C ;RESTORE IT, a(4)
	SUB B ; A(4) - A(3)
	INC A ;+1 AS BASIC DOES
	LD (52002),A
do_up_right_pt3:
	PUSH HL
	CALL 52050 ; draw that diag thang!
	POP HL

	JP count_ops

do_left_right:
	LD A,(HL)
	LD (52000),A ; A(2)
	INC HL
	LD A,(HL)
	LD (52001),A ;A(3)
	LD C,A ;SAVE IT
	INC HL
	LD A,(HL) ; A(4)
	SUB C ; A(4) - A(3)
	INC A ; add 1 coz that's what the BASIC version does
	LD (52002),A
	PUSH HL
	CALL 52100 ; draw that line thang!
	POP HL

	JP count_ops

do_up_left_diag:
	LD A,(HL)
	LD (52000),A
	PUSH AF
	INC HL
	LD A,(HL)
	LD (52001),A
	INC HL
	POP AF
	SUB (HL) ; A(2) - A(4)
	INC A ; add 1 coz that's what the BASIC version does
	LD (52002),A
	PUSH HL
	CALL 52150 ; draw that diag thang!
	POP HL
	
	JP count_ops

; IN:	HL	- ptr to storage location for result
;		A	- numerator
;		BC	- denominator
; OUT:	All registers corrupt (AF, BC, DE, HL)
do_divide:
	push hl
	push bc
	call 0x2d28 ; STACK_A
	pop bc
	call 0x2d2b ; STACK_BC
	rst 0x28
	db 05 ; divide A by BC
	db 0x38
	call 0x2BF1 ; FP_TO_AEDCB
	pop hl
	ld (hl),a
	inc hl
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (hl),c
	inc hl
	ld (hl),b
	ret

; In:	  (level) contains the level number
; Return: HL = base level data pointer for the level
; Corrupt:AF,DE
get_level_base_ptr:
	LD HL,55032
	LD DE,358
	LD A,(level)
glb_loop1:
	ADD HL,DE
	DEC A
	JP NZ,glb_loop1
	RET

draw_ladders:
	CALL get_level_base_ptr
	
	; to get to the ladder data, add to HL:
	; 194 (to the teleporters)
	; 41 (to the collectibles)
	; 61 (to the ladders)
	; -1 (to get the number of ladders)
	LD DE,194+41+61-1
	ADD HL,DE
	
	LD A,(HL)
	LD B,A ; LADDER COUNT
	
dl_loop1:
	PUSH BC

	INC HL
	LD A,(HL) ; A(1)
	LD C,A ; SAVE IT
	INC HL
	LD A,(HL) ; A(2)
	LD (52001),A
	INC HL
	LD A,(HL) ; A(3)
	LD (52000),A ; WEIRD BASIC SAYS: (A(1) + A(3)) - A(1)... WHICH IS A(3) :s

	SUB C ; A(3) - A(1)
	INC A ; +1 AS BASIC DOES
	LD (52002),A
	
	PUSH HL
	CALL 52005 ; draw the ladder lines!
	POP HL

	POP BC
	DJNZ dl_loop1
	
	RET
	
draw_lines_for_high_score:
	exx
	push hl
	push de
	push bc
	push af
	exx
	
	ld b,0
plot_loop:
	push bc
	
	ld c,b
	ld a,175
	sub b
	ld b,a ; y
	ld c,0 ; x
	call 0x22df ; plot

	pop bc
	push bc
	
	ld a,b ; N to both coords
	push bc
	call 0x2d28 ; STACK_A
	pop bc
	ld a,b ; N to both coords
	call 0x2d28 ; STACK_A
	call 0x24b7 ; DRAW N,N

	pop bc
	push bc

	ld a,255
	sub b
	ld c,a ; x
	ld b,0 ; y
	call 0x22df ; plot

	pop bc
	push bc
	
	ld a,b ; N to both coords
	push bc
	call 0x2d28 ; STACK_A
	pop bc
	ld a,b ; N to both coords
	call 0x2d28 ; STACK_A
	call 0x24b7 ; DRAW N,N

	pop bc
	inc b
	inc b
	inc b
	inc b
	ld a,b
	cp 164
	jr nz,plot_loop
	
	exx
	pop af
	pop bc
	pop de
	pop hl
	exx
	
	ret