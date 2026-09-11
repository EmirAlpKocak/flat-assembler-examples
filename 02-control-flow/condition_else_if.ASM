format PE Console 4.0
entry start
include 'win32a.inc'

section '.code' code readable executable

start:
        mov     eax, 20 ; try changing this for other results

        ; IF CHECK
        cmp     eax, 13
        je      is_equal_13  ; If EAX == 13, jump to 13 block

       ; ELSE IF CHECK
        cmp     eax, 20      ; If it wasn't 13, CPU falls here. Is it 20?
        je      is_equal_20  ; If EAX == 20, jump to 20 block

        ; ELSE
        ; Runs if BOTH checks above failed.
        push    something_else_msg
        call    [printf]
        add     esp, 4
        jmp     end_of_all   ; Jump to the end to skip the target blocks below

  is_equal_13:
        push    is_13_msg
        call    [printf]
        add     esp, 4
        jmp     end_of_all   ; Prevent running the next label!

  is_equal_20:
        push    is_20_msg
        call    [printf]
        add     esp, 4
        ; No 'jmp' needed here because the next line naturally flows into end_of_all

  end_of_all:
        call    [_getch] ; wait For key
        push    0
        call    [ExitProcess] ; Exit with code 0.

section '.data' data readable writeable
        is_13_msg          db 'The number is exactly 13!', 13, 10, 0
        is_20_msg          db 'The number is exactly 20!', 13, 10, 0
        something_else_msg db 'The number is something else entirely!', 13, 10, 0

section '.idata' import data readable
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'
