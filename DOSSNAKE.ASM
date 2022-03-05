  
IDEAL
MODEL small
STACK 100h

DATASEG

	; represents the current direction of the snake
	; u=up, r=right , d= down, l = left
	direction db    'r'
	
	; main loop exit flag
	exit_flag db    0 
	exit_main_loop db    0 

	game_over db    0 	
	saveKey db 0
	
	x dw 10
	y dw 10
	
	draw_color db 6h
	draw_x dw 0
	draw_y dw 0
	
	tail_credit dw 10
	
	frame dw 0

    level db 2; 0 - hyper sonic ,1 - hard ,2 - normal ,3 - easy
 	
	; cyclic array for the tail
 	tailx dw 4096 DUP(1)
	taily dw 4096 DUP(1)
	
	tail_len dw 0
	
	prevMil db ? ;check if the timer change
	
	apple_x dw 0
	apple_y dw 0
	
	end_game db 0

; https://ascii.co.uk/art/snake
snake_ascii db 13,10,'          ---_ ......._-_--.',13,10
db '         (|\ /      / /| \  \',13,10
db '         /  /     .`  -=-`   `.',13,10
db '        /  /    .`             )',13,10
db '      _/  /   .`        _.)   /',13,10
db '     / o   o        _.-` /  .`',13,10
db '     \          _.-`    / .`*|',13,10
db '      \______.-`//    .`.` \*|',13,10
db '       \|  \ | //   .`.` _ |*|',13,10
db '        `   \|//  .`.`_ _ _|*|',13,10
db '             // .`.` | _ _ \*|',13,10
db '             \_/ /    \ _ _ \*\',13,10
db '             \__/      \ _ _ \*\',13,10
db '                        \ _ _ \*',13,10
db '                         \ _ _ \ ','$'


	menu_msg_start db 13,10,' Eyals',13,10
