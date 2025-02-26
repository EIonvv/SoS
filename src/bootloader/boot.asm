org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fats:                   db 2
bdb_root_entries:           dw 0E0h
bdb_total_sectors:          dw 2880         ; 1.44MB
bdb_media_descriptor:       db 0F0h
bdb_sectors_per_fat:        dw 9
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:        dd 0
bdb_large_sector_count:      dd 0

ebr_drive_number:           db 0
                            db 0
ebr_signature:            db 29h
ebr_volume_id:            dd 12h, 34h, 56h, 78h
ebr_volume_label:         db 'NO NAME    '
ebr_file_system_type:     db 'FAT12   '


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
    push si
    push ax
    push bx

.loop:
    lodsb                      ; Load byte at DS:SI into AL and increment SI
    or al, al                  ; Check if AL is zero (end of string) 
    jz .done
    
    mov ah, 0x0E               ; Call bios interrupt 0x10 to print character
    mov bx, 0                  ; Set page number to 0
    int 0x10
    
    jmp .loop

.done:
    pop bx
    pop ax
    ret

msg_hello db 'Hello, World!', ENDL, 0

times 510 - ($-$$) db 0
dw 0xAA55