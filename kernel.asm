org 0x7c00
bits 16

mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov si, startup_message
call print_string

main_loop:
  mov si, prompt
  call print_string

  mov di, buffer
  call get_string 

  mov si, buffer
  mov di, cmd_help
  call strcmp
  jc .help

  mov si, bad_command
  call print_string

  jmp main_loop

.help:
  mov si, msg_help
  call print_string
  jmp main_loop


print_string:
  lodsb
  
  or al, al
  jz .done
  
  mov ah, 0x0e
  int 0x10
  jmp print_string

.done:
  ret


get_string:
.loop:
  mov ah, 0
  int 0x16
  
  cmp al, 0x0d
  je .done

  mov ah, 0x0e
  int 0x10
    
  stosb
  jmp .loop

.done:
  mov al, 0
  stosb

  mov ah, 0x0e
  mov al, 0x0d
  int 0x10
  mov al, 0x0a
  int 0x10
  
  ret


strcmp:
.loop:
  mov al, [si]  ; grab a byte from si
  mov bl, [di]  ; grab a byte from di
  cmp al, bl
  jne .notequal

  cmp al, 0
  je .done

  inc di
  inc si
  jmp .loop

.notequal:
  clc  ; clear the carry flak
  ret

.done:
  stc  ; set carry flag
  ret


startup_message db 'Welcome to NelaOS!', 0x0d, 0x0a, 'Try typing help', 0x0d, 0x0a, 0
prompt db '>', 0
bad_command db 'Bad command', 0x0d, 0x0a, 0
cmd_help db 'help', 0
msg_help db 'there is not help', 0x0d, 0x0a, 0
buffer times 64 db 0

times 510-($-$$) db 0
dw 0aa55h