db	' ______ _       ______ _       ______',13,10
db '(  ___ ( (    /(  __  | \    /(  ___ \',13,10
db '| (   \|  \  ( | (  ) |  \  / | (   \/',13,10
db '| (____|   \ | | (__) |  (_/ /| (_    ',13,10
db '(____  | (\ \) |  __  |   _ ( |  _)   ',13,10
db '     ) | | \   | (  ) |  ( \ \| (     ',13,10
db '/\___) | )  \  | )  ( |  /  \ | (___/\',13,10
db '\______|/    )_|/    \|_/    \(______/',13,10

                 
	db 13,10,13,10,13,10,13,10,13,10,'    [ENTER]    START',13,10,13,10,'$'
	menu_msg_level db '    [UP/DOWN]  LEVEL: ','$'
	menu_msg_exit db 13,10,13,10,'    [ESC]      EXIT','$'
	title_high_score db 13,10,13,10,13,10,'           HIGH SCORE: ','$'
	
	level_easy db 'EASY       ','$'
	level_normal db 'NORMAL     ','$'
	level_hard db 'HARD       ','$'
	level_hyper_sonic db 'HYPER SONIC','$'
	
	game_over_msg db 13,10,13,10,13,10,13,10,'               GAME OVER',13,10,13,10,13,10,'             SCORE: ','$'

	clean_screen_y dw 0
	
	score_credit dw 0
	score db '000000','$'	
	score_msg db ' SCORE: ','$'
	
	score_num dw 0
	highest_score db '000000', '$'
	highest_score_msg db '      HIGH SCORE: ', '$'
	highest_score_num dw 0
	
	midi_note_to_freq_table db 014h, 03ah, 015h, 01ah, 0e2h, 0fbh, 060h, 0dfh, 079h, 0c4h, 013h, 0abh, 01bh, 093h, 07bh, 07ch
			db 020h, 067h, 0f8h, 052h, 0f2h, 03fh, 0fdh, 02dh, 00ah, 01dh, 00ah, 00dh, 0f1h, 0fdh, 0b0h, 0efh
			db 03ch, 0e2h, 089h, 0d5h, 08dh, 0c9h, 03dh, 0beh, 090h, 0b3h, 07ch, 0a9h, 0f9h, 09fh, 0feh, 096h
			db 085h, 08eh, 085h, 086h, 0f8h, 07eh, 0d8h, 077h, 01eh, 071h, 0c4h, 06ah, 0c6h, 064h, 01eh, 05fh
			db 0c8h, 059h, 0beh, 054h, 0fch, 04fh, 07fh, 04bh, 042h, 047h, 042h, 043h, 07ch, 03fh, 0ech, 03bh
			db 08fh, 038h, 062h, 035h, 063h, 032h, 08fh, 02fh, 0e4h, 02ch, 05fh, 02ah, 0feh, 027h, 0bfh, 025h
			db 0a1h, 023h, 0a1h, 021h, 0beh, 01fh, 0f6h, 01dh, 047h, 01ch, 0b1h, 01ah, 031h, 019h, 0c7h, 017h
			db 072h, 016h, 02fh, 015h, 0ffh, 013h, 0dfh, 012h, 0d0h, 011h, 0d0h, 010h, 0dfh, 00fh, 0fbh, 00eh
			db 023h, 00eh, 058h, 00dh, 098h, 00ch, 0e3h, 00bh, 039h, 00bh, 097h, 00ah, 0ffh, 009h, 06fh, 009h
			db 0e8h, 008h, 068h, 008h, 0efh, 007h, 07dh, 007h, 011h, 007h, 0ach, 006h, 04ch, 006h, 0f1h, 005h
			db 09ch, 005h, 04bh, 005h, 0ffh, 004h, 0b7h, 004h, 074h, 004h, 034h, 004h, 0f7h, 003h, 0beh, 003h
			db 088h, 003h, 056h, 003h, 026h, 003h, 0f8h, 002h, 0ceh, 002h, 0a5h, 002h, 07fh, 002h, 05bh, 002h
			db 03ah, 002h, 01ah, 002h, 0fbh, 001h, 0dfh, 001h, 0c4h, 001h, 0abh, 001h, 093h, 001h, 07ch, 001h
			db 067h, 001h, 052h, 001h, 03fh, 001h, 02dh, 001h, 01dh, 001h, 00dh, 001h, 0fdh, 000h, 0efh, 000h
			db 0e2h, 000h, 0d5h, 000h, 0c9h, 000h, 0beh, 000h, 0b3h, 000h, 0a9h, 000h, 09fh, 000h, 096h, 000h
			db 08eh, 000h, 086h, 000h, 07eh, 000h, 077h, 000h, 071h, 000h, 06ah, 000h, 064h, 000h, 05fh, 000h
	
		
	menu_music_size dw 225
	menu_music 	db 051h, 058h, 02fh, 0feh, 042h, 0ffh, 0ffh, 0feh, 041h, 0ffh, 0ffh, 0feh, 042h, 0ffh, 0ffh, 0feh
	db 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h
	db 0ffh, 0ffh, 0feh, 046h, 0ffh, 0ffh, 0feh, 047h, 0ffh, 0ffh, 0feh, 04ah, 0ffh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 03eh, 0ffh, 0ffh, 0feh, 042h, 0ffh, 0ffh, 0feh, 042h
	db 0ffh, 0ffh, 0feh, 045h, 0ffh, 0ffh, 0feh, 047h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 045h, 0ffh
	db 0ffh, 0feh, 042h, 0ffh, 0ffh, 0feh, 03eh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0feh
	db 041h, 0ffh, 0ffh, 0feh, 040h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 041h, 0ffh, 0ffh, 0feh, 042h, 0ffh, 0ffh, 0feh, 041h, 0ffh, 0ffh, 0feh, 042h, 0ffh, 0ffh, 0feh
	db 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 046h, 0ffh, 0ffh, 0feh
	db 047h, 0ffh, 0ffh, 0feh, 046h, 0ffh, 0ffh, 0feh, 047h, 0ffh, 0ffh, 0feh, 04ah, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04eh, 0ffh, 0ffh, 0feh, 04eh
	db 0ffh, 0ffh, 0feh, 04eh, 0ffh, 0ffh, 0feh, 04eh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh, 04ch, 0ffh
	db 0ffh, 0feh, 04ah, 0ffh, 0ffh, 0feh, 04ch, 0ffh, 0ffh, 0feh, 04eh, 0ffh, 0ffh, 0feh, 04dh, 0ffh
	db 0ffh, 0feh, 04ch, 0ffh, 0ffh, 0feh, 04ah, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0feh
	db 0ffh
		
	game_over_music_size dw 579
	
	; 0~127 -> note
	; 254   -> note off
	; 255   -> ignore
	game_over_music 	db 003h, 051h, 02fh, 003h, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03dh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 038h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 038h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 038h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03dh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 038h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 038h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 038h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 036h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 045h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 045h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03dh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 03dh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03dh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03dh, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 03bh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 040h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh
	db 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
	db 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 042h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 03bh, 0ffh, 0ffh, 0ffh
	db 0ffh, 0ffh, 039h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 038h, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 034h, 0ffh
	db 0ffh, 0ffh, 0ffh

			
