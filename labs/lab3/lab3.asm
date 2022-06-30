section .data

    ; Консольный интерфейс
    inputQ db "input Q:",10
    inputD db "input D:",10
    lenInput equ $-inputD

    res db "Result ",10
    lenRes equ $-res

    ; Сообщения об ошибках
    ErrorZeroMsg db "Division by zero!!",10
    lenZeroMsg equ $-ErrorZeroMsg
    ErrorConvMsg db "Wrong input! Please, try again",10
    lenConvMsg equ $-ErrorConvMsg


section .bss

    InBuf resb 10 ; буфер ввода
    lenIn equ $-InBuf
    OutBuf resb 10          

    Q resw 1
    D resw 1
    F resw 1

section .text

    global _start
    _start:
        ; Считываем Q
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, inputQ ; адрес выводимой строки
        mov rdx, lenInput ; длина строки
        syscall ; вызов системной функции

        mov rax, 0 ; системная функция 0 (read)
        mov rdi, 0 ; дескриптор файла stdin=0
        mov rsi, InBuf    
        mov rdx, lenIn    
        syscall          
        mov esi,InBuf ; закидываем число из буфера в регистр
        call StrToInt64 ; и вызываем функцию преобразования
        cmp EBX, 0 ; проверка кода ошибки
        jne errorConvert ; при преобразовании обнаружена ошибка
        mov [Q],ax ; запись числа в память

        ; Считываем D
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, inputD ; адрес выводимой строки
        mov rdx, lenInput ; длина строки
        syscall ; вызов системной функции

        mov rax, 0
        mov rdi, 0
        mov rsi, InBuf    
        mov rdx, lenIn    
        syscall          
        mov esi,InBuf ; адрес введенной строки
        call StrToInt64
        cmp ebx, 0 ; проверка кода ошибки
        jne errorConvert ; при преобразовании обнаружена ошибка
        mov [D],ax ; запись числа в память

        ; Вычисляем
        mov bx , [Q]
        mov ax , [D]
        mov cx , 5
        sub ax, bx
        imul cx
        cmp bx, 10
        jl else
        mov [F], ax
        jmp correct

    else:
        mov ax, [Q]
        imul ax
        mov bx, [D]
        sub bx, 5
        cmp bx, 0
        je errorZero
        idiv bx
        add ax, [D]
        mov [F], ax
        jmp correct

    correct:
        ; Выводим ответ
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, res ; адрес выводимой строки
        mov rdx, lenRes ; длина строки
        syscall ; вызов системной функции

        mov esi, OutBuf ; загрузка адреса буфера вывода
        mov ax, [F] ; загрузка числа в регистр
        cwde ; развертывание числа из ax в eax
        call IntToStr64

        mov rdx, rax ; длина строки
        mov ax, 1
        mov rdi, 1
        syscall ; вывод ответа
        jmp exit

    errorZero:
        mov rax, 1
        mov rdi, 1
        mov rsi, ErrorZeroMsg
        mov rdx, lenZeroMsg
        syscall
        jmp exit

    errorConvert:
        mov rax, 1
        mov rdi, 1
        mov rsi, ErrorConvMsg
        mov rdx, lenConvMsg 
        syscall
        jmp exit
exit:             
        mov rax, 60 ; системный вызов 60 (exit)
        xor rdi, rdi ; return code 0    
        syscall               

%include "../lib.asm"

