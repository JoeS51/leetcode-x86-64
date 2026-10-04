.intel_syntax noprefix
.global _start

.section .text
_start:
  mov rax, 0   

loop:
  cmp rax, 10
  jge done
  add rax, 1
  jmp loop

done:
  mov rax, 60
  mov rdi, 0
  syscall
