set(lute_stdlib_files
    assert.luau
    io.luau
    json.luau
    system.luau
    table.luau
    task.luau
    test.luau
    time.luau
    vector.luau

    path/init.luau
    path/posix.luau
    path/win32.luau

    syntax/parser.luau
    syntax/printer.luau
    syntax/visitor.luau
)
list(
    TRANSFORM lute_stdlib_files 
    PREPEND "${CMAKE_CURRENT_LIST_DIR}/"
    OUTPUT_VARIABLE lute_stdlib_files_absolute
)
