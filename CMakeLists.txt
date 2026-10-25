cmake_minimum_required(VERSION 3.20)

project(apks_lab LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)

include(FetchContent)
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(hello src/main.cpp)

add_executable(basic_addition_test tests/test_basic_addition.cpp)
target_link_libraries(basic_addition_test PRIVATE GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(basic_addition_test)
