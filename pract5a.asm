CODE SEGMENT
    ASSUME cs: CODE
    ORG 256

inicio: jmp gestor

printerror db "Introduce un valor como parámetro.", "$"
DIR_ANT_INT DW ?,?
SEGUNDO DB 0
TICKS DB 0

icode PROC FAR
        sti
        inc [TICKS]
        cmp [TICKS],1
        jnz NORES
        and [SEGUNDO],0
    NORES:
        cmp [TICKS],18
        jnz NOSEG
        inc [SEGUNDO]
        and [TICKS],0
        mov ch, 1
        jmp NOSEG

    NOSEG:
        iret
icode ENDP

gestor:
    mov bl, ds:[80h]
    cmp bl, 0
    je endprogram

    mov ax, ds:[80h + 2]
    cmp ax, "I/"
    jnz salto
    CALL instalador

salto:
    cmp ax, "D/"
    jnz fin
    CALL desinstalador

fin:
    mov ax, 4C00H
    int 21H

endprogram:
    mov ah, 09h
    lea dx, cs:printerror
    int 21H
    mov ax, 4C00H
    int 21H

    mov ax, 4C00H
    int 21H

instalador PROC
    mov ax, 0
    mov es, ax
    mov ax, OFFSET icode
    mov bx, cs
    cli

        mov ax, ds:[1CH*4]
        mov ax, ds:[1CH*4 + 2]

        mov [DIR_ANT_INT],ax
        mov [DIR_ANT_INT+2],dx

        mov ax, OFFSET icode

        mov es:[1Ch*4], ax
        mov es:[1Ch*4+2], bx
    
    sti
    mov dx, offset instalador
    int 27h
instalador ENDP

desinstalador PROC
    push ax bx cx ds es

    mov ah, 49H
    int 21H
    mov es, bx
    int 21H

    cli
        mov ax, es:[DIR_ANT_INT]
        mov dx, es:[DIR_ANT_INT+2]

        mov word ptr ds:[1Ch*4], ax
        mov word ptr ds:[1Ch*4+2], dx
    sti

    pop es ds cx bx ax
    ret
desinstalador ENDP

CODE ENDS
END INICIO