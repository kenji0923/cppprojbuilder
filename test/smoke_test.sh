#!/bin/sh
#
# End-to-end smoke test: generate a project (through a symlink, to exercise the
# symlink requirement), add a library, build/install it with an executable, and
# assert the installed artifacts exist.

set -e

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

work_dir=$(mktemp -d)
cleanup() { rm -rf "${work_dir}"; }
trap cleanup EXIT

# Symlink the scripts so we test invocation through a symlink, not the real path.
ln -s "${repo_dir}/CreateCppProject" "${work_dir}/CreateCppProject"
ln -s "${repo_dir}/AddLibrary" "${work_dir}/AddLibrary"

cd "${work_dir}"

echo "=== generate project ==="
./CreateCppProject Demo

echo "=== add library ==="
./AddLibrary Demo Foo

# Wire up the library + executable.
cat >> Demo/src/core/CMakeLists.txt <<'EOF'

Demo_add_library_std(Foo Foo)
Demo_install_package()
EOF

cat > Demo/src/exec/main.cc <<'EOF'
int main() { return 0; }
EOF

cat >> Demo/src/exec/CMakeLists.txt <<'EOF'

Demo_add_executable_std(App main.cc)
EOF

prefix="${work_dir}/inst"

echo "=== configure / build / install ==="
cmake -S Demo/src -B Demo/build -DCMAKE_INSTALL_PREFIX="${prefix}" >/dev/null
cmake --build Demo/build >/dev/null
cmake --install Demo/build >/dev/null

echo "=== assert installed artifacts ==="
fail=0
check() {
  if ls $1 >/dev/null 2>&1; then
    echo "  ok: $1"
  else
    echo "  MISSING: $1"
    fail=1
  fi
}

check "${prefix}/lib*/libFoo.a"
check "${prefix}/include/Demo/Foo.h"
check "${prefix}/lib*/cmake/Demo/DemoConfig.cmake"
check "${prefix}/lib*/cmake/Demo/DemoConfigVersion.cmake"
check "${prefix}/lib*/cmake/Demo/DemoTargets.cmake"
check "${prefix}/bin/App"

# Placeholders must be fully substituted in the generated tree.
if grep -rq VAR_PROJECT_NAME Demo/src; then
  echo "  LEFTOVER VAR_PROJECT_NAME placeholders in Demo/src"
  fail=1
fi

if [ "${fail}" -ne 0 ]; then
  echo "SMOKE TEST FAILED"
  exit 1
fi

echo "SMOKE TEST PASSED"
