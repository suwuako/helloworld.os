org 0x7c00
bits 16


main:
    mov bx, greet
    call print

print:
    mov al, [bx]
    add bx, 1
    
    cmp al, 0
    je boot

    mov ah, 0x0E
    int 0x10
    jmp print           ; print sigma >:)

boot:
    mov ax, 0x3
    int 0x10            ; set vga text mode 3

    cli
    lgdt [gdt_pointer]  ; load gdt into 32 bit mode
    mov eax, cr0        ; makes the switch to 32 bits
    or eax, 0x1 
    mov cr0, eax
    jmp CODE_SEG:boot2

gdt_start:
    dq 0x0000           ; base: 0 (32 bit)
gdt_code:
    dw 0xFFFF           ; first 32 bits of the limit (limit = 0xffff)
    dw 0x0              ; vvv
    db 0x0              ; first 24 bits of the base
    ; 4 bits for present privillege and type
    ; present: 1 bit
    ; privillige: 2 bit
    ; type: 1 bit
    ; type flags
    db 10011010b

    ; other flags (4 bits long) + last 4 bits of the limit
    db 11001111b

    ; last 8 bits of the base of the limit
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start      ; size of GDT
    dd gdt_start                ; pointer to beginning of GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

[bits 32]
boot2:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

out:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax

halt:
    cli
    hlt

greet:
    db "sigma sigma on the wall, who's the rizzest of them all", 0

times 510 - ($ - $$) db 0
dw 0xAA55
