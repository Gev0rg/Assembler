section .data              ; сегмент инициализированных переменных
ExitMsg db "Press Enter to Exit",10  ; выводимое сообщение
lenExit equ $-ExitMsg
A db 9
B db 13
   section .bss               ; сегмент неинициализированных переменных
InBuf   resb    10            ; буфер для вводимой строки
lenIn   equ     $-InBuf
C resb 1 
        section .text         ; сегмент кода
        global  _start
_start: 
        ; write
        mov     eax, [A]
        add     eax, [B]
        mov     [C], eax
        mov     rax, 1        ; системная функция 1 (write)
        mov     rdi, 1        ; дескриптор файла stdout=1
        mov     rsi, ExitMsg  ; адрес выводимой строки
        mov     rdx, lenExit  ; длина строки
        syscall               ; вызов системной функции
        ; read
        mov     rax, 0        ; системная функция 0 (read)
        mov     rdi, 0        ; дескриптор файла stdin=0
        mov     rsi, InBuf    ; адрес вводимой строки
        mov     rdx, lenIn    ; длина строки
        syscall               ; вызов системной функции
        ; exit
        mov     rax, 60       ; системная функция 60 (exit)
        xor     rdi, rdi      ; return code 0    
        syscall               ; вызов системной функции
