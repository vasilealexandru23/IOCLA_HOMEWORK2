%include "../include/io.mac"

section .text
    global simple

simple:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]          ; len
    mov     esi, [ebp + 12]         ; plain
    mov     edi, [ebp + 16]         ; enc_string
    mov     edx, [ebp + 20]         ; step

    xor eax, eax                    ; Initialize iterator.
iterate_chars:
    cmp eax, ecx
    je iterate_done                 ; Check if we iterated over all chars.

    xor bl, bl                      ; Clean register.

    mov bl, byte [esi + eax]        ; Get plain[iter].

    add bl, dl                      ; Shift right, build enc_string[iter].

    cmp bl, 'Z'                     ; Check for overflow.
    jg overflow

    mov byte [edi + eax], bl        ; Initialize enc_string[iter].

    inc eax                         ; Increase iter.

    jmp iterate_chars               ; Continue the for loop.

overflow:
    sub bl, 26                      ; Get back into the alphabet.
    mov byte [edi + eax], bl        ; Get new value in enc_string.

    inc eax                         ; Increase iterator.
    jmp iterate_chars               ; Continue the loop.

iterate_done:                       ; We iterated over all chars.

    popa
    leave
    ret
