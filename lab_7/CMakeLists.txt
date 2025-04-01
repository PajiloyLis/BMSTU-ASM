cmake_minimum_required(VERSION 3.27)
project(lab_7)

set(CMAKE_ASM_NASM_CREATE_SHARED_LIBRARY
        "ld -lc -shared  <CMAKE_ASM_NASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)

set(CMAKE_CXX_STANDARD 17)

add_executable(main
        src/main_1.cpp)

#add_library(./asm_strncpy.o)

include_directories(./inc/)