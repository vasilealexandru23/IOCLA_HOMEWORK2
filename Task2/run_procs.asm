%include "../include/io.mac"

struc avg_out
    .quo: resw 1
    .remain: resw 1

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .data
    counter dw 0

section .text
    global run_procs

run_procs:

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

    mov ecx, [ebp + 8]          ; processes
    mov ebx, [ebp + 12]         ; length
    mov eax, [ebp + 16]         ; proc_avg

    xor esi, esi                ; Initialize the iterator
    inc esi                     ; over the priorities {1, .. 5}.

iterate_over_priorities:
    cmp esi, 5
    jg end_iteration            ; Check if we reached the max priority.

    xor edi, edi                ; Initialize the iterator over the procs.

    xor edx, edx                ; Initialize the sum where we add the times.

    mov edx, [counter]          ; Initialize the counter for the
    xor edx, edx                ; number of procs with the current priority.
    mov [counter], edx

iterate_over_procs:
    cmp edi, ebx
    jge end_second_iteration    ; Check if we itereted over all procs.

    push ebx                    ; Save the date stored in ebx on stack.

    xor ebx, ebx                ; Compute the priority for the current proc.
    mov ebx, edi
    imul ebx, proc_size
    mov bl, [ecx + ebx + proc.prio]

    push ecx                    ; Save the data stored in ecx on stack.

    mov ecx, esi                ; Compare the priorities.
    cmp bl, cl

    pop ecx                     ; Retrieve the data stored in ecx.

    je add_time                 ; If the priorities match,
                                ; we add the time to our counter.

    pop ebx                     ; Retrieve the data stored in ebx.

    inc edi                     ; Increase the iterator.
    jmp iterate_over_procs      ; Continue the loop.

add_time:
    mov ebx, [counter]          ; Increase the number of procs found.
    inc ebx
    mov [counter], ebx

    mov ebx, edi                ; Get the time for the curr proc.
    imul ebx, proc_size
    mov bx, [ecx + ebx + proc.time]

    add edx, ebx                ; Add the time in the sum.

    pop ebx                     ; Restore data in ebx.
    inc edi                     ; Increase the iterator.
    jmp iterate_over_procs      ; Continue the loop.

end_second_iteration:
    push ebx                    ; Save the data stored in this registers on stack.
    push ecx
    push eax

    mov eax, edx
    xor edx, edx
    mov ebx, [counter]
    cmp ebx, 0
    je cant_divide
    div ebx
    mov ecx, eax; aici am quo
    ; PRINTF32 `%u\n\x0`, ecx ; aici am quo
    ; PRINTF32 `%u\n\x0`, edx ; aici am rem
    pop eax

    mov ebx, esi
    dec ebx
    mov [eax + 4 * ebx + avg_out.quo], cx
    mov [eax + 4 * ebx + avg_out.remain], dx

    pop ecx
    pop ebx

    inc esi
    jmp iterate_over_priorities

cant_divide:
    pop eax
    pop ecx
    pop ebx
    inc esi
    jmp iterate_over_priorities

end_iteration:
    popa
    leave
    ret
