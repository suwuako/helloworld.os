[org 0x7c00]
[bits 16]

mov ah, 0x0e
mov bx, msg
mov cl, 0

print:
    mov al, [bx]
    int 0x10
    inc bx

    cmp al, cl
    je read_disk
    jmp print

read_disk:
    jmp done

done:
    cli
    hlt

msg: 
    db "Hello world?", 0

times 510 - ($ - $$) db 0
dw 0xAA55