CODESEG

proc make_longer_if_needed
	cmp [tail_credit],0
	je no_credit
	dec [tail_credit]
	cmp [tail_len], 4096
	je no_credit
	inc [tail_len]
	
	no_credit:
	ret
endp make_longer_if_needed


proc push_head 
	xor ax,ax
	mov ax, [frame]
	add ax,[tail_len] ; len of tail
	
	; make sure we dont pass the 4096 value here
	mov dx, 0
	mov cx, 4096
	div cx
	mov ax, dx
	
	add ax,ax
	mov bx, offset tailx
	add bx, ax
	mov ax, [x]
	mov [bx], ax
	
	xor ax,ax
	mov ax, [frame]
	
	add ax,[tail_len] ; len of tail
	
	; make sure we dont pass the 4096 value here
	mov dx, 0
	mov cx, 4096
	div cx
	mov ax, dx	
	
	add ax,ax 
	mov bx, offset taily
	add bx, ax
	mov ax, [y]
	mov [bx], ax
	ret
endp push_head

proc pop_tail

	xor ax,ax	
	mov ax, [frame]
	
	; make sure we don't pass the 4096 value here
	mov dx, 0
	mov cx, 4096
	div cx
	mov ax ,dx
	
	add ax,ax
	mov bx, offset tailx

	add bx, ax
	
	xor ax,ax	
	mov ax, [frame]
	
	; make sure we don't pass the 4096 value here
	mov dx, 0
	mov cx, 4096
	div cx
	mov ax ,dx	
	add ax,ax

	mov cx, [bx] ;x
	xor [word ptr bx], 0

	mov bx, offset taily
	add bx, ax
	
	mov dx, [bx] ; y
	mov [word ptr bx], 0
	
	mov [draw_color], 0h
	mov [draw_x], cx
	mov [draw_y], dx
	xor ax,ax
	call draw_box
	
	ret
endp pop_tail

proc draw_borders
	mov [draw_color], 12h
	mov [draw_x], 0
	draw_borders_x:	
		mov [draw_y], 2
		call draw_box
		mov [draw_y], 39
		call draw_box
	cmp [draw_x], 63
	je draw_borders_y
	inc [draw_x]
	jmp draw_borders_x
	
	draw_borders_y:
		mov [draw_x], 0
		call draw_box
		mov [draw_x], 63
		call draw_box
	cmp [draw_y], 2
	je done_borders
	dec [draw_y]
	jmp draw_borders_y
		
	done_borders:
	ret
endp draw_borders



proc draw_box
	mov bh,0h
	
	mov ax,[draw_x]
	mov bx, 5
	mul bx
	mov cx,ax
	
	mov ax,[draw_y]
	mov bx, 5
	mul bx
	mov dx,ax
	
	mov bx, dx
	add bx, 5
	
	mov al,[draw_color]
	mov ah,0ch	
	one_line:
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
		inc cx
		int 10h
	sub cx, 4
	inc dx
	cmp bx, dx
	jne one_line
	ret
endp draw_box

proc check_self
	
	mov cx,0
	start_check_loop:
		mov bx, offset tailx
		add bx, cx
		mov ax, [bx]
		cmp ax, [x]
		jne no_match_with_head
		mov bx, offset taily
		add bx, cx
		mov ax, [bx]
		cmp ax, [y]
		jne no_match_with_head
		mov [game_over],1
		
		no_match_with_head:
		inc cx
		inc cx
		cmp cx, 8192
	jne start_check_loop
	ret
