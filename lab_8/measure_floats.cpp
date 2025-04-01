//
// Created by ivan on 07.05.24.
//

#include <iostream>
#include <ctime>
#include <vector>

int main() {
    std::size_t size = 100;
    std::vector<double> numbers_d(size);
    for (std::size_t i = 0; i < size; ++i) {
        numbers_d[i] = static_cast<double>(rand()) / rand();
    }
    volatile double ans_d;
    clock_t start = clock();
    for (std::size_t i = 0; i < size; ++i) {
        for (std::size_t j = 0; j < size; ++j) {
            ans_d = numbers_d[i] + numbers_d[j];
        }
    }
    static_cast<int>(ans_d);
    clock_t end = clock();
    std::cout << "Time per " << size * size << " measures of sum with generated instructions for doubles: "
              << static_cast<double>(end - start) / (CLOCKS_PER_SEC) << '\n';
    start = clock();
    for (std::size_t i = 0; i < size; ++i) {
        for (std::size_t j = 0; j < size; ++j) {
            asm(
                    "FLDL %0\n"
                    "FADDL %1\n"
                    :
                    :"m" (numbers_d[i]), "m" (numbers_d[j])
                    :
                    );
        }
    }
    end = clock();
    std::cout << "Time per " << size * size << " measures of sum with inline asm for doubles: "
              << static_cast<double>(end - start) / (CLOCKS_PER_SEC) << '\n';


    std::vector<double> numbers_f(size);
    for (std::size_t i = 0; i < size; ++i) {
        numbers_f[i] = static_cast<double>(rand()) / rand();
    }
    volatile double ans_f;
    start = clock();
    for (std::size_t i = 0; i < size; ++i) {
        for (std::size_t j = 0; j < size; ++j) {
            ans_f = numbers_d[i] + numbers_d[j];
        }
    }
    static_cast<float>(ans_f);
    end = clock();
    std::cout << "Time per " << size * size << " measures of sum with generated instructions for floats: "
              << static_cast<double>(end - start) / (CLOCKS_PER_SEC) << '\n';
    start = clock();
    for (std::size_t i = 0; i < size; ++i) {
        for (std::size_t j = 0; j < size; ++j) {
            asm(
                    "FLDL %0\n"
                    "FADDL %1\n"
                    :
                    :"m" (numbers_d[i]), "m" (numbers_d[j])
                    :
                    );
        }
    }
    end = clock();
    std::cout << "Time per " << size * size << " measures of sum with inline asm for floats: "
              << static_cast<double>(end - start) / (CLOCKS_PER_SEC) << '\n';
}
