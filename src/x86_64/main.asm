global start
extern long_mode_start

section .text
bits 32

start:
    mov esp, stack_top

    call check_multiboot
    call check_cpuid_support
    call check_long_mode_support

    call setup_paging

    lgdt [gdt64.pointer]
    jmp long_mode_start

check_multiboot:
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret
.no_multiboot:
    mov al, 'M' ; multiboot error code
    jmp error

check_cpuid_support:
    pushfd
    pop eax
    mov ecx, eax

    xor eax, 1<<21
    
    push eax
    popfd

    pushfd
    pop eax

    push ecx 
    popfd

    cmp ecx, eax
    jz .no_cpuid

    ret
.no_cpuid:
    mov al, 'C' ; cpuid error code
    jmp error

check_long_mode_support:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode

    mov eax, 0x80000001
    cpuid
    cmp eax, edx
    jz .no_long_mode

    ret
.no_long_mode:
    mov al, 'L' ; long mode error code
    jmp error

setup_paging:
    ; disable old paging
    mov eax, cr0
    and eax, 0<<31
    mov cr0, eax

    ; clear the tables
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, cr3

    mov dword [edi], 0x2003
    add edi, 0x1000
    mov dword [edi], 0x3003
    add edi, 0x1000
    mov dword [edi], 0x4003
    add edi, 0x1000

    mov ebx, 0x00000003
    mov ecx, 512

.set_entry:
    mov dword [edi], ebx
    add edi, 0x1000
    add edi, 8 
    loop .set_entry

    ; enable paging
    mov eax, cr4
    or eax, 1<<5
    mov cr4, eax

    ret

error:
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte [0xb800a], al
    hlt

section .bss
align 4096
stack_bottom:
    resb 4096 * 16
stack_top:

section .rodata
gdt64:
    dq 0
.code: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.pointer:
    dw $ - gdt64 - 1
    dq gdt64