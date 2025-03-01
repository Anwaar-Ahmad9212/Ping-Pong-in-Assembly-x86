[org 0x0100]

jmp start

left_paddle : db 12
right_paddle: db 12

;; Code to clear screen ;;
clrscr: 	
            push es
			push ax
			push cx
			push di
			mov ax, 0xb800
			mov es, ax
			xor di, di
			mov cx, 2000
			mov ax, 0x0C7E
			
			cld
			rep stosw

			pop di
			pop cx
			pop ax
			pop es
			ret
			
			
border:		
            push bp
			mov bp, sp
			sub sp, 4
			mov word[bp-2], 0 ; Left Vertical Border
			mov word[bp-4], 158 ; Right Vertical Border
			push ax
			push di
			push es
			mov ax, 0xb800
			mov es, ax			

			mov ax, 0x0E
			
vertical:	mov di, word[bp-2]
			mov [es:di], ax
			add word[bp-2], 160
			mov di, word[bp-4]
			mov [es:di], ax
			add word[bp-4], 160
			cmp word[bp-2], 4000
			jne vertical
			
			pop es
			pop di
			pop cx
			pop ax
			mov sp, bp
			pop bp
			ret

;; Code to print a center line on the screen when displaying the names ;;
centerLine:	push bp
			mov bp, sp
			push ax
			push cx
			push di
			push es
			mov ax, 0xb800
			mov es, ax
			
outerLoop:	mov di, word[bp+4] ;; Load starting postion of line ;;
			mov ax, 0x0E
			mov cx, 25

;; Printing line that divides both players			
printLine:	mov [es:di], ax
			add di, 160
			loop printLine
			
			pop es
			pop di
			pop cx
			pop ax
			pop bp
			ret 2
			

game_name: db 'PingPong'
created: db 'Created with love by'


;; Intro function to display the introduction ;;

intro:
push bp	
push ax
push bx
push cx
push dx
            mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 0x0E 
			mov dx, 0x0A19
			mov cx, 8
			push cs
			pop es 
			mov bp, game_name
			int 0x10
			
			mov dx, 0x0B19
			mov cx, 20
			push cs
			pop es
			mov bp, created
			int 0x10
			
			mov dx, 0x0C19
			mov cx, 30
			push cs
			pop es
			mov bp, creator_1
			int 0x10
			
			mov dx, 0x0D19
			mov cx, 22
			push cs
			pop es
			mov bp, creator_2
			int 0x10
			
			mov ah, 01
			int 0x21


pop dx
pop cx
pop bx
pop ax
pop bp
    		ret


;; Subroutine to show the score of player1 on the left side of the screen ;;
score_show_left:

push ax
push bx
push cx
push dx

    mov ah, 02h         ; Set cursor position 
    mov bh, 0           ; Page number 
    mov dh, 5           ; Row number
    mov dl, 10          ; Column number 
    int 10h 

    mov al, [score_player_left] ; Load the value of score_left into AL.
    add al, 0x30 
    cmp al, 0x35
    je winning_condition1

	
     mov ah, 09h                 ; Write character and attribute
    mov bl, 0x0E               ; Light yellow on black background
    mov cx, 1                 ; Repeat 1 time
    int 10h

pop dx
pop cx
pop bx
pop ax
ret	


;; Subroutine to show the score of player1 on the left side of the screen ;;
score_show_right:

push ax
push bx
push cx
push dx

    mov ah, 02h         ; Set cursor position 
    mov bh, 0           ; Page number
    mov dh, 5           ; Row number 
    mov dl, 70          ; Column number 
    int 10h 
    mov ax,0
    mov al, [score_player_right] ; Load the value of score_left into AL.
    add al, 0x30          
    cmp al,0x35
    je winning_condition2
	                    
    mov ah, 09h           
                         
    mov bl, 0x0E         ;;light yellow on black background;;
    mov cx,1 
    int 10h  

pop dx
pop cx
pop bx
pop ax
ret	


;; Subroutine to display the winning statement ;;

winning_condition1:
;Display string player1 win

call clrscr
            mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 0x0E 
			mov dx, 0x0A19
			mov cx, 8
			push cs
			pop es 
			mov bp, name_1
			int 0x10
			

            mov dx, 0x0B19
			mov cx, 3
			push cs
			pop es 
			mov bp, winner
			int 0x10


jmp terminating_game



