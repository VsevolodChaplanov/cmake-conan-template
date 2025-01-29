#ifndef pybinf_tatneft_HPP
#define pybinf_tatneft_HPP

#include <fmt/core.h>

#include <pybinf_tatneft/core/exports/exports.hpp>
#include <pybinf_tatneft/utility/static_string.hpp>

template<static_string V = "hello world"> constexpr auto hello_world() { fmt::println("{}\n", V); }

void pybinf_tatneft_CORE_EXPORT hello_example();

inline void HelloWorld() {}

#endif