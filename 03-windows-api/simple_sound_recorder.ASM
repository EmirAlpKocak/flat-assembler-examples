format PE Console 4.0
entry start

include 'win32w.inc' ; We use win32w for Wide string. Wide strings are supported on Windows 2000 and later operating systems.

section '.idata' import data readable
library kernel32, 'KERNEL32.DLL', \
user32, 'USER32.DLL', \
shell32, 'SHELL32.DLL', \
winmm, 'WINMM.DLL' ; required for mciSendStringW

import kernel32, \
Sleep, 'Sleep', \ ; Sleep
ExitProcess, 'ExitProcess'

import user32, \
MessageBoxW, 'MessageBoxW' ; Wide Messagebox Function

import winmm, \
mciSendStringW, 'mciSendStringW'

section '.data' data readable writeable
duration dd 3000 ; record duration milliseconds. Change this for longer captures.
capturecommand du 'open new type waveaudio alias capture', 0 ; capture command
setquality du 'set capture bitspersample 16 channels 2 samplespersec 44100 bytespersec 176400 alignment 4', 0 ; setting quality
recordcommand du 'record capture', 0 ; record capture
stopcommand du 'stop capture', 0 ; stop capture
savecommand du 'save capture File.wav', 0 ; save capture to file (no path specified, it will saved in the same directory as this program)
closecommand du 'close capture', 0 ; close capture

section '.text' code readable executable
start:
; this is manual push call way of doing it, similar to NASM

push 0 ; NULL
push 0 ; NULL
push 0 ; NULL
push capturecommand ; capture command
call [mciSendStringW] ; send it
push 0
push 0
push 0
push setquality
call [mciSendStringW]
push 0
push 0
push 0
push recordcommand
call [mciSendStringW]
push [duration] ; sleep duration
call [Sleep] ; sleep for recording. When we are sleeping, it will record.
push 0
push 0
push 0
push stopcommand
call [mciSendStringW] ; stop recording
push 0
push 0
push 0
push savecommand
call [mciSendStringW]
push 0
push 0
push 0
push closecommand
call [mciSendStringW]
push 0 ; exit code 0
call [ExitProcess] ; exit

; --- below is more FASM like method, using invoke macro --

;invoke mciSendStringW, capturecommand, NULL, 0, NULL
;invoke mciSendStringW, setquality, NULL, 0, NULL
;invoke mciSendStringW, recordcommand, NULL, 0, NULL
;invoke Sleep, [duration]
;invoke mciSendStringW, stopcommand, NULL, 0, NULL
;invoke mciSendStringW, savecommand, NULL, 0, NULL
;invoke mciSendStringW, closecommand, NULL, 0, NULL
;invoke ExitProcess, 0