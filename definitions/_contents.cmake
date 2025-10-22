set(lute_definition_files
    crypto.luau
    fs.luau
    io.luau
    luau.luau
    net.luau
    process.luau
    system.luau
    task.luau
    time.luau
    vm.luau
)
list(
    TRANSFORM lute_definition_files 
    PREPEND "${CMAKE_CURRENT_LIST_DIR}/"
    OUTPUT_VARIABLE lute_definition_files_absolute
)
