#include <iostream>
#include "inline_asm.h"
#include "extern_asm.h"

int main() {
    std::cout << test_strlen() << '\n';
    std::cout << test_strncpy() << '\n';
    return 0;
}