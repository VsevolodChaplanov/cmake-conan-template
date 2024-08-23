#include <iostream>
#include <my_project/utility/static_string.hpp>

auto main() -> int {
    constexpr auto hello_world = "hello world"_fs;
    std::cout << hello_world.view() << std::endl;
    return 0;
}
