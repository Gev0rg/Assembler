    global _Z8printASMPci
    global _Z10numwordASMPci

section .text

   _Z10numwordASMPci:
            ; пролог
        push    RBP
        mov     RBP, RSP
        push    RCX
    ;сохранение переданных параметров по порядку в стек
        push    RDI ;строка
        push    RSI ;длина строки
        mov RCX, RSI
        mov AL, " "
        mov RBX, 0
    
    cycle:

        scasb
        jnz no
        inc RBX

    no:

        loop cycle

    inc RBX
    mov RAX, RBX

    ExitBlock1:
        pop    RSI
        pop    RDI
        pop    RCX
        mov    RBP, RSP
        pop    RBP
        ret

    _Z8printASMPci:
        ; пролог
        push    RBP
        mov     RBP, RSP
        push    RCX
        push    RAX
    ;сохранение переданных параметров по порядку в стек
        push    RDI
        push    RSI

    ;вывод
        mov RAX, RSI ; size of string
        mov     RSI, RDI
        mov     RDX, RAX
        mov     RAX, 1
        mov     RDI, 1
        syscall

    ; print '\n'
        mov RAX, 10
        push RAX

        lea     RSI, [RSP]
        mov     RDX, 1
        mov     RAX, 1
        mov     RDI, 1
        syscall

        pop RAX

    ExitBlock2:
        pop    RSI
        pop    RDI
        pop    RAX
        pop    RCX
        mov    RBP, RSP
        pop    RBP
        ret