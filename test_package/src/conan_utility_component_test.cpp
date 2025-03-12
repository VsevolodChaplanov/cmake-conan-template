#include <iostream>
#include <my_project/utility/static_string.hpp>

int main() {
    constexpr auto str = "hello"_fs;
    std::cout << str.view() << '\n';
    return 0;
}