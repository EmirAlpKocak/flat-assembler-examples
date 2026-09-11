format PE Console 4.0

entry start
include 'win32a.inc'

section '.code' code readable executable

start:
mov ebx, my_number ; ebx is the pointer variable,  it contains address of the my_number variable , NOT the value like we did on eax

call add_ten ; calling add_ten function declared below

push [my_number] ; [] is deferencing, we should get the value inside of the variable , not the memory address. second argument of printf
push format_string ; First argument of printf.
call [printf] ; call printf
add esp, 8 ; we used two arguments on printf, which takes 4 + 4 = 8 bytes. lets clean them.

call [_getch] ; wait for key
push 0
call [ExitProcess] ; exit properly

add_ten:
mov eax, [ebx] ; derefence address stored in ebx pointer and assign it to eax register
add eax, 10 ; add 10 to eax
mov [ebx], eax ; write it back to [ebx] register
ret ; go back to main code block

section '.data' data readable writeable
my_number dd 5 ; declare my_number variable, with data 5 inside of it.
format_string db 'The value after calling the function is: %d', 13, 10, 0 ; message variable

section '.idata' import data readable
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'
