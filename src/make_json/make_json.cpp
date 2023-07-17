#include <fmt/core.h>

#include <optional>

#include <CLI/CLI.hpp>
#include <internal_use_only/config.hpp>
#include <spdlog/spdlog.h>


int main(int argc, const char **argv)
{
  try {
    CLI::App app{ fmt::format(
      "{} version {}", soko_cpp_tools::cmake::project_name, soko_cpp_tools::cmake::project_version) };

    std::optional<std::string> message;
    app.add_option("-m,--message", message, "A message to print back out");
    bool show_version = false;
    app.add_flag("--version", show_version, "Show version information");

    CLI11_PARSE(app, argc, argv);

    if (show_version) {
      fmt::print("{}\n", soko_cpp_tools::cmake::project_version);
      return EXIT_SUCCESS;
    }

  } catch (const std::exception &e) {
    spdlog::error("Unhandled exception in main: {}", e.what());
  }
  
  fmt::print("Starting codeing Make Json!");
  return 0;
}
