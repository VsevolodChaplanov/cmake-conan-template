#ifndef my_project_HPP
#define my_project_HPP

#include <fmt/core.h>

#include <my_project/static_string.hpp>

template<static_string V = "hello world"> constexpr auto hello_world() { fmt::println("{}\n", V); }

void hello_example();

inline void HelloWorld() {}

#endif