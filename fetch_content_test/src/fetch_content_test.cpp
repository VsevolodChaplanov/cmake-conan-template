#include <catch2/catch_test_macros.hpp>
#include <iostream>
#include <my_project/core/core.hpp>
#include <my_project/utility/static_string.hpp>
#include <string_view>

TEST_CASE("package found and can be used") {
    using namespace std::string_view_literals;
    constexpr auto hello_world = "hello world"_fs;
    STATIC_REQUIRE(hello_world == "hello"_fs + " "_fs + "world"_fs);
    hello_example();
}