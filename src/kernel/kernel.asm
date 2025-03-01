org 0x0
bits 16


%define ENDL 0x0D, 0x0A
start:
    ; print hello world message
    mov si, msg_hello_kernel
    call puts

    ; jmp to main 

    mov ax, 0x7C00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00              ; stack grows downwards from where we are loaded in memory
    
    ; setup stack
    mov ss, ax
    mov sp, 0x7C00              ; stack grows downwards from where we are loaded in memory
    ; print hello world message
    mov si, msg_hello_kernel
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

    ; jmp to 
    ret

msg_hello_kernel: db 'Hello world from KERNEL!', ENDL, 0
