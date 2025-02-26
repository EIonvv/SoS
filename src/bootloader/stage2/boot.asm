org 0x7C00
bits 16


%define ENDL 0x0D, 0x0A
%define STAGE2_ADDR 0x7D00

stage2_payload:
    ; print hello world message
    mov si, msg_hello_23
    call puts

.halt:
    cli
    hlt

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    or al, al           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si    
    ret

msg_hello_23: db 'Big ole juicy test.', ENDL, 0