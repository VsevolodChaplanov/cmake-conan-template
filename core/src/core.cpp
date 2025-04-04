#include <fmt/core.h> // for format
#include <my_project/core/core.hpp>
#include <my_project/utility/static_string.hpp> // for operator""_fs, static_string

namespace {
    template<static_string V> constexpr auto hello_world() { fmt::println("{}\n", V); }
} // namespace

void CORE_EXPORT hello_example() { hello_world<"hello world">(); }
