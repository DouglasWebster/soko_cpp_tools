#include <soko_cpp_tools/sample_library.hpp>

int factorial(int input) noexcept
{
  int result = 1;

  while (input > 0) {
    result *= input;
    --input;
  }

  return result;
}

std::vector<std::string> parse_dir_tree(std::string& root) noexcept
{
  std::vector<std::string> files{};
  if(!root.empty()) {
    files.push_back(root);
  }
  return files;
}
