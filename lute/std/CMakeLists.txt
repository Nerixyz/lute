add_library(Lute.Std STATIC)

include(${CMAKE_CURRENT_LIST_DIR}/libs/_contents.cmake)
lute_embed_files(
    OUTPUT src/generated/modules
    CXX_NAME lutestdlib
    PREFIX "@std/"
    WORKDIR "${CMAKE_CURRENT_LIST_DIR}/libs"
    FILES ${lute_stdlib_files}
)

target_sources(Lute.Std PRIVATE
    include/lute/stdlib.h

    src/stdlib.cpp
    src/generated/modules.h
    src/generated/modules.cpp
)

target_compile_features(Lute.Std PUBLIC cxx_std_17)
target_include_directories(Lute.Std PUBLIC "include")
target_link_libraries(Lute.Std PRIVATE Lute.Runtime Luau.VM uv_a)
target_compile_options(Lute.Std PRIVATE ${LUTE_OPTIONS})
