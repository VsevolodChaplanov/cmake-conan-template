#include <fmt/core.h> // for format
#include <iostream>   // for basic_ostream, cout
#include <pybinf_tatneft/core/core.hpp>
#include <pybinf_tatneft/utility/static_string.hpp> // for operator""_fs, static_string

void pybinf_tatneft_CORE_EXPORT hello_example() {
    constexpr auto greeting = "hello world"_fs;
    std::cout << fmt::format("{}\n", greeting.view());
}
