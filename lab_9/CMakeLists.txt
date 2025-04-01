cmake_minimum_required(VERSION 3.10)
project(lab_9)
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
add_executable(main main.cpp
        main_window.cpp
        main_window.h)
include_directories(. /usr/include/qt6)
set_target_properties(main PROPERTIES
        WIN32_EXECUTABLE TRUE
        MACOSX_BUNDLE TRUE
)

target_link_libraries(main PUBLIC
        Qt::Core
        Qt::Gui
        Qt::Widgets
        sfml-graphics sfml-window sfml-system
)