#include <fmt/core.h> // for format
#include <iostream>   // for basic_ostream, cout
#include <my_project/core/core.hpp>
#include <my_project/core/static_string.hpp> // for operator""_fs, static_string
#include <string>                            // for operator<<
#include <string_view>                       // for basic_string_view

void CORE_EXPORT hello_example() {
    constexpr auto greeting = "hello world"_fs;
    std::cout << fmt::format("{}\n", greeting.view());
}

struct aaa {
    int a_;

    aaa(int bbb) : a_{bbb} {}
};