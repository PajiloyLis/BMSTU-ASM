#include <iostream>
#include <cmath>
#include <iomanip>

int main()
{
    double pi_approx_1 = 3.14;
    double pi_approx_2 = 3.141596;
    double pi_approx_3 = 0;
    double pi_approx_4 = 3.141592653589793238462643383279502884197169399375;

    __asm__("fldpi\n"
             "fstp %0\n"
            : "=m"(pi_approx_3)
            );


    std::cout << std::fixed;
    std::cout << std::setprecision(48);
    std::cout << "1 PI: "  << pi_approx_1 << std::endl;
    std::cout << "2 PI: "  << pi_approx_2 << std::endl;
    std::cout << "3 PI: "  << pi_approx_3 << std::endl;
    std::cout << "IDEAL "  << pi_approx_4 << std::endl;

    std::cout << "1 sin(PI): " << sin(pi_approx_1) << std::endl;
    std::cout << "2 sin(PI): " << sin(pi_approx_2) << std::endl;
    std::cout << "3 sin(PI): " << sin(pi_approx_3) << std::endl;
    std::cout << "4 sin(PI): " << sin(pi_approx_4) << std::endl;

    std::cout << "1 sin(PI/2): " << sin(pi_approx_1 / 2.) << std::endl;
    std::cout << "2 sin(PI/2): " << sin(pi_approx_2 / 2.) << std::endl;
    std::cout << "3 sin(PI/2): " << sin(pi_approx_3 / 2.) << std::endl;
    std::cout << "4 sin(PI/2): " << sin(pi_approx_4 / 2.) << std::endl;


    return 0;
}