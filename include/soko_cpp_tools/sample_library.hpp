#ifndef SAMPLE_LIBRARY_HPP
#define SAMPLE_LIBRARY_HPP

#include <vector>
#include <filesystem>
#include <string>

#include <soko_cpp_tools/sample_library_export.hpp>

[[nodiscard]] SAMPLE_LIBRARY_EXPORT int factorial(int) noexcept;

[[nodiscard]] constexpr int factorial_constexpr(int input) noexcept
{
  if (input == 0) { return 1; }

  return input * factorial_constexpr(input - 1);
}

[[nodiscard]] SAMPLE_LIBRARY_EXPORT std::vector<std::string> parse_dir_tree(std::string& root) noexcept;

#endif
