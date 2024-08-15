#include <string>
#include <string_view>

#include <my_project/static_string.hpp>

#include <catch2/catch_test_macros.hpp>

TEST_CASE("static string class unit tests") {
	using namespace std::literals::string_literals;
	using namespace std::literals::string_view_literals;

	REQUIRE(std::string{"Control.Type"} == "Control.Type"_fs.view());
	REQUIRE(std::string_view{"Control.Type"} == "Control.Type"_fs.view());

	REQUIRE(std::string{"Control.Type"_fs} == "Control.Type");
	REQUIRE(std::string_view{"Control.Type"_fs} == "Control.Type");

	REQUIRE(std::string{"Control.Type"_fs} == std::string_view{"Control.Type"});
	REQUIRE(std::string_view{"Control.Type"_fs} == std::string_view{"Control.Type"});

	REQUIRE(std::string{"Control.Type"_fs} == std::string{"Control.Type"});
	REQUIRE(std::string_view{"Control.Type"_fs} == std::string{"Control.Type"});
}
