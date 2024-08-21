#include <fmt/core.h> // for format
#include <iostream>   // for basic_ostream, cout
#include <my_project/core/core.hpp>
#include <my_project/core/static_string.hpp> // for operator""_fs, static_string

void MY_PROJECT_CORE_EXPORT hello_example() {
    constexpr auto greeting = "hello world"_fs;
    std::cout << fmt::format("{}\n", greeting.view());
}
