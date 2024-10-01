#include <catch2/catch_test_macros.hpp>
#include <my_project/utility/static_string.hpp>
#include <string>
#include <string_view>

TEST_CASE("static string class unit tests") {
    using namespace std::literals::string_literals;
    using namespace std::literals::string_view_literals;

    REQUIRE(std::string{"my_package"} == "my_package"_fs.view());
    REQUIRE(std::string_view{"my_package"} == "my_package"_fs.view());

    REQUIRE(std::string{"my_package"_fs} == "my_package");
    REQUIRE(std::string_view{"my_package"_fs} == "my_package");

    REQUIRE(std::string{"my_package"_fs} == std::string_view{"my_package"});
    REQUIRE(std::string_view{"my_package"_fs} == std::string_view{"my_package"});

    REQUIRE(std::string{"my_package"_fs} == std::string{"my_package"});
    REQUIRE(std::string_view{"my_package"_fs} == std::string{"my_package"});
}

TEST_CASE("create static_string from pieces") {
    constexpr auto first = "piece_1"_fs;
    constexpr auto second = "piece_2"_fs;

    constexpr auto merged = "<" + first + ">" + second + "</"_fs + first + ">"_fs;

    STATIC_CHECK(merged == "<piece_1>piece_2</piece_1>");
}
