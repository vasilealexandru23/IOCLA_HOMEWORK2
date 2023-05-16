struc proc
	.pid: resw 1
	.prio: resb 1
	.time: resw 1
endstruc

section .text
	global sort_procs

section .data

sort_procs:
	enter 0,0
	pusha

	mov edx, [ebp + 8]      		; processes
	mov eax, [ebp + 12]     		; length

	; The sort algorithm used is Bubble Sort.

	xor esi, esi					; Initialize first iterator with 0.

iterate_procs_1:
	cmp esi, eax					; Check if we have iterated through all elements.
	jge end_iteration

	mov edi, esi					; Initialize second iterator and begin second loop.
	jmp iterate_procs_2

iterate_procs_2:
	inc edi							; Increment second iterator.
	cmp edi, eax					; Check if we reached the end of vector.
	jge end_iteration_2

	mov ecx, esi					; Compute proc[iterator1].prio. 
	imul ecx, proc_size
	push ecx						; Save the offset on stack.
	mov cl, [edx + ecx + proc.prio]

	mov ebx, edi					; Compute proc[iterator2].prio.
	imul ebx, proc_size
	push ebx						; Save the offset on stack.
	mov bl, [edx + ebx + proc.prio]

	cmp cl, bl						; Check proc[iterator1].prio > proc[iterator2].prio and
	jg swap_struct					; if that's the case we swap the structs elements one by one.
	jg swap_struct
	
	je check_time					; Check proc[iterator1].prio == proc[iterator2].prio and than
									; check for the time condition and swap de structs elements. 

	add esp, 8						; Clean the stack.
	jmp iterate_procs_2				; Continue the loop.

check_time:
	mov ecx, [esp + 4]				; Compute proc[iterator1].time.
	mov cx, [edx + ecx + proc.time]

	mov ebx, [esp]					; Compute proc[iterator2].time.
	mov bx, [edx + ebx + proc.time]

	cmp ecx, ebx					; Check proc[iterator1].time > proc[iterator2].time and
	jg swap_struct					; if that's the case we swap the structs elements one by one.

	je check_id						; Check proc[iterator1].time == proc[iterator2].time and
									; than check for the id condition and swap de structs elements.

	add esp, 8						; Clean the stack.
	jmp iterate_procs_2				; Continue the loop.

check_id:
	mov ecx, [esp + 4]				; Compute proc[iterator1].pid.
	mov cx, [edx + ecx + proc.pid]

	mov ebx, [esp]					; Compute proc[iterator2].pid.
	mov bx, [edx + ebx + proc.pid]

	cmp ecx, ebx					; Check proc[iterator1].id > proc[iterator2].id and
	jg swap_struct					; if that's the case we swap the structs elements one by one.

	add esp, 8						; Clean the stack.
	jmp iterate_procs_2				; Continue the loop.

swap_struct:
	mov ecx, [esp + 4]				; Restore the precomputed offset.
	mov ebx, [esp]

	push eax						; Save the values on stack.
	push edi
	push esi
	
	mov ax, [edx + ecx]				; Swap proc[iterator1].id, proc[iterator2].id .
	push eax
	mov ax, [edx + ebx]
	mov [edx + ecx + proc.pid], ax
	pop eax
	mov [edx + ebx + proc.pid], ax
	
	mov al, [edx + ecx + proc.prio]	; Swap proc[iterator1].prio, proc[iterator2].prio .
	push eax
	mov al, [edx + ebx + proc.prio]
	mov [edx + ecx + proc.prio], al
	pop eax
	mov [edx + ebx + proc.prio], al

	mov ax, [edx + ecx + proc.time]	; Swap proc[iterator1].time, proc[iterator2].time .
	push eax
	mov ax, [edx + ebx + proc.time]
	mov [edx + ecx + proc.time], ax
	pop eax
	mov [edx + ebx + proc.time], ax

	pop esi							; Get the old values that we saved on stack.
	pop edi
	pop eax

	add esp, 8						; Clean the stack.
	jmp iterate_procs_2				; Continue the loop.

end_iteration_2:
	inc esi							; Increment first iterator
	jmp iterate_procs_1				; and continue the iteration.

end_iteration:						; We iterated over all elements.
	
	popa
	leave
	ret