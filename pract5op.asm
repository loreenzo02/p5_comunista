;************************************************************************** 
; SBM 2022. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
;************************************************************************** 

DATOS SEGMENT 
    matriz db ?,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0
    stringValue db 10, "Turno jugador ", "$"
    numberValue db 30h, "$"
    timeOut db "(tiempo restante ", "$"
    counter db 31h, 35h, "$"
    finishValue db "):", "$"
DATOS ENDS 

EXTRA SEGMENT 

EXTRA ENDS 

PILA SEGMENT STACK "STACK" 
PILA ENDS


CODE SEGMENT
    ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA

    INICIO PROC
        MOV AX, DATOS 
        MOV DS, AX 
        MOV AX, EXTRA 
        MOV ES, AX 

        mov si, 1
        mov bp, 0
        mov cl, 7
        mov al, 0

        while1:
            mov ah, 2h
            mov dl, '|'
            int 21h
            cmp ds:[matriz + si], 1
            je X
            cmp ds:[matriz + si], 2
            je Y
            mov dl, ' '
            print:
            int 21h
            mov ax, si
            div cl
            cmp ah, 0
            je endline
            jump:
            inc si
            jmp while1

        endline:
            mov ah, 2h
            mov dl, '|'
            int 21h
            cmp bp, 5
            je endprint
            mov dl, 10
            int 21h
            inc bp
            jmp jump

        X:
            mov dl, 'X'
            jmp print

        Y:
            mov dl, 'Y'
            jmp print

        mov bx, 3135h
        endprint:
            cmp ch, 1
            jne endprint

            dec bl
            cmp bx, 3030h ;-> 00
            je addficha
            cmp bl, 29h
            je decrementar
        volver:
            mov counter, bh
            mov counter + 1, bl
            jmp realprint

        decrementar:
            dec bh
            mov bl, 39h
            jmp volver
            
        realprint:
            lea dx, cs:[stringValue]
            mov ah, 09h
            int 21h
            lea dx, cs:[numberValue]
            mov cs:[numberValue], 31h
            mov ah, 09h
            int 21h
            lea dx, cs:[timeOut]
            mov ah, 09h
            int 21h
            lea dx, cs:[counter]
            mov ah, 09h
            int 21h
            lea dx, [finishValue]
            mov ah, 09h
            int 21H

            mov ah, 01h
            int 21h
            cmp al, 0
            jne addficha
            jmp while1

        addficha:

        mov ax, 4C00H
        int 21h
    INICIO ENDP

CODE ENDS 

END INICIO