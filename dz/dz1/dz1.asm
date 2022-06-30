section .data

    inputNum db "Input number:", 10
    lenInput equ $-inputNum
 
    outputString db "Your string:", 10
    lenOutput equ $-outputString
 
    ;Сообщения об ошибках
    ErrorConvMsg db "Wrong input! Please, try again",10
    lenConvMsg equ $-ErrorConvMsg

    RezBuf times 30 db ' '
    lenRez equ $-RezBuf

    Ent db 10

section .bss

    InBuf resw 10
    lenIn equ $-InBuf

    N resw 1

    Buk resb 1

section .text

    global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, inputNum
    mov rdx, lenInput
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall

    mov esi, InBuf
    call StrToInt64
    cmp ebx, 0
    jne errorConvert

    cmp rax, 0 
    je exit

    mov [N], rax

    mov rcx, [N]
    mov rbx, 1
    mov al, 65
    mov rdx, 0

cycle1:

    cmp rcx, rbx
    jg more
    mov rbx, rcx
    mov rcx, 1
    jmp every

more:
    
    sub rcx, rbx
    inc rcx
    
every:

    push rcx
    mov rcx, rbx

cycle2:

    lea rdi, [RezBuf + rdx]
    stosb
    inc rdx

loop cycle2

    inc rbx
    inc al
    pop rcx

loop cycle1

    mov rdi, 1
    mov rsi, outputString
    mov rdx, lenOutput
    mov rax, 1
    syscall

    mov rdi, 1
    mov rsi, RezBuf
    mov rdx, [N]
    mov rax, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, Ent
    mov rdx, 1
    syscall

    jmp exit

errorConvert:

    mov rax, 1
    mov rdi, 1
    mov rsi, ErrorConvMsg
    mov rdx, lenConvMsg
    syscall
    
exit:

    mov rax, 60 ; системный вызов 60 (exit)
    xor rdi, rdi ; return code 0   
    syscall
 
%include "../lib.asm"