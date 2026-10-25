cmake_minimum_required(VERSION 3.20)
project(apks_lab LANGUAGES CXX)

include(FetchContent)

FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(hello src/main.cpp)
target_compile_features(hello PRIVATE cxx_std_17)

add_executable(basic_addition_test tests/test_basic_addition.cpp)
target_link_libraries(basic_addition_test PRIVATE GTest::gtest_main)
target_compile_features(basic_addition_test PRIVATE cxx_std_17)

include(GoogleTest)
add_test(NAME BasicAddition COMMAND basic_addition_test)
