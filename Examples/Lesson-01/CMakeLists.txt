add_executable(lesson_01
    src/main.cpp
)

set_common_warnings(lesson_01)

target_compile_features(lesson_01 PRIVATE cxx_std_20)

target_include_directories(lesson_01
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/inc
)