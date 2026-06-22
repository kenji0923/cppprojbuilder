# cppprojbuilder

A small generator that scaffolds a modern CMake C++17 project with install
targets and `find_package` support already wired in.

A generated project has three subdirectories under `src/`:

- `core/` — libraries. The `..._add_library_std` helper builds a library, sets up
  its include dirs, creates a `Project::Target` alias, and installs it; the
  `..._install_package` helper emits the `find_package` config files.
- `exec/` — executables. The `..._add_executable_std` helper builds an executable
  and installs it to `bin`.
- `doc/` — Doxygen documentation (`doc` target, built when Doxygen is found).

## Usage

Generate a project:

```sh
./CreateCppProject MyProj
```

This creates `MyProj/src/` from `template/project/` and substitutes the project
name throughout the generated files.

> `CreateCppProject` and `AddLibrary` resolve their own location through
> symbolic links, so you can symlink them onto your `PATH`
> (e.g. `ln -s "$PWD/CreateCppProject" ~/bin/`) and run them from anywhere.

### Add a library

```sh
./AddLibrary MyProj MyLib
```

This creates `MyProj/src/core/include/MyProj/MyLib.h` and
`MyProj/src/core/MyLib.cc` (with the project/library names substituted) and prints
the line to add to `MyProj/src/core/CMakeLists.txt`:

```cmake
MyProj_add_library_std(MyLib MyLib)
# target_link_libraries(MyLib PUBLIC ...)

MyProj_install_package()   # call once, after all libraries are declared
```

### Add an executable

Put the source in `MyProj/src/exec/`, then in `MyProj/src/exec/CMakeLists.txt`:

```cmake
MyProj_add_executable_std(MyApp main.cc)
target_link_libraries(MyApp PRIVATE MyProj::MyLib)
```

### Build, install, and consume

```sh
cmake -S MyProj/src -B MyProj/build -DCMAKE_INSTALL_PREFIX=/path/to/install
cmake --build MyProj/build
cmake --install MyProj/build
```

Libraries install to `lib/`, headers to `include/MyProj/`, executables to `bin/`,
and the CMake package files to `lib/cmake/MyProj/`. Another project can then:

```cmake
find_package(MyProj REQUIRED)
target_link_libraries(app PRIVATE MyProj::MyLib)
```

See [`doc/command.md`](doc/command.md) for the full command reference.
