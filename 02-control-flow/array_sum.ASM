format PE Console 4.0

entry start
include 'win32a.inc'

section '.code' code readable executable

start:

mov ebx, my_array ; ebx array pointer
mov ecx, 3 ; loop counter / index
mov edx, 0 ; will hold total number

sum_loop:

add edx, [ebx] ; add data inside of ebx (derefenced) to edx. In C: total += *ebx;
add ebx, 4 ; move four bytes for the next dd

sub ecx, 1 ; decrease 1
cmp ecx, 0 ; check if we hit 0
jne sum_loop ; if not equal to 0 , go back to loop for the next number

push edx ; pass the total sum , sitting in EDX
push format_string
call [printf] ; call printf
add esp, 8 ; clear 8 bytes from stack

call [_getch] ; wait for key
push 0
call [ExitProcess] ; exit with code 0

section '.data' data readable writeable
my_array dd 10, 20, 30 ; sum should be 60
format_string db 'The total sum of the array is: %d', 13, 10, 0

section '.idata' import data readable
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'