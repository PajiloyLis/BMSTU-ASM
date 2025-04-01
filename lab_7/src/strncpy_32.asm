.section .text

.global _asm_strncpy

_asm_strncpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %esi
    pushl %ebx
    movl 8(%ebp), %edi
    movl 12(%ebp), %esi
    movl 16(%ebp), %ecx

    cmpl %esi, %edi
# приемник раньше источника, можно копировать слева направо
    jbe copy

    movl %edi, %ebx
    subl %esi, %ebx
    cmpl %ecx, %ebx
# между указателями достаочно места
    ja copy

    # ну все вообще плохо, надо менять df, а еще желательно восстановить испорченный
    # ранее rbx

    addl %ecx, %edi
    decl %edi

    addl %ecx, %esi
    decl %esi

    std
copy:
    rep movsb
end:
    cld
    popl %ebx
    popl %esi
    popl %edi
    popl %ebp
    ret
