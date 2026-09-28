.intel_syntax noprefix
.global _start

.section .data
nums:
  .long 10, 20, 30, 40

.section .text
_start:
  mov rcx, 0
  mov esi, 0

loop:
  cmp rcx, 4
  jge done
  lea rbx, [nums + rcx * 4]
  add esi, [rbx]
  add rcx, 1
  jmp loop

done:
  mov rax, 60
  mov rdi, 0
  syscall
