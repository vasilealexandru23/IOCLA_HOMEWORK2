BOARD_SIZE equ 8

section .text
    global bonus

bonus:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	        ; x
    mov ebx, [ebp + 12]	        ; y
    mov ecx, [ebp + 16]         ; board

    push ecx                    ; Push on stack the address of the board.
    push ebx                    ; Push on stack y coordinate.
    push eax                    ; Push on stack x coordinate.

    jmp up_left_neigh           ; Verify first neigh.

compute_power_2:                ; Function that returns 2 ^ [edx].
    add eax, eax                ; Double the counter.
    dec edx                     ; Decrement power.
    jnz compute_power_2         ; Continue the loop.
    ret

check_overflow:
    add ecx, 4                  ; Go to the address of board[1].
    cmp edx, 32                 ; Compare the bit with the board[0/1].
    jl exit
    sub edx, 32                 ; Get the right bit for the board[0].
    sub ecx, 4                  ; Get back the address of board[0].

exit:
    ret

check_coordinate:
    xor eax, eax
    mov edx, [esp + 4]          ; Get top of the stack, the coordinate to check.

    cmp edx, 0                  ; Compare x/y_coordinate with 0(lower_bound).
    jl out_of_range

    cmp edx, BOARD_SIZE         ; Compare x/y_coordinate with 8 (upper_bound).
    jge out_of_range

    inc eax                     ; Return true(1) -> x/y_coordinate is valid.
    ret

out_of_range:
    xor eax, eax                ; Return false(0) -> x/y_coordinate is not valid.
    ret

mark_neigh:
    lea edx, [8 * eax + ebx]    ; Get the offset in the matrix

    call check_overflow         ; Check if neigh is in board[0] or board[1].

    mov eax, 1                  ; Compute 2 ^ [edx], stored in eax.
    call compute_power_2

    add [ecx], eax              ; Mark 1 in the "matrix".
    ret

up_left_neigh:
	dec eax 					; Get neigh_x value.
	inc ebx						; Get neig_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

    cmp eax, 0
	je restore_1_neigh			; If the neigh_x isn't valid, we restore the values.


    mov eax, [esp]				; restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_1_neigh			; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; restore into eax the neigh_x value.
	dec eax

	call mark_neigh				; Mark the new neigh.

restore_1_neigh:
    mov eax, [esp]              ; Restore the x value in eax.
    mov ebx, [esp + 4]          ; Restore the y value in ebx.
    mov ecx, [esp + 8]          ; Restore the address of the board.

up_right_neigh:
    inc eax						; Get neigh_x value.
	inc ebx						; Get neigh_y value.
	
	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.
	cmp eax, 0
	je restore_2_neigh			; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Eestore into eax the neigh_x value.
	inc eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_2_neigh			; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	inc eax

	call mark_neigh				; Mark the new neigh.

restore_2_neigh:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx
    mov ecx, [esp + 8]          ; Restore the address of the board.
    
down_left_neigh:
	dec eax						; Get neigh_x value.
	dec ebx						; Get neig_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_3_neigh			; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_3_neigh			; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	call mark_neigh				; Mark the new neigh.

restore_3_neigh:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.
    mov ecx, [esp + 8]          ; Restore the address of the board.

down_right_neigh:
	inc eax						; Get neigh_x value.
	dec ebx						; Get neigh_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_4_neigh			; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_4_neigh			; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	inc eax

	call mark_neigh				; Mark the new neigh.

restore_4_neigh:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.
    mov ecx, [esp + 8]          ; Restore the address of the board.

    add esp, 12                 ; Clean the stack.

    popa
    leave
    ret