endp

proc validate_apple
	
	mov cx,0
	start_check_loop_va:
		mov bx, offset tailx
		add bx, cx
		mov ax, [bx]
		cmp ax, [apple_x]
		jne no_match_with_head_va
		mov bx, offset taily
		add bx, cx
		mov ax, [bx]
		cmp ax, [apple_y]
		jne no_match_with_head_va
		mov [apple_x], 0
		mov [apple_y], 0		
		no_match_with_head_va:
		inc cx
		inc cx
		cmp cx, 8192
	jne start_check_loop_va
	ret
endp


proc check_eat_apple

	mov ax, [x]
	cmp ax,[apple_x]
	jne no_match
	mov ax, [y]
	cmp ax,[apple_y]
	jne no_match
	
	mov [apple_x],0
	mov [apple_y],0
	mov ax, [tail_credit]
	add ax, 15 ; 15 more credits, so the tail will become longer
	mov [tail_credit],ax
	
	mov ax, [score_credit]
	add ax, 20 ; 20 more score credits
	mov [score_credit],ax
	inc [score_num]
	
	;check if current score is greater than high score then 
	; highest_score_num <- score_num
	mov ax, [score_num]
	cmp ax, [highest_score_num]
	jng no_match
	mov [highest_score_num], ax	

	no_match:
		ret
endp check_eat_apple

proc random_apple
	
	cmp [apple_x], 0
	je rand_location
	jmp end_apple_rand
	rand_location:
		; random(64) -> apple_x
		mov ah, 00h  ; interrupts to get system time        
		int 1Ah      ; CX:DX now hold number of clock ticks since midnight      

		mov ax, dx
		xor dx, dx
		mov cx, 62    
		div cx       ; here dx contains the remainder of the division - from 0 to 9
		inc dx
		mov [apple_x], dx
		
		; random(40) -> apple_y
		mov ah, 00h  ; interrupts to get system time        
		int 1Ah      ; CX:DX now hold number of clock ticks since midnight      

		mov ax, dx
		xor dx, dx
		mov cx, 36    
		div cx       ; here dx contains the remainder of the division - from 0 to 9
		inc dx
		inc dx
		inc dx
		mov [apple_y], dx
		
		call validate_apple
		
		call draw_apple
	
	
	end_apple_rand:
	ret
endp random_apple

proc remove_apple
	mov [draw_color], 0h
	mov ax, [apple_x]
	mov [draw_x], ax
	mov ax, [apple_y]
	mov [draw_y], ax
	xor ax,ax
	call draw_box	
	
	ret
endp remove_apple
	

proc draw_apple
	mov [draw_color], 4h
	mov ax, [apple_x]
	mov [draw_x], ax
	mov ax, [apple_y]
	mov [draw_y], ax
	xor ax,ax
	call draw_box	
	
	ret
endp draw_apple


