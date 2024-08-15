#include <iostream>
#include <string_view>
#include <catch2/catch_test_macros.hpp>
#include <my_project/static_string.hpp>

TEST_CASE("package found and can be used") {
    using namespace std::string_view_literals;
    constexpr auto hello_world = "hello world"_fs;
    STATIC_REQUIRE(hello_world == "hello world"sv);
}