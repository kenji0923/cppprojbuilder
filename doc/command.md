# Commands

## Generate a new project skeleton

```sh
./CreateCppProject MyProj
```

Creates `MyProj/src/` from `template/project/` and substitutes the project name
across all generated files. Library sources live in `MyProj/src/core/`
(headers under `core/include/MyProj/`), executables in `MyProj/src/exec/`.

`CreateCppProject` and `AddCppLibrary` follow symlinks to find their templates, so
they can be symlinked onto `PATH`.

## Add a library

```sh
./AddCppLibrary MyProj MyLib
```

Creates `MyProj/src/core/include/MyProj/MyLib.h` and `MyProj/src/core/MyLib.cc`
(names substituted) and prints the `MyProj_add_library_std(MyLib MyLib)` line to
add to `MyProj/src/core/CMakeLists.txt`.

## Build

```sh
cmake -S MyProj/src -B MyProj/build -DCMAKE_INSTALL_PREFIX=/path/to/install
cmake --build MyProj/build
```

## Install

```sh
cmake --install MyProj/build
```

Installs libraries to `<prefix>/lib`, headers to `<prefix>/include/MyProj`, and —
once at least one library is declared and `MyProj_install_package()` is called in
`core/CMakeLists.txt` — the CMake package files to
`<prefix>/lib/cmake/MyProj/` (`MyProjConfig.cmake`, `MyProjConfigVersion.cmake`,
`MyProjTargets.cmake`).

## Consume from another project

```cmake
find_package(MyProj REQUIRED)
target_link_libraries(my_target PRIVATE MyProj::ExampleLibrary)
```

Point the consumer at the install prefix with
`-DCMAKE_PREFIX_PATH=/path/to/install`.

## Run the smoke test

```sh
sh test/smoke_test.sh
```

Generates a project through a symlink, adds a library, builds/installs it with an
executable, and asserts the installed library, headers, package config, and
`bin/` executable all exist. Runs in CI on every push/PR
(`.github/workflows/ci.yml`).