winning_condition2:
;Display string player2 win
call clrscr


   mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 0x0E
			mov dx, 0x0A19
			mov cx, 8
			push cs
			pop es 
			mov bp, name_2
			int 0x10
			

            mov dx, 0x0B19
			mov cx, 3
			push cs
			pop es 
			mov bp, winner
			int 0x10


jmp terminating_game


name_1: db 'Player 1'
name_2: db 'Player 2'
winner: db 'won'
show_name_player:

    push ax
    push bx
    push cx
    push dx
    push bp

            mov ah, 0x13 
			mov al, 1 
			mov bh, 0 
			mov bl, 7 
			mov dx, 0x0510
			mov cx, 8
			push cs
			pop es 
			mov bp, name_1
			int 0x10


            mov dx, 0x0570
			mov cx, 8
			push cs
			pop es 
			mov bp, name_2
			int 0x10



    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ret


;;Logic for pausing the game

handle_pause:
    push ax
    push bx
    push cx
call clear_input_buffer
pause_loop:
    xor ax, ax
    mov ah, 00h
    int 16h          
    cmp al, 0x1B     
   je exit_pause    
    jmp pause_loop  

exit_pause:
    pop cx
    pop bx
    pop ax
    ret


play_tone:

push ax
push cx
    mov al, 0xB6             
    out 0x43, al             

    mov ax, 1136             
    out 0x42, al             
    mov al, ah
    out 0x42, al             

    in al, 0x61              
    or al, 3                 
    out 0x61, al             

    
    mov cx, 0xFFFF           
delay_loop_speaker:
    loop delay_loop_speaker

    in al, 0x61              
    and al, 0xFC             
    out 0x61, al

    pop cx
    pop ax
    ret


;; The gameloop subroutine contains our collision with paddle, paddle show, ball hitting the wall 

game_loop:

push ax
push cx
mov cx,0XFFFF

next_input:
 call paddleshow_right
 call paddleshow
 call ball_show
 call ball_hit
 
 ;call show_name_player
 
 
 call score_show_left
 call score_show_right
  

; call speaker_on
 
 call delay
;call speaker_off

   xor ax,ax
   mov ah,01h
   int 16h
   cmp al,'w'
   je mov_l_up
   cmp al,'s'
   je mov_l_down
   cmp ah,0x48
   je mov_r_up
   cmp ah,0x50
   je mov_r_down
cmp al,0x1B
je pause_game


n1:
;call change_position_normal
call clear_input_buffer


call clrscr

loop next_input
pop cx
pop ax
ret

pause_game:
call handle_pause
jmp next_input

;; To move left paddle down ;;
mov_l_down:
call clear_left;
add byte [left_paddle],1;
cmp byte [left_paddle],23;
jne skip_l_down
sub byte[left_paddle],1

skip_l_down:
call paddleshow;

jmp n1

;; To move left paddle down ;;
mov_l_up:
;; To clear the paddle after movement ;;
call clear_left;
sub byte [left_paddle],1;
cmp byte [left_paddle],-1;
jne skip_l_up
add byte[left_paddle],1

skip_l_up:
call paddleshow;

jmp n1

;;;;;;;;;;;;;;;;;;;; To move the right paddle down ;;;;;;;;;;;;;;;;;;;;;;;;;
mov_r_down:
call clear_right;
add byte [right_paddle],1;
cmp byte [right_paddle],23;
jne skip_r_down
sub byte[right_paddle],1

skip_r_down:
call paddleshow_right;
jmp n1
  
  
;;;;;;;;;;;;;;;;;;;;;; To move the right paddle up ;;;;;;;;;;;;;;;;;;;;;;;;;;
mov_r_up:
call clear_right;
sub byte [right_paddle],1;

cmp byte [right_paddle],-1;
jne skip_r_up
add byte[right_paddle],1

skip_r_up:

call paddleshow_right;
jmp n1



;;;;;;;;;;;;;;;;;;;;;;;; Paddle display ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
paddleshow_right:

push ax
push bx
push cx
push es
push di


mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [right_paddle] ; multiply with y position
add ax, 79 ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location

mov word[es:di],0x343D


add di,160

	
mov word[es:di],0x343D

add di,160

mov word[es:di],0x343D

pop di
pop es
pop cx
pop bx
pop ax


ret 

clear_right:

push ax
push bx
push cx
push es
push di


mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [right_paddle] ; multiply with y position
add ax, 79 ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location

