//
// Created by ivan on 24.04.24.
//
#include "extern_asm.h"

extern "C"
{
char *_asm_strncpy(char *dst, const char *src, size_t n);
}

int test_dst_more_src() {
    const char src[] = "abacaba";
    char dst1[std::strlen(src) + 1];
    char dst2[std::strlen(src) + 1];
    const char *asm_ans = _asm_strncpy(dst1, src, std::strlen(src) + 1),
            *ans = std::strncpy(dst2, src, std::strlen(src) + 1);
    return int(std::strncmp(asm_ans, ans, std::strlen(src) + 1) != 0 ||
               std::strncmp(dst1, dst2, std::strlen(src) + 1) != 0);
}

int test_dst_less_src() {
    char dst1[8];
    const char src[] = "abacaba";
    char dst2[std::strlen(src) + 1];
    const char *asm_ans = _asm_strncpy(dst1, src, std::strlen(src) + 1),
            *ans = std::strncpy(dst2, src, std::strlen(src) + 1);
    return int(std::strncmp(asm_ans, ans, std::strlen(src) + 1) != 0 ||
               std::strncmp(dst1, dst2, std::strlen(src) + 1) != 0);
}

int test_dst_more_src_overlap() {
    char src[] = "abcdefghijklmnopqrstu";
    char src2[] = "abcdefghijklmnopqrstu";
    char dst2[std::strlen(src) + 1];
    const char *asm_ans = _asm_strncpy(src + 4, src, 6),
            *ans = std::strncpy(dst2, src2, 6);
    return int(std::strncmp(asm_ans, ans, 6) != 0 ||
               std::strncmp(src + 4, dst2, 6) != 0);
}

int test_dst_less_src_overlap() {
    char src[] = "abcdefghijklmnopqrstu";
    char src2[] = "abcdefghijklmnopqrstu";
    char dst2[std::strlen(src) + 1];
    const char *asm_ans = _asm_strncpy(src, src + 4, 6),
            *ans = std::strncpy(dst2, src2 + 4, 6);
    return int(std::strncmp(asm_ans, ans, 6) != 0 ||
               std::strncmp(src, dst2, 6) != 0);
}

int test_strncpy() {
    int res = 0;
    res += test_dst_less_src();
    res += test_dst_more_src();
    res += test_dst_less_src_overlap();
    res += test_dst_more_src_overlap();
    return res;
}


