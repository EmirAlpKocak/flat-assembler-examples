format PE Console 4.0
entry start
include 'win32a.inc'

section '.code' code readable executable

start:
        mov     eax, 13      ; Try changing this to a different number to trigger the else block

        ; IF
        cmp     eax, 13      ; Compare the value in EAX against 13
        je      is_equal     ; JE = "Jump if Equal". If EAX == 13, run 'is_equal:'

        ; ELSE
        ; This code executes ONLY if the jump above did NOT happen.
        push    not_13_msg   ; Push the "Not 13" string address
        call    [printf]
        add     esp, 4       ; Clean 4 bytes (we only pushed 1 argument this time)
        jmp     end_of_if    ; CRITICAL: Jump completely over the IF block so they don't collide!

  is_equal:
        push    is_13_msg    ; Push the "Is 13" string address
        call    [printf]
        add     esp, 4       ; Clean 4 bytes

  end_of_if:
        ; Both branches meet back up here to finish cleanly
        call    [_getch] ; Waits for a key to keep the console open.
        push    0
        call    [ExitProcess] ; Exits cleanly with 0 code.

section '.data' data readable writeable
        is_13_msg  db 'The number is exactly 13!', 13, 10, 0
        not_13_msg db 'The number is NOT 13!', 13, 10, 0

section '.idata' import data readable
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'
