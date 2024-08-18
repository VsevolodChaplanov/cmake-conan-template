#ifndef my_project_HPP
#define my_project_HPP

#include <fmt/core.h>

#include <core/static_string.hpp>
#include <exports/exports.hpp>

template<static_string V = "hello world"> constexpr auto hello_world() { fmt::println("{}\n", V); }

void MY_PROJECT_CORE_EXPORT hello_example();

inline void HelloWorld() {}

#endif