# APP SUBDIR

file (GLOB_RECURSE SOURCES "*.cpp")
file (GLOB_RECURSE HEADERS "*.h")

add_executable (cursed_mire_client ${SOURCES} ${HEADERS} "client_main.cpp""header.h")

set_target_properties(cursed_mire_client PROPERTIES CXX_STANDARD 20)
target_link_libraries(cursed_mire_client PRIVATE asio)