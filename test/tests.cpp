#include <catch2/catch_test_macros.hpp>


#include <soko_cpp_tools/sample_library.hpp>


TEST_CASE("Factorials are computed", "[factorial]")
{
  REQUIRE(factorial(0) == 1);
  REQUIRE(factorial(1) == 1);
  REQUIRE(factorial(2) == 2);
  REQUIRE(factorial(3) == 6);
  REQUIRE(factorial(10) == 3628800);
}

TEST_CASE("Parsing directories requires a root directory", "parsingFiles")
{ 
  std::string root {}; 
  const std::vector<std::string> files = parse_dir_tree(root);
  REQUIRE(files.empty() == true);
}