mov word[es:di],0x0720


add di,160

mov word[es:di],0x0720

add di,160

mov word[es:di],0x0720


pop di
pop es
pop cx
pop bx
pop ax


ret 


paddleshow:

push ax
push bx
push cx
push es
push di


mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [left_paddle] ; multiply with y position
add ax, 0 ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location



new_loop:

mov word[es:di],0x343D


add di,160
	
mov word[es:di],0x343D

add di,160

mov word[es:di],0x343D

pop di
pop es
pop cx
pop bx
pop ax


ret 

clear_left:

push ax
push bx
push cx
push es
push di


mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [left_paddle] ; multiply with y position
add ax, 0 ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location


mov word[es:di],0x0720


add di,160

	
mov word[es:di],0x0720

add di,160

mov word[es:di],0x0720


pop di
pop es
pop cx
pop bx
pop ax


ret 


delay:
    push cx
    push dx
    mov cx, 0x100   ; Outer loop for delay (adjust as needed)
delay_outer:
    mov dx, 0x200   ; Inner loop for finer delay (adjust as needed)
delay_inner:
    nop             ; No operation (burns a cycle)
    dec dx
    jnz delay_inner
    dec cx
    jnz delay_outer
    pop dx
    pop cx
    ret


clear_input_buffer:
    push ax
    push bx
    push cx

clear_loop:
    mov ah, 01h         ; Check if a key is available
    int 16h             ; Call BIOS interrupt
    jz buffer_cleared   ; Exit if no key is available

    mov ah, 00h         ; Read and discard the key
    int 16h             ; This removes the key from the buffer
    jmp clear_loop      ; Continue checking for remaining keys

buffer_cleared:
    pop cx
    pop bx
    pop ax
    ret


left_collide: db 0
right_collide:db 0


;;;;;;;;;;;;;;; Subroutine to manage our ball collision with the walls of the screen ;;;;;;;;;;;;;;;;;;;
ball_hit:
    push ax
    push dx

;;;;;;;;;;;;;;; Move the ball first ;;;;;;;;;;;;;;;;;;;;;;;;;;


    mov dl, [x_direction]
    add byte [x_position], dl
    mov dl, [y_direction]
    add byte [y_position], dl

mov dl,[right_paddle]

cmp dl,[y_position]
je check_x_axis_right 
add dl,1
cmp dl,[y_position]
je check_x_axis_right
add dl,1
cmp dl,[y_position]
je check_x_axis_right



mov dl,[left_paddle]

cmp dl,[y_position]
je check_x_axis_left 
add dl,1
cmp dl,[y_position]
je check_x_axis_left
add dl,1
cmp dl,[y_position]
je check_x_axis_left
jmp check_normal


jmp check_normal

check_x_axis_right:

mov al,[x_position]
cmp al,78
je relfect_right_paddle_check
jmp check_normal

relfect_right_paddle_check:
mov al, [x_direction]
neg al
mov [x_direction], al
jmp exit_collide



check_x_axis_left:

mov al,[x_position]
cmp al,1
je relfect_left_paddle_check
jmp check_normal

relfect_left_paddle_check:
mov al, [x_direction]
neg al
mov [x_direction], al
jmp exit_collide


check_normal:
    ; Check for right wall collision
	call check_collision
    mov al, [x_position]
    cmp al, 80
    je reflect_right

    ; Check for top wall collision
	call check_collision
    mov dl, [y_position]
    cmp dl, -1
    je reflect_top

    ; Check for left wall collision
	call check_collision
    mov al, [x_position]
    cmp al, -1
    je reflect_left

    ; Check for bottom wall collision
	call check_collision
    mov dl, [y_position]
    cmp dl, 25
    je reflect_bottom  ; If y_position > 24, reflect

    jmp exit_collide  ; No collision, exit


;;;;;;;; <====== Reflects the ball from bottom row ======> ;;;;;;;;;;;;;
reflect_bottom:
    ; Reflect off the bottom wall
    mov al, [y_direction]
    neg al
    mov [y_direction], al

    ; Move the ball slightly up to prevent sticking
    sub byte [y_position], 2
    jmp exit_collide
	
	
	
	
	
;<==================== Reflection from left wall =====================>;
reflect_left:
    ; Reflect off the left wall
    add byte [score_player_right],1
    mov al, [x_direction]
    neg al                    ; Reverse x direction
    mov [x_direction], al     ; Update x_direction in memory

    ; Move the ball slightly to the right to prevent sticking
    add byte [x_position], 2  ; Move ball slightly right
    call play_tone
    jmp exit_collide