proc mainLoop
	mov [exit_main_loop], 0
	call update_and_draw_score
	
	; check if key pressed
	in al, 64h
	cmp al, 10b
	je update_coordinations
	; no need to read form the keyboard
	
	; read from the keyboard
	in al, 60h
	cmp al, [saveKey]  ;check if the key is same as already pressed​
	je update_coordinations
	
	mov [saveKey], al  ;new key - store it​
	test_esc:
		cmp al, 1h ​
		jne test_up
		mov [exit_main_loop],1
	
	test_up:
		cmp al, 48h  ; 48h is for up key
		jne test_down
		cmp [direction], 'd'
		je test_down
		mov [direction], 'u'
		jmp update_coordinations
		
	test_down:
		cmp al, 50h ; 50h is for down key
		jne test_left
		cmp [direction], 'u'
		je test_left
		mov [direction], 'd'
		jmp update_coordinations
	
	test_left:
		cmp al, 4Bh ; 4Bh is for left key
		jne test_right
		cmp [direction], 'r'
		je test_right
		mov [direction], 'l'
		jmp update_coordinations
	
	test_right:
		cmp al, 4Dh ; 4Dh is for right key
		jne update_coordinations
		cmp [direction], 'l'
		je update_coordinations
		mov [direction], 'r'
		jmp update_coordinations
		
	update_coordinations:

	call make_longer_if_needed
	
	
	call check_self
	call push_head
	call pop_tail

	call random_apple
	

	inc [frame]	
	
	increase_x:
		cmp [direction], 'r'
		jne decrease_x
		inc [x]
		cmp [x], 63
		jne decrease_x
		mov [game_over], 1
	decrease_x:
		cmp [direction], 'l'
		jne increase_y
		dec [x]
		cmp [x], 0
		jne increase_y
		mov [game_over], 1
	increase_y:
		cmp [direction], 'd'
		jne decrease_y
		inc [y]
		cmp [y], 39
		jne decrease_y
		mov [game_over], 1
	decrease_y:
		cmp [direction], 'u'
		jne after_move
		dec [y]
		cmp [y], 2
		jne after_move
		mov [game_over], 1
	
	after_move:
	
	; draw the new snake head location
	mov [draw_color], 2h
	mov ax, [x]
	mov [draw_x], ax
	mov ax, [y]
	mov [draw_y], ax
	xor ax,ax
	call draw_box
	
	
	call check_eat_apple
			

  cmp [level], 0
  je testGameOver
  mov bl, [level]
  
  sleep:
	mov ah,2ch
	int 21h
	mov [prevMil],dl            ;get first tick
	change:
		mov ah,2ch
		int 21h
		cmp dl,[prevMil]        ;check if we got a change in timer
		je change               ;if we are not, lets go and check again

	dec bl
	cmp bl,0
	jne sleep
	
	testGameOver:
		cmp [game_over],1
		jne testExit
		call game_over_screen
		call reset_all
		call draw_borders
		mov [exit_main_loop],1

	testExit:
		cmp [exit_main_loop],1
		je exitLoop

	jmp mainLoop
	
	exitLoop:
		ret
		
endp  mainLoop


proc clean_screen

	mov [clean_screen_y], 0h
	mov [draw_color], 0h
	start_line:
	mov [draw_x], 0
	clean_screen_x:	
		mov ax,[clean_screen_y]
		mov [draw_y], ax
		call draw_box
	cmp [draw_x], 63
	je next_line
	inc [draw_x]
	jmp clean_screen_x
	next_line:
		cmp [clean_screen_y], 40h
		je done_clean_screen
		mov ax,[clean_screen_y]
		inc ax
		mov [clean_screen_y], ax
		jmp start_line
		
	
	done_clean_screen:
	ret
endp clean_screen

proc update_and_draw_score
	call stopnoise
	
	; check score credit
	cmp [score_credit],0
	je no_overflow
	call noise 
	dec  [score_credit]
	mov si, offset score
	add si, 5
	
	add_one:
	inc [byte ptr si]
	cmp [byte ptr si],':'
	jl no_overflow
	mov [byte ptr si],'0'
	dec si
	jmp add_one
	
	no_overflow:
	
	; copy score string in to highest_score if highest_score_num is score_num
	mov ax, [score_num]
	cmp ax, [highest_score_num]
	jne no_score_credit
	mov ax, [word ptr score]
	mov [word ptr highest_score], ax
	mov ax, [word ptr score + 2]
	mov [word ptr highest_score + 2], ax
	mov ax, [word ptr score + 4]
	mov [word ptr highest_score + 4], ax
	
	no_score_credit:
	
	; set cursor position:
	mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	; draw msg
	mov dx, offset score_msg
	mov ah, 9h
	int 21h
	
	; draw score	
	mov dx, offset score
	mov ah, 9h
	int 21h
	

	; draw high score msg
	mov dx, offset highest_score_msg
	mov ah, 9h
	int 21h
	
	; draw high score	
	mov dx, offset highest_score
	mov ah, 9h
	int 21h

	
	ret
endp update_and_draw_score

