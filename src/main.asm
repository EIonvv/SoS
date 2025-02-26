org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

main:
    ; setup data segments
    mov ax, 0           ; can't set ds/es directly
    mov ds, ax
    mov es, ax
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00              ; stack grows downwards from where we are loaded in memory

    ; print hello world message
    mov si, msg_hello_kernel
    call puts
    
.hlt:
    cli
    hlt
    jmp .hlt

puts:
    push ax
    push bx

.loop:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    mov bx, 0
    int 0x10
    jmp .loop

.done:
    pop bx
    pop ax
    ret

times 510 - ($-$$) db 0
dw 0xAA55