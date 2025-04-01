//
// Created by ivan on 26.04.24.
//
#include "inline_asm.h"
#include <cstring>

static size_t asm_strlen(const char *str) {
    size_t len = 0;
    asm(
            "xorb %%al, %%al \n"
            "movl %1, %%edi \n"
            "repne scasb \n"
            "subl %%edi, %0\n"
            "negl %0 \n"
            "decl %0 \n"
            : "=r" (len)
            : "r" (str)
            : "%rax", "%edi", "%ecx"
            );
    return len;
}

int test_strlen() {
    const char *str1 = "Test",
            *str2 = "T a b \n\ta",
            *str3 = "";
    const char *tests[] = {str1, str2, str3};
    int failed = sizeof(tests) / sizeof(tests[0]);
    for (auto test: tests)
        if (std::strlen(test) == asm_strlen(test))
            failed--;
    return failed;
}