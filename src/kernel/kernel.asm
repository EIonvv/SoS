org 0x7C00
bits 16

start:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    
    cld
    mov si, msg_hello
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

msg_hello db 'Hello, World!', 0xD, 0xA, 0

times 510 - ($-$$) db 0
dw 0xAA55