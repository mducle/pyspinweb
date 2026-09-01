mamba create -n pyspinweb python=3.14 jupyter jupyterlite jupyterlite-pyodide-kernel pybind11 cmake pyodide-build
mamba activate pyspinweb

git clone https://github.com/spglib/spglib
cd spglib
patch -p1 < ../diffs/spglib.diff
pyodide build

#CIBW_BUILD="cp314*" python -m cibuildwheel --output-dir wheelhouse --platform pyodide

git clone https://github.com/jamesrhester/pycifrw
cd pycifrw
pyodide build
cd ..

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
rustup install nightly
rustup default nightly
rustup target add wasm32-unknown-emscripten
git clone https://github.com/spinw/pyspinw
cd pyspinw
git clone https://github.com/m-ou-se/atomic-wait
cd atomic-wait
patch -p1 < ../../diffs/atomic-wait.diff
cd ..
patch -p1 < ../diffs/pyspinw.diff
pyodide build

mkdir -p pypi
find -name "*cp314-cp314-pyemscripten_2026_0_wasm32.whl" -exec cp '{}' pypi/
