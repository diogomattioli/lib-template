cmake_minimum_required(VERSION 3.16)
project(template CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Werror")
set(CMAKE_CXX_FLAGS_DEBUG "-g3 -fsanitize=address,undefined")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_CPPCHECK "cppcheck")

find_package(GTest REQUIRED)

include_directories("include")
link_directories(${CMAKE_CURRENT_BINARY_DIR})

file(GLOB srcs "src/*.cpp")
add_library(${CMAKE_PROJECT_NAME} ${srcs})

file(GLOB tests "tests/*.cpp")
add_executable(${CMAKE_PROJECT_NAME}-tests ${tests})
target_link_libraries(${CMAKE_PROJECT_NAME}-tests ${CMAKE_PROJECT_NAME} ${GTEST_BOTH_LIBRARIES} GTest::gmock_main)
