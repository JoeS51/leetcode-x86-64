.intel_syntax noprefix

.bss
table:
    .zero 96

.text
.globl _start

_start:
    lea rdi, [rip + table] # address of table
    mov edx, 3  # key
    mov ecx, 8  # val
    call insert_hash_table

    # read hash table
    lea rbx, [rip + table]
    mov edx, 1
    call read_hash_table
    
    mov edi, eax
    mov eax, 60
    syscall

insert_hash_table:
    mov r8d, edx
    and r8d, 7 # slot we're trying
    mov r9d, 8 # probing attempts
    jmp probe

probe:
    imul eax, r8d, 12 # each hash entry is 12 bytes
    lea r10, [rdi + rax] # r10 is the slot we're probing
    cmp dword ptr [r10 + 8], 0
    je store
    cmp dword ptr [r10], edx
    je store
    
    inc r8d
    and r8d, 7

    dec r9d
    cmp r9d, 0
    jne probe

    mov eax, 0
    ret

store:
    mov dword ptr [r10], edx
    mov dword ptr [r10+4], ecx
    mov dword ptr [r10+8], 1
    mov eax, 1
    ret

read_hash_table:
    mov r8d, edx
    and r8d, 7
    mov r9d, 8
    jmp read_probe

read_probe:
    imul eax, r8d, 12 # each hash entry is 12 bytes
    lea r10, [rdi + rax] # r10 is the slot we're probing

    cmp dword ptr [r10 + 8], 0
    je read_missing

    cmp dword ptr [r10], edx
    je read_result
    
    inc r8d
    and r8d, 7

    dec r9d
    cmp r9d, 0
    jne read_probe

read_result:
    mov eax, dword ptr[r10+4]
    ret

read_missing:
    mov eax, -1
    ret
