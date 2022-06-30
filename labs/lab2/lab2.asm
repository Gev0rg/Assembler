section .data
    ; Консольный интерфейс
    inputA db "input A:",10
    inputX db "input X:",10
    inputC db "input C:",10
    lenInput equ $-inputC

    res db "Result ",10
    lenRes equ $-res

    ; Сообщения об ошибках
    ErrorConvMsg db "Wrong input! Please, try again",10
    lenConvMsg equ $-ErrorConvMsg

section .bss

    InBuf resb 10 ; буфер ввода
    lenIn equ $-InBuf 
    A resw 1
    X resw 1
    C resw 1

    F resw 1           
    OutBuf resb 10          
        
section .text 

    global  _start
    _start:
        ; Считываем А
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, inputA ; адрес выводимой строки
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
        mov [A],ax ; запись числа в память

        ; Считываем X
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, inputX ; адрес выводимой строки
        mov rdx, lenInput ; длина строки
        syscall ; вызов системной функции

        mov rax, 0
        mov rdi, 0
        mov rsi, InBuf    
        mov rdx, lenIn    
        syscall          
        mov esi,InBuf ; адрес введенной строки
        call StrToInt64
        cmp EBX, 0 ; проверка кода ошибки
        jne errorConvert ; при преобразовании обнаружена ошибка
        mov [X], ax ; запись числа в память

        ; Считываем C
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, inputC ; адрес выводимой строки
        mov rdx, lenInput ; длина строки
        syscall ; вызов системной функции

        mov rax, 0
        mov rdi, 0
        mov rsi, InBuf    
        mov rdx, lenIn    
        syscall          
        mov esi,InBuf ; адрес введенной строки
        call StrToInt64
        cmp EBX, 0 ; проверка кода ошибки
        jne errorConvert ; при преобразовании обнаружена ошибка
        mov [C],ax ; запись числа в память

        ; Проводим вычисления
        mov ax, [X]
        add ax, 3
        imul byte [C]
        mov cx, ax
        mov ax, [A]
        imul byte [A]
        imul byte [A]
        mov bx, 3
        cwd
        idiv bx
        sub ax, cx
        mov [F], ax
        jmp correct

    errorConvert:
        mov rax, 1 ; системная функция 1 (write)
        mov rdi, 1 ; дескриптор файла stdout=1
        mov rsi, ErrorConvMsg ; адрес выводимой строки
        mov rdx, lenConvMsg ; длина строки
        syscall ; вызов системной функции
        jmp exit

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
    
    exit:             
        mov rax, 60 ; системный вызов 60 (exit)
        xor rdi, rdi ; return code 0    
        syscall               

%include "../lib.asm"