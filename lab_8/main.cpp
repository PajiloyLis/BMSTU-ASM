#include <iostream>

double bisection(double a, double b, double e, int i) {
    double root;
    double two = 2;
    double five = 5;
    std::cout<<i<<'\n';
    asm(
            "fldl %6\n" //  st(5)      5
            "fldl %5\n" //   st(4)      2
            "xorq %%rcx, %%rcx\n"
            "movl %4, %%ecx\n"
            "fldl %3\n" //   st(3)      e
            "fldl %2\n" //   st(2)      b
            "fldl %1\n" //   st(1)      a
            "fldz\n" //     st(0)      c

//            ".rept %4\n"
            "iter:\n"

            "fsub %%st(0)\n" // st(0) == 0
            "fadd %%st(1)\n" // st(0) == a
            "fadd %%st(2)\n" // st(0) == a + b
            "fdiv %%st(4)\n" // st(0) == (a + b) / 2
            "fst %%st(6)\n" //  st(0) == c and st(6) == c

            "fmul %%st(6)\n" // st(0) == c*c and st(6) == c
            "fsub %%st(5)\n" // st(0) == c*c - 5  and st(6) == c

            "fsin\n" // st(0) = sin(c*c-5) and st(6) == c
            "fst %%st(7)\n" // st(0) == sin(c*c-5) and st(7) ==  sin(c*c-5) and st(6) == c
            "fabs\n" // st(0) == abs(sin(c(c+5))) and st(7) ==  sin(c(c+5)) and st(6) == c

            "fcom %%st(3)\n"
            "fstsw %%ax\n"
            "sahf\n"
            "jb exit\n"

            "fxch %%st(1)\n" // st(1) == ? and st(0) == a

            "fst %%st(1)\n" // st(0) == st(1) == a

            "fmul %%st(1)\n"    // st(0) = a*a
            "fsub %%st(5)\n" // st(0) = a*a + 5
            "fsin\n"       // st(0) = sin(a (a+5))
            "fmul %%st(7)\n" // st(7) == f(c), st(1) == a, st(6) == c, st(0) = f(a) * f(c)
            "fxch %%st(7)\n" // st(7) == f(c) * f(a), st(1) == a, st(6) == c, st(0) = f(c)

            "fsub %%st(0)\n" // st(7) == f(c) * f(a), st(1) == a, st(6) == c, st(0) = 0
            "fcom %%st(7)\n" // st(0) == 0 > st(7) -> b = c else a = c
            "fstsw %%ax\n"
            "sahf\n"

            "jae set_b\n"

            "fxch %%st(6)\n"
            "fst %%st(6)\n"
            "fst %%st(1)\n"
//            ".endr\n"
            "loop iter\n"
//            "decl %%ecx\n"
//            "jnz iter\n"
            "jmp exit\n"

            "set_b:\n"
            "fxch %%st(6)\n"
            "fst %%st(6)\n"
            "fst %%st(2)\n"
            "loop iter\n"

            "exit:\n"
            "fxch %%st(6)\n"
            "fstpl %0\n"
            : "=m" (root)
            : "m" (a), "m" (b), "m" (e), "r" (i), "m" (two), "m" (five)
            );
    std::cout << root << std::endl;
    return root;
}

int main() {
//    bisection(-1, -0.01, 0.000001, 10);
//    return 0;
    double a, b, epsilon=0.01;
    int max_iterations;

    std::cout << "a: ";
    std::cin >> a;
    std::cout << "b: ";
    std::cin >> b;

//    std::cout << "epsilon: ";
//    std::cin >> epsilon;

    std::cout << "Iterations: ";
    std::cin >> max_iterations;

    double root, f;
    root = bisection(a, b, epsilon, max_iterations);

    std::cout << "Root: " << root << std::endl;

    return 0;
}