;<==================== Reflection from top wall =====================>;
reflect_top:
    ; Reflect off the top wall
    mov al, [y_direction]
    neg al
    mov [y_direction], al

    ; Move the ball slightly down to prevent sticking
    add byte [y_position], 2
    jmp exit_collide


;<==================== Reflection from right wall =====================>;
reflect_right:
    ; Reflect off the right wall

    add byte [score_player_left],1
    mov al, [x_direction]
    neg al
    mov [x_direction], al

    ; Move the ball slightly to the left to prevent sticking
    sub byte [x_position], 2  ; Corrected: Move ball slightly left

call play_tone


    jmp exit_collide

exit_collide:
    pop dx
    pop ax
    ret

;<==================== Reflection from all the four corners =====================>;
check_collision:
    ; Check top-left corner (x = 0 and y = 0)
    mov al, [x_position]
    cmp al, 0
    jne not_top_left
    mov al, [y_position]
    cmp al, 0
    jne not_top_left

    ; Ball is at the top-left corner
    neg byte [x_direction]  ; Reverse horizontal direction
    neg byte [y_direction]  ; Reverse vertical direction
    add byte [x_position], 1  ; Move slightly away from corner
    add byte [y_position], 1
    jmp exit_check

not_top_left:
    ; Check top-right corner 
    mov al, [x_position]
    cmp al, 79       
    jne not_top_right
    mov al, [y_position]
    cmp al, 0
    jne not_top_right

    ; Ball is at the top-right corner
    neg byte [x_direction]    ; Reverse horizontal direction
    neg byte [y_direction]    ; Reverse vertical direction
    sub byte [x_position], 1  ; Move slightly away from corner
    add byte [y_position], 1
    jmp exit_check

not_top_right:
    ; Check bottom-left corner
    mov al, [x_position]
    cmp al, 0
    jne not_bottom_left
    mov al, [y_position]
    cmp al, 24
    jne not_bottom_left

    ; Ball is at the bottom-left corner
    neg byte [x_direction]    ; Reverse horizontal direction
    neg byte [y_direction]    ; Reverse vertical direction
    add byte [x_position], 1  ; Move slightly away from corner
    sub byte [y_position], 1  ; Move ball upwards
    jmp exit_check

not_bottom_left:
    ; Check bottom-right corner 
    mov al, [x_position]
    cmp al, 79           
    jne not_bottom_right
    mov al, [y_position]
    cmp al, 24          
    jne not_bottom_right

    ; Ball is at the bottom-right corner
    neg byte [x_direction]     ;Reverse horizontal direction
    neg byte [y_direction]     ;Reverse vertical direction
    sub byte [x_position], 1   ;Move slightly away from corner
    sub byte [y_position], 1   ;Move ball upwards
    jmp exit_check

not_bottom_right:
 
    jmp exit_check

exit_check:
ret


speaker_on:

push ax
in al,61h
or al,2
out 61h,al
pop ax
ret


speaker_off:

push ax
in al,61h
or al,11111100b
out 61h,al
pop ax
ret


score_player_left: db 0
score_player_right: db 0

x_position db 40         ; Ball's left/right position (middle of screen)
y_position db 12         ; Ball's up/down position (middle of screen)
x_direction db 1         ; Ball moving right (1 = right, -1 = left)
y_direction db 1         ; Ball moving down (1 = down, -1 = up)





ball_show:

push ax
push bx
push cx
push dx

    mov ah, 0x02        ; BIOS Set Cursor Position
    mov bh, 0x00        ; Page number 
    mov dh, [y_position]; Row 
    mov dl, [x_position]; Column 
    int 0x10            
    ; Write character only
    mov ah, 0x09        ; BIOS Write Character with Attribute
    mov al, 0xDB        ; Character to display
    mov bl, 0x0F         
    mov bh, 0x00        ; Page number
    mov cx, 1           ; Repeat once
    int 0x10    


pop dx
pop cx
pop bx
pop ax 

ret

start:

call clrscr;
call border

mov ax, 80
 ; Starting position of printing line between two players
			push ax
			call centerLine


call intro
call paddleshow_right;
call paddleshow;
call game_loop


terminating_game:
mov ax,0x4c00
int 0x21
