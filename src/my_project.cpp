#include <iostream>

#include <fmt/format.h>
#include <my_project/my_project.hpp>
#include <my_project/static_string.hpp>

void hello_world() {
	constexpr auto greeting = "hello world"_fs;
	std::cout << fmt::format("{}\n", greeting);
}
