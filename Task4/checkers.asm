BOARD_SIZE equ 8

section .text
	global checkers

checkers:
	push ebp
	mov ebp, esp
	pusha

	mov eax, [ebp + 8]			; x
	mov ebx, [ebp + 12]    		; y
	mov ecx, [ebp + 16]     	; table

	push ebx                	; Push on stack x coordinate.
	push eax                	; Push on stack y coordinate.

	jmp up_left_neigh

check_coordinate:
	xor eax, eax
	mov edx, [esp + 4]			; Get top of the stack.

	cmp edx, 0					; Compare x/y_coordinate with 0(lower_bound).
	jl out_of_range

	cmp edx, BOARD_SIZE 		; Compare x/y_coordinate with 8(upper_bound).
	jge out_of_range

	inc eax						; Return true(1) -> x/y_coordinate is valid.
	ret

out_of_range:
	xor eax, eax				; Return false(0) -> x/y_coordinate is not valid.
	ret

mark_neigh:
	lea edx, [ecx + 8 * eax]	; Get the offset in the matrix and put 1.
	mov byte [edx + ebx], 1
	ret

up_left_neigh:
	dec eax 					; Get neigh_x value.
	inc ebx						; Get neig_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore					; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore					; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	call mark_neigh				; Mark the new neigh.

restore:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.

up_right_neigh:
	inc eax						; Get neigh_x value.
	inc ebx						; Get neigh_y value.
	
	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_2				; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	inc eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_2				; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	inc eax

	call mark_neigh				; Mark the new neigh.

restore_2:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.
	
down_left_neigh:
	dec eax						; Get neigh_x value.
	dec ebx						; Get neig_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_3				; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_3				; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	call mark_neigh				; Mark the new neigh.

restore_3:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.

down_right_neigh:
	inc eax						; Get neigh_x value.
	dec ebx						; ; Get neig_y value.

	push eax					; Store on stack the value in eax.
	call check_coordinate 		; Check if neigh_x coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_4				; If the neigh_x isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	dec eax

	push ebx					; Store on stack the value in ebx.
	call check_coordinate		; Check if neigh_y coordinate is valid.
	add esp, 4					; Clean the stack.

	cmp eax, 0
	je restore_4				; If the neigh_y isn't valid, we restore the values.

	mov eax, [esp]				; Restore into eax the neigh_x value.
	inc eax

	call mark_neigh				; Mark the new neigh.

restore_4:
	mov eax, [esp] 				; Restore the x value in eax.
	mov ebx, [esp + 4]			; Restore the y value in ebx.

	add esp, 8					; Clean the stack.

	popa
	leave
	ret
