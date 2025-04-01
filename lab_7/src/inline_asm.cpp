//
// Created by ivan on 23.04.24.
//
#include "inline_asm.h"
#include <cstring>

static size_t asm_strlen(const char *str) {
    size_t len = 0;
    asm(
            "xorb %%al, %%al \n"
            "movq %1, %%rdi \n"
            "repne scasb \n"
            "subq %%rdi, %0\n"
            "negq %0 \n"
            "decq %0 \n"
            : "=r" (len)
            : "r" (str)
            : "%rax", "%rdi", "%rcx"
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