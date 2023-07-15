add_executable(make_json make_json.cpp)

# target_link_libraries(
#     make_json
#     PRIVATE
#         soko_cpp_tools::soko_cpp_tools_options
#         soko_cpp_tools::soko_cpp_tools_warnings
# )

target_link_system_libraries(
    make_json
    PRIVATE
        CLI11::CLI11
        fmt::fmt
        spdlog::spdlog
)

target_include_directories(make_json PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
