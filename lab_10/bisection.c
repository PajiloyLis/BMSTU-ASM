#include "bisection.h"
#include "stdio.h"

extern double bisection(double a, double b, double i)
{
    printf("%lf %lf %lf\n", a, b, i);
    double root;
    double two = 2;
    double five = 5;
    double e = 0.01;
    if (a > b)
    {
        double tmp = a;
        a = b;
        b = tmp;
    }
    __asm__(
        ""
        "fld %6\n" //  st(5)      5
        "fld %5\n" //   st(4)      2
        "xor %%rcx, %%rcx\n"
        "mov %%ecx, %4\n"
        "fld %3\n" //   st(3)      e
        "fld %2\n" //   st(2)      b
        "fld %1\n" //   st(1)      a
        "fldz\n"   //     st(0)      c

        //            ".rept %4\n"
        "iter:\n"

        "fsub %%st(0)\n" // st(0) == 0
        "fadd %%st(1)\n" // st(0) == a
        "fadd %%st(2)\n" // st(0) == a + b
        "fdiv %%st(4)\n" // st(0) == (a + b) / 2
        "fst %%st(6)\n"  //  st(0) == c and st(6) == c

        "fmul %%st(6)\n" // st(0) == c*c and st(6) == c
        "fsub %%st(5)\n" // st(0) == c*c - 5  and st(6) == c

        "fsin\n"        // st(0) = sin(c*c-5) and st(6) == c
        "fst %%st(7)\n" // st(0) == sin(c*c-5) and st(7) ==  sin(c*c-5) and st(6) == c
        "fabs\n"        // st(0) == abs(sin(c(c+5))) and st(7) ==  sin(c(c+5)) and st(6) == c

        "fcom %%st(3)\n"
        "fstsw %%ax\n"
        "sahf\n"
        "jb exit\n"

        "fxch %%st(1)\n" // st(1) == ? and st(0) == a

        "fst %%st(1)\n" // st(0) == st(1) == a

        "fmul %%st(1)\n" // st(0) = a*a
        "fsub %%st(5)\n" // st(0) = a*a + 5
        "fsin\n"         // st(0) = sin(a (a+5))
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
        "fstp %0\n"
        : "=m"(root)
        : "m"(a), "m"(b), "m"(e), "r"((int)i), "m"(two), "m"(five));
    printf("%lf\n", root);
    return root;
}

// int main() {
//     printf("%lf\n", bisection(0.1, 0.6, 9));
//     return 0;
// }