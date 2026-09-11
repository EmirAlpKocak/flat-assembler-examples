format PE Gui 4.0

include 'win32ax.inc'

entry start

start:
; Here, we are using invoke macro in FASM for calling it easier, like we do on C.
; You can also use push call for it. It is like more "NASM" style.
invoke MessageBoxW, NULL, _confirmationmessagew, _titlew, MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2
cmp eax, IDYES ; Compare EAX to IDYES.
je handle_yes ; Jump if user clicked yes (returns IDYES)

jmp exit_app

handle_yes: ; code block for handling yes
invoke ShellExecuteW, NULL, _executionoperationw, _filepathw, NULL, NULL, 1 ; We are using ShellExecuteW from Windows API. "1" for SW_NORMAL
cmp eax, 32 ; Compare EAX to 32. If not 32, ShellExecuteW failed!
jbe handle_shellexecute_error ; error handler
jmp exit_app ; DONT FORGET TO EXIT, ELSE YOU WILL ALWAYS SEE THE ERROR MESSAGE

handle_shellexecute_error:
invoke MessageBoxW, NULL, _error1, _errortitle, MB_OK + MB_ICONERROR ; Error message box

exit_app:
invoke ExitProcess, 0


section '.data' data readable writeable
_confirmationmessagew du 'Are you sure you want to run this program?', 0 ; Confirmation message
_titlew du 'Example Program', 0 ; MessageBox title
_executionoperationw du 'runas', 0 ; This is the operation. "runas" runs as admin.
_filepathw du 'cmd.exe', 0 ; Program to run
; ----------------- error messages -----------;
_error1 du 'Unable to open cmd.exe!', 0
_errortitle du 'Application Error', 0


section '.idata' import data readable
library user32, 'USER32.DLL', \
kernel32, 'KERNEL32.DLL', \
shell32, 'SHELL32.DLL'

import user32, \
MessageBoxW, 'MessageBoxW'
import kernel32, \
ExitProcess, 'ExitProcess'
import shell32, \
ShellExecuteW, 'ShellExecuteW'
