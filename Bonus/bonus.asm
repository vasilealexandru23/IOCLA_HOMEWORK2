section .text
    global bonus

bonus:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	        ; x
    mov ebx, [ebp + 12]	        ; y
    mov ecx, [ebp + 16]         ; board

    push ecx
    push ebx
    push eax

    jmp up_left_neigh

; Function that returns 2 ^ [edx].
compute_power_2:
    add eax, eax
    dec edx
    jnz compute_power_2
    ret

check_overflow:
    mov edx, [esp + 4]
    add ecx, 4
    cmp edx, 32
    jl exit
    sub edx, 32
    sub ecx, 4

exit:
    ret

check_coordinate:
    xor eax, eax
    ; Get top of the stack
    mov edx, [esp + 4]

    ; Compare x/y_coordinate with 0(lower_bound).
    cmp edx, 0
    jl out_of_range

    ; Compare x/y_coordinate with 8 (upper_bound).
    cmp edx, 8
    jge out_of_range

    ; Return true(1) -> x/y_coordinate is valid.
    inc eax
    ret

out_of_range:
    ; Return false(0) -> x/y_coordinate is not valid.
    xor eax, eax
    ret

mark_neigh:
    ; Get the offset in the matrix
    lea edx, [8 * eax + ebx]

    ; Check if neigh is in board[0] or board[1].
    push edx
    call check_overflow
    add esp, 4

    ; Compute 2 ^ [edx].
    mov eax, 1
    push edx
    call compute_power_2
    add esp, 4

    ; Mark 1 in the "matrix".
    add [ecx], eax
    ret

up_left_neigh:
    ; Get new_x value.
    dec eax
    ; Get new_y value.
    inc ebx

    ; Check if new_x coordinate is valid.
    push eax
    call check_coordinate
    add esp, 4

    ; If the new_x isn't valid, we restore the values.
    cmp eax, 0
    je restore

    ; Restore into eax the new_x value.
    mov eax, [esp]
    dec eax

    ; Check if new_y coordinate is valid.
    push ebx
    call check_coordinate
    add esp, 4

    ; If the new_y isn't valid, we restore the values.
    cmp eax, 0
    je restore

    ; Restore into eax the new_x value.
    mov eax, [esp]
    dec eax

    ; Mark the new neigh.
    call mark_neigh

restore:
    ; Restore the values in registers of the initial position in the matrix.
    mov eax, [esp]
    mov ebx, [esp + 4]
    mov ecx, [esp + 8]

up_right_neigh:
    ; Get new_x value.
    inc eax
    ; Get new_y value.
    inc ebx
    
    ; Check if new_x coordinate is valid.
    push eax
    call check_coordinate
    add esp, 4

    ; If the new_x isn't valid, we restore the values.
    cmp eax, 0
    je restore_2

    ; Restore into eax the new_x value.
    mov eax, [esp]
    inc eax

    ; Check if new_y coordinate is valid.
    push ebx
    call check_coordinate
    add esp, 4

    ; If the new_y isn't valid, we restore the values.
    cmp eax, 0
    je restore_2

    ; Restore into eax the new_x value.
    mov eax, [esp]
    inc eax

    ; Mark the new neigh.
    call mark_neigh

restore_2:
    ; Restore the values in registers of the initial position in the matrix.
    mov eax, [esp]
    mov ebx, [esp + 4]
    mov ecx, [esp + 8]
    
down_left_neigh:
    ; Get new_x value.
    dec eax
    ; Get new_y value.
    dec ebx

    ; Check if new_x coordinate is valid.
    push eax
    call check_coordinate
    add esp, 4

    ; If the new_x isn't valid, we restore the values.
    cmp eax, 0
    je restore_3

    ; Restore into eax the new_x value.
    mov eax, [esp]
    dec eax

    ; Check if new_y coordinate is valid.
    push ebx
    call check_coordinate
    add esp, 4

    ; If the new_y isn't valid, we restore the values.
    cmp eax, 0
    je restore_3

    ; Restore into eax the new_x value.
    mov eax, [esp]
    dec eax

    ; Mark the new neigh.
    call mark_neigh

restore_3:
    ; Restore the values in registers of the initial position in the matrix.
    mov eax, [esp]
    mov ebx, [esp + 4]
    mov ecx, [esp + 8]

down_right_neigh:
    ; Get new_x value.
    inc eax
    ; Get new_y value.
    dec ebx

    ; Check if new_x coordinate is valid.
    push eax
    call check_coordinate
    add esp, 4

    ; If the new_x isn't valid, we restore the values.
    cmp eax, 0
    je restore_4

    ; Restore into eax the new_x value.
    mov eax, [esp]
    inc eax

    ; Check if new_y coordinate is valid.
    push ebx
    call check_coordinate
    add esp, 4

    ; If the new_y isn't valid, we restore the values.
    cmp eax, 0
    je restore_4

    ; Restore into eax the new_x value.
    mov eax, [esp]
    inc eax

    ; Mark the new neigh.
    call mark_neigh

restore_4:
    ; Restore the values in registers of the initial position in the matrix.
    mov eax, [esp]
    mov ebx, [esp + 4]
    mov ecx, [esp + 8] 

    ; Clean the stack.
    add esp, 12


    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
