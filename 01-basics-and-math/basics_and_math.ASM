format PE Console 4.0 ; PE Format Console Program
entry start
include 'win32a.inc' ; Windows 32 API Ascii

section '.code' code readable executable ; code section

start:
        mov     eax, 10 ; assing 10 to eax register
        add     eax, 5  ; add 5 to eax
        sub     eax, 2  ; subtract 2 from eax

        ; --- MEMORY MANAGEMENT ---
        ; Brackets [] mean "dereference" / "look inside the address"
        ; This writes the value 13 from EAX into our RAM variable
        mov     [my_variable], eax  

        ; --- FUNCTION CALL ---
        ; Arguments are passed onto the stack BACKWARD (Right to Left)
        push    [my_variable]       ; Second Argument: The value inside our variable (13)
        push    format_string       ; First Argument: The memory address of our text string
        call    [printf]            ; Call printf function from msvcrt.dll
        
        ; Clean up the stack - We pushed two 4 byte arguments 4 + 4 = 8 bytes total
        add     esp, 8              

        call    [_getch]            ; Wait for keypress so command prompt stays open
        push    0                   ; Exit code 0 (Success)
        call    [ExitProcess]       ; call ExitProcess from Windows api to exit

section '.data' data readable writeable
        ; 'dd' = Define Doubleword (4 bytes, like a standard C 'int')
        my_variable dd 0           
        
        ; 'db' = Define Byte (used for strings. 13 = \r, 10 = \n, 0 = \0 null terminator)
        format_string db 'The result of our math is: %d', 13, 10, 0 

section '.idata' import data readable ; Import required functions
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'
