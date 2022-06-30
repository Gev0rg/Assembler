section .data

    ;Перенос строки для красивого вывода матрицы
    
    Ent db 10 

    ;Консольныф интерфейс

    inputMatr db "Input matrix(4*6) elements:", 10
    lenInput equ $-inputMatr

    outputMatr db "Your matrix:", 10
    lenOutput equ $-outputMatr

    sum db "Sum of column elements:", 10
    lenSum equ $-sum

    ;Сообщения об ошибках
    ErrorConvMsg db "Wrong input! Please, try again",10
    lenConvMsg equ $-ErrorConvMsg

section .bss

    matrix resw 24

    InBuf resw 10
    lenIn equ $-InBuf

    OutBuf resw 10

section .text

    global _start
    _start:

        ;Ввод массива

        mov rax, 1
        mov rdi, 1
        mov rsi, inputMatr
        mov rdx, lenInput
        syscall

        mov rcx, 24
        mov rbx, 0

        cycleInput:

            push rcx
            push rbx

            mov rax, 0
            mov rdi, 0
            mov rsi, InBuf
            mov rdx, lenIn
            syscall

            mov esi, InBuf
            call StrToInt64
            cmp ebx, 0
            jne errorConvert

            pop rbx
            pop rcx

            mov [matrix + rbx*2], eax

            inc rbx

        loop cycleInput

        ;Вывод массива

        mov rax, 1
        mov rdi, 1
        mov rsi, outputMatr
        mov rdx, lenOutput
        syscall

        mov rcx, 4
        mov rbx, 0

        cycleOutput0:

            push rcx

            mov rcx, 6

            cycleOutput1:

                mov eax, [matrix + rbx*2]
                mov esi, OutBuf

                push rcx
                push rbx

                call IntToStr64

                mov rdx, rax
                mov rax, 1
                mov rdi, 1
                mov rsi, OutBuf
                syscall

                pop rbx
                pop rcx

                inc rbx 

            loop cycleOutput1
            
            mov rax, 1
            mov rdi, 1
            mov rsi, Ent
            mov rdx, 1
            syscall

            pop rcx

        loop cycleOutput0

        ;Вывод суммы элементов каждого столбца

        mov rax, 1
        mov rdi, 1
        mov rsi, sum
        mov rdx, lenSum
        syscall

        mov rcx, 6
        mov rbx, 0

        cycleSum0:

            push rcx
            push rbx

            mov rax, 0
            mov rcx, 4

            cycleSum1:

                add eax, [matrix + rbx]
                add rbx, 12

            loop cycleSum1

            mov esi, OutBuf
            call IntToStr64

            mov rdx, rax
            mov rax, 1
            mov rdi, 1
            mov rsi, OutBuf
            syscall

            pop rbx
            add rbx, 2
            pop rcx

        loop cycleSum0

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

%include "../lib2.asm"