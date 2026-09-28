.intel_syntax noprefix
.global _start

.section .data
input:
  .long 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 1, 10
input_end:
  
.section .text
_start:
  mov rcx, 0
  mov rdx, 0
  mov esi, 0
  mov edi, 0
  mov rbx, 0
  mov r10, (input_end - input) / 4

outer_loop:
  cmp rcx, r10
  jge done
  mov rdx, rcx
  add rdx, 1
  lea rbx, [input + rcx * 4]
  mov esi, [rbx]
  jmp inner_loop

increment_outer:
  add rcx, 1
  jmp outer_loop

inner_loop:
  cmp rdx, r10
  jge increment_outer
  lea rbx, [input + rdx * 4]
  mov edi, [rbx]
  cmp edi, esi
  je found_duplicate
  add rdx, 1
  jmp inner_loop

found_duplicate:
  mov rax, 1
  mov rdi, 1
  lea rsi, [found + rip]
  mov rdx, found_end - found

  syscall
  mov rax, 60
  mov rdi, 1
  syscall
  
done:
  mov rax, 1
  mov rdi, 1
  lea rsi, [not_found + rip]
  mov rdx, not_found_end - not_found
  syscall
  
  mov rax, 60
  mov rdi, 0
  syscall

found:
  .ascii "found duplicate"
found_end:

not_found:
  .ascii "not_found"
not_found_end:
