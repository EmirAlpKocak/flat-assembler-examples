format PE Console 4.0

entry start
include 'win32a.inc'

section '.code' code readable executable

start:
mov ebx, my_array ; add my_array memory address to ebx
mov ecx, 3 ; loop counter like int i index in C

array_loop:
push ecx ; save loop counter to stack
push ebx ; save pointer to array to the stack

mov eax, [ebx] ; derefence pointer to array to get current array slot data
push eax ; push the value to printf second argument
push format_string ; push to printf first argument

call [printf] ; call printf
add esp, 8 ; clean 8 bytes 4 + 4 = 8

; NEXT ITEM HERE
pop ebx ; restore our array pointer from stack (formerly: push ebx)
add ebx, 4 ; move the pointer forward by 4 bytes for getting the next 'dd' variable

pop ecx ; restore the loop counter aka index
sub ecx, 1 ; decrease the counter by one
cmp ecx, 0 ; check if the counter is ended (equal to zero)
jne array_loop ; jump if not equal , go to start of array_loop.

call [_getch] ; call get character so terminal does not close
push 0
call [ExitProcess] ; exit with error code 0 (success)

section '.data' data readable writeable
my_array dd 10, 20, 30 ; declare an array with three double words : 4 bytes each 4 * 3 = 12 total
format_string db 'Array item: %d', 13, 10, 0

section '.idata' import data readable
        library kernel32,'KERNEL32.DLL',\
                msvcrt,'MSVCRT.DLL'

        import kernel32, ExitProcess,'ExitProcess'
        import msvcrt, printf,'printf', _getch,'_getch'