; noise and stopnoise are based on https://github.com/roykuper13/Snake/blob/master/projproc.asm
proc noise
	in      al, 61h
	or      al, 00000011b
	out     61h, al
	mov     al, 0b6h
	out     43h, al
	mov     ax, 500h
	mov     bx, [score_credit]
	add     bx, bx
	add     bx, bx
	add     bx, bx
	add     bx, bx
	add     bx, bx
	add     bx, bx
	add     bx, bx
	add     ax, bx
	out     42h, al
	mov     al, ah
	out     42h, al
	ret
endp noise

proc stopnoise
	in      al, 61h
	and     al, 11111100b
	out 61h, al
	ret
endp stopnoise
		
		
; based on https://github.com/leonardo-ono/Assembly8086MarioMusicOnPCSpeakerTest
proc play_music_game_over
		mov si, 0

		music_next_note:

		; check if key pressed
		in al, 64h
		cmp al, 10b
		je no_key_pressed
	
		; read from the keyboard
		in al, 60h
		cmp al, [saveKey]  ;check if the key is same as already pressed​
		je no_key_pressed
	
		mov [saveKey], al  ;new key - store it​
		; test esc
		cmp al, 1h ​
		jne no_key_pressed
		jmp music_end ; stop music
		
		no_key_pressed:

			mov bh, 0
			mov bl, [game_over_music + si]
			
			cmp bl, 255 ; ignore
			jz music_ignore
			cmp bl, 254 ; note off
			jz music_note_off
			
		music_play_midi_note:
			shl bx, 1
			mov ax, [word ptr midi_note_to_freq_table + bx]
			call note_on
			jmp music_ignore
			
		music_note_off:
			call note_off
		music_ignore:
		
		music_delay:
		
		
		mov ah,2ch
		int 21h
		mov [prevMil],dl            ;get first tick
		music_delay_change:
			mov ah,2ch
			int 21h
			cmp dl,[prevMil]        ;check if we got a change in timer
			je music_delay_change   ;if we are not, lets go and check again				
			inc si
			cmp si, [game_over_music_size]
			jb music_next_note
		music_end:
		call note_off
	ret
endp play_music_game_over

proc game_over_screen

	call stopnoise
	; clean screen
	call clean_screen
	
	; set cursor position:
	mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	
	; draw snake_ascii
	mov dx, offset snake_ascii
	mov ah, 9h
	int 21h
	
	
	; draw game over	
	mov dx, offset game_over_msg
	mov ah, 9h
	int 21h

	; draw score	
	mov dx, offset score
	mov ah, 9h
	int 21h
	
	
	; play music until key pressed
	call play_music_game_over
	call clean_screen
	
	ret
endp game_over_screen

proc reset_all
	clean_tail:
	cmp [tail_len],0
	je no_tail
	
	call pop_tail
	inc [frame]
	dec [tail_len]
	jmp clean_tail
	
	no_tail:
	
	call remove_apple
	
	; represents the current direction of the snake
	; u=up, r=right , d= down, l = left
	mov [direction] , 'r'
	mov [game_over] , 0
	mov [x], 10	
	mov [y], 10
	
	mov [tail_credit], 10
	
	mov [frame], 0
	mov [score_credit], 0
	
	
	mov [byte ptr score], '0'
	mov [byte ptr score + 1], '0'
	mov [byte ptr score + 2], '0'
	mov [byte ptr score + 3], '0'
	mov [byte ptr score + 4], '0'
	mov [byte ptr score + 5], '0'
    
	;level db 2; 0 - super fast ,1 fast,2 regular ,3 slow
	
	; clean tailx and taily
	mov cx,0
	start_reset_loop:
		mov bx, offset tailx
		add bx, cx
		mov [word ptr bx], 0
		mov bx, offset taily
		add bx, cx
		mov [word ptr bx], 0
		inc cx
		inc cx
		cmp cx, 8192
	jne start_reset_loop	
 	
	
	mov [tail_len], 0
	
	
	mov [apple_x], 0
	mov [apple_y], 0
	
	mov [score_num], 0
	
	
	ret
endp reset_all



	; ax = 1193180 / frequency		
proc note_on
	; change frequency
	mov dx, ax
	mov al, 0b6h
	out 43h, al
	mov ax, dx
	out 42h, al
	mov al, ah
	out 42h, al

	; start the sound
	in al, 61h
	or al, 3h
	out 61h, al
	ret
