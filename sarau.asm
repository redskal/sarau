;                          -=[    Sarau     ]=-
;                          -=[     by       ]=-
;                          -=[   Red Skäl   ]=-

; This was coded circa 2010 - probably before that. At the time I couldn't
; find an open-source log cleaner for Windows. I decided to write this
; simple little piece of code.

; As it's written in asm it's fairly compact (1650 bytes EXE). Or as
; compact as my messy coding can get it anyway. There is no visual feedback
; from it. I may change that if I ever decide to rework this.

;    > nasmw -fwin32 tinywipe.asm
;    > alink tinywipe.obj win32.lib -entry _start -subsys win -oPE
; You need to enable the write bit on the code segment for this to run.

; * RUN AS ADMIN *
; Tested successfully on Vista (32bit) and Win10 (64bit)

      [bits 32]
      [extern LoadLibraryA]
      [extern GetProcAddress]
      [section fuck_you code use32]
      [global _start]

; read as...
; ReadEventLog(hLog,EVENTLOG_FORWARDS_READ|EVENTLOG_SEQUENTIAL_READ,0,evtlogrec,sizeof(buff),(int)read,(int)needed);

_start:
       push szDLL
       call LoadLibraryA
       mov [hAdvapi32], eax
       
       push szOEL
       push eax                        ; eax = advapi32.dll handle
       call GetProcAddress
       mov dword [OpenEventLog], eax

       push szClEL
       push dword [hAdvapi32]
       call GetProcAddress
       mov dword [ClearEventLog], eax

       push szCEL
       push dword [hAdvapi32]
       call GetProcAddress
       mov dword [CloseEventLog], eax

       cld
       mov esi, dword pNames

 .main_loop:
       lodsd
       cmp dword eax, 0
       je .exit
       
 .open_log:
       push eax
       push 0
       call dword [OpenEventLog]
       mov dword [hFile], eax

 .clear_log:
       push 0
       push eax
       ;push 0
       call dword [ClearEventLog]
 
 .close_log:
       push dword [hFile]
       call dword [CloseEventLog]
       jmp .main_loop
 
 .exit:
       ret
data:
       szApp      db           "Application",0
       szSec      db           "Security",0
       szSys      db           "System",0
       pNames     dd           szApp
                  dd           szSec
                  dd           szSys
                  dd           0
       szDLL      db           "advapi32.dll",0
       szOEL      db           "OpenEventLogA",0
       szClEL     db           "ClearEventLogA",0
       szCEL      db           "CloseEventLog",0
       hAdvapi32       dd      0
       OpenEventLog    dd      0
       ClearEventLog   dd      0
       CloseEventLog   dd      0
       hFile           dd      0
end: