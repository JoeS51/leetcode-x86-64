.intel_syntax noprefix

.bss
table:
    .zero 393216  # lots of slots in hash table
answer:
    .zero 8
.data
input:
    .long 32767, 65535, -1, 0, 98303, -32769, 42, 7
input_end:

.text
.globl _start

# edx = key for insert_hash_table
# ecx = val for insert_hash_table
# rdi = address of table
# ebx = curr value in array

_start:
    lea rdi, [rip + table] # address of table
    #insert into hash table
    # mov edx, 3  # key
    # mov ecx, 8  # val
    # call insert_hash_table

    lea r12, [rip + input] # address of input
    mov r13d, -32762 # target
    mov r14d, 0 # current index
    mov r15d, 8 # num elements
    call loop

    cmp eax, 1
    jne test_failed
    lea r11, [rip + answer]
    cmp dword ptr [r11], 5
    jne test_failed
    cmp dword ptr [r11 + 4], 7
    jne test_failed

    # read hash table
    # lea rbx, [rip + table]
    # mov edx, 32771
    # call read_hash_table
    
    mov edi, 0
    mov eax, 60
    syscall

loop:
    cmp r14d, r15d
    jge done_not_found

    # get the value of this idx
    mov ebx, dword ptr [r12 + r14 * 4]
    # desired
    mov edx, r13d
    sub edx, ebx
    call read_hash_table
    
    cmp eax, -1
    jne done_found
    
    #insert this num to hashtable
    mov edx, ebx
    mov ecx, r14d
    call insert_hash_table
    
    inc r14d
    jmp loop

done_found:
    lea r11, [rip + answer]
    mov dword ptr [r11], eax
    mov dword ptr [r11+4], r14d
    mov eax, 1
    ret

done_not_found:
    mov eax, -1
    ret

insert_hash_table:
    mov r8d, edx
    and r8d, 32767 # slot we're trying
    mov r9d, 32768  # probing attempts
    jmp probe

probe:
    imul eax, r8d, 12 # each hash entry is 12 bytes
    lea r10, [rdi + rax] # r10 is the slot we're probing
    cmp dword ptr [r10 + 8], 0
    je store
    cmp dword ptr [r10], edx
    je store
    
    inc r8d
    and r8d, 32767

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
    and r8d, 32767
    mov r9d, 32768
    jmp read_probe

read_probe:
    imul eax, r8d, 12 # each hash entry is 12 bytes
    lea r10, [rdi + rax] # r10 is the slot we're probing

    cmp dword ptr [r10 + 8], 0
    je read_missing

    cmp dword ptr [r10], edx
    je read_result
    
    inc r8d
    and r8d, 32767

    dec r9d
    cmp r9d, 0
    jne read_probe
    jmp read_missing

read_result:
    mov eax, dword ptr[r10+4]
    ret

read_missing:
    mov eax, -1
    ret

test_failed:
    mov edi, 1                 # failed
    mov eax, 60
    syscall
