#include <iostream>

using namespace std;

size_t asm_strlen(const char *str)
{
    size_t len = 0;
    asm(
            "mov x0, 0\n"
            "mov X2, 0\n"
            "mov X1, %1\n"
            "loop: ldrb W2, [X1], #1\n"
            "cmp W2, #0\n"
            "b.eq exit\n"
            "add X0, X0, #1\n"
            "b loop\n"
            "exit: mov %1, X0"
            : "=r"(len)
            : "r"(str)
            : "r1", "r0", "r2");
    return len;
}

float scalar_mul(const float *v1, const float *v2)
{
    float res = 0;
    asm(
            "mov X1, %1\n"
            "mov X2, %2\n"
            "ldr Q0, [X1]\n"
            "ldr Q1, [X2]\n"
            "FMUL V0.4S, V0.4S, V1.4S\n"
            "FADDP V0.4S, V0.4S, V0.4S\n"
            "FADDP V0.4S, V0.4S, V0.4S\n"
            "fmov W3, S0\n"
            "mov %w[res], W3\n"
            : [res] "=r"(res)
    : "r"(v1), "r"(v2)
    : "r1", "r2", "r0");
    return res;
}

signed main()
{
    string str;
    cout << "Input str:\n";
    cin >> str;
    cout << asm_strlen(str.c_str()) << '\n';
    float v1[4] = {0, 0, 0, 0}, v2[4] = {0, 0, 0, 0};
    cout << "Input first vector:\n";
    cin >> v1[0] >> v1[1] >> v1[2];
    cout << "Input second vector:\n";
    cin >> v2[0] >> v2[1] >> v2[2];

    cout << "Scalar multiply: " << scalar_mul(v1, v2) << '\n';
}