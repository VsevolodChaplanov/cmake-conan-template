#include <catch2/catch_test_macros.hpp>
#include <my_project/core/static_string.hpp>
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
