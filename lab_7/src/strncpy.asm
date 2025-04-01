# cdecl - говно, system V AMD64 ABI - наш слоняра
# The first six integer or pointer arguments are passed in registers RDI, RSI, RDX, RCX, R8, R9
# while XMM0, XMM1, XMM2, XMM3, XMM4, XMM5, XMM6 and XMM7 are used for the first floating point arguments
# Integer return values up to 64 bits in size are stored in RAX while values up to 128 bit are stored in RAX and RDX
# If the callee wishes to use registers RBX, RSP, RBP, and R12–R15, it must restore their original values before
# returning control to the caller. All other registers must be saved by the caller if it wishes to preserve their values.

# стало быть dst в rdi, src в rsi, n в rdx

.section .text

.global _asm_strncpy

_asm_strncpy:
    pushq %rbx
    movq %rdi, %rax
    movq %rdx, %rcx

    cmpq %rsi, %rdi
# приемник раньше источника, можно копировать слева направо
    jbe copy

    movq %rdi, %rbx
    subq %rsi, %rbx
    cmpq %rcx, %rbx
# между указателями достаочно места
    ja copy

    # ну все вообще плохо, надо менять df, а еще желательно восстановить испорченный
    # ранее rbx

    addq %rcx, %rdi
    decq %rdi

    addq %rcx, %rsi
    decq %rsi

    std
copy:
    rep movsb
end:
    cld
    popq %rbx
    ret