endp note_on

	; stop the sound
proc note_off
		in al, 61h
		and al, 0fch
		out 61h, al			
		ret
endp note_off

proc print_menu_items

	cmp [level],4
	jne set_cursor_position
	mov [level],3
	

set_cursor_position:
	mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	

	mov dx, offset menu_msg_start
	mov ah, 9h
	int 21h

	mov dx, offset menu_msg_level
	mov ah, 9h
	int 21h
	
	cmp [level], 3
	jne print_normal
	mov dx, offset level_easy
	mov ah, 9h
	int 21h
	jmp done_print_level
	
	print_normal:
	cmp [level], 2
	jne print_hard
	mov dx, offset level_normal
	mov ah, 9h
	int 21h
	jmp done_print_level

	print_hard:
	cmp [level], 1
	jne print_hyper_sonic
	mov dx, offset level_hard
	mov ah, 9h
	int 21h
	jmp done_print_level
	
	print_hyper_sonic:
	cmp [level], 0
	jne done_print_level
	mov dx, offset level_hyper_sonic
	mov ah, 9h
	int 21h
	
	
	done_print_level:

	mov dx, offset menu_msg_exit
	mov ah, 9h
	int 21h
	
	; draw highest_score
	mov dx, offset 	title_high_score
	mov ah, 9h
	int 21h
	
	mov dx, offset 	highest_score
	mov ah, 9h
	int 21h
	
	ret
endp print_menu_items
	
proc menu

	mov si, 0
	menu_music_next_note:

	call print_menu_items

	; check if key pressed
	in al, 64h
	cmp al, 10b
	je menu_no_key_pressed

	; read from the keyboard
	in al, 60h
	cmp al, [saveKey]  ;check if the key is same as already pressed​
	je menu_no_key_pressed

	mov [saveKey], al  ;new key - store it​
	; test esc
	cmp al, 1h ​
	jne menu_test_enter
	mov [exit_flag], 1	
	jmp menu_music_end ; stop music
	
	menu_test_enter:
		cmp al, 1ch  ; 1ch is for enter key
		jne menu_test_up
		jmp menu_music_end ; stop music


	menu_test_up:
		cmp al, 48h  ; 48h is for up key
		jne menu_test_down
		inc [level]
		jmp menu_no_key_pressed
		
	menu_test_down:
		cmp al, 50h ; 50h is for down key
		jne menu_no_key_pressed
		cmp [level],0
		je menu_no_key_pressed
		dec [level]
		jmp menu_no_key_pressed
		

	
	menu_no_key_pressed:

		mov bh, 0
		mov bl, [menu_music + si]
		
		cmp bl, 255 ; ignore
		jz menu_music_ignore
		cmp bl, 254 ; note off
		jz menu_music_note_off
		
	menu_music_play_midi_note:
		shl bx, 1
		mov ax, [word ptr midi_note_to_freq_table + bx]
		call note_on
		jmp menu_music_ignore
		
	menu_music_note_off:
		call note_off
	menu_music_ignore:
	
	menu_music_delay:
	
	
	mov ah,2ch
	int 21h
	mov [prevMil],dl            ;get first tick
	menu_music_delay_change:
		mov ah,2ch
		int 21h
		cmp dl,[prevMil]        ;check if we got a change in timer
		je menu_music_delay_change   ;if we are not, lets go and check again				
		inc si
		cmp si, [menu_music_size]
		jb menu_music_next_note
		mov si, 0
		jmp menu_music_next_note
	menu_music_end:


	ret
endp menu	
	
start:
        mov ax, @data
        mov ds, ax
        mov es,ax 
								
		; start graphic mode
		mov ax, 13h
		int 10h

	back_to_menu:
		call reset_all
		
		call clean_screen
		call menu
		
		call clean_screen
		call draw_borders		
		call mainLoop
		
		cmp [exit_flag],0
		je back_to_menu
		
			
		; Return to text mode
		mov ah, 0
		mov al, 2
		int 10h
		
	
		
exit:
        mov ax, 4c00h
        int 21h
END start
