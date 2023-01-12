global long_mode_start

section .text
bits 64
long_mode_start:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov edi, 0xB8000
    mov rax, 0x0f200f20
    mov ecx, 2000
    rep stosw

    mov dword [0xb8000], 0x2f4b2f4f
    hlt
    jmp $