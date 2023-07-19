include(GenerateExportHeader)

add_library(make_json_library make_json_library.cpp)

add_library(soko_cpp_tools::make_json_library ALIAS make_json_library)

target_link_libraries(make_json_library PRIVATE soko_cpp_tools_options soko_cpp_tools_warnings)

target_include_directories(make_json_library ${WARNING_GUARD} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                                                                  $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

target_compile_features(make_json_library PUBLIC cxx_std_20)

set_target_properties(
  make_json_library
  PROPERTIES VERSION ${PROJECT_VERSION}
             CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES)

generate_export_header(make_json_library EXPORT_FILE_NAME ${PROJECT_BINARY_DIR}/include/soko_cpp_tools/make_json_library_export.hpp)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(make_json_library PUBLIC MAKE_JSON_LIBRARY_STATIC_DEFINE)
endif()

# add_executable(make_json make_json.cpp)

# # target_link_libraries(
# #     make_json
# #     PRIVATE
# #         soko_cpp_tools::soko_cpp_tools_options
# #         soko_cpp_tools::soko_cpp_tools_warnings
# # )

# target_link_system_libraries(
#     make_json
#     PRIVATE
#         CLI11::CLI11
#         fmt::fmt
#         spdlog::spdlog
# )

# target_include_directories(make_json PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
