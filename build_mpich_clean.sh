#!/bin/bash
# Clean MPICH build with all fixes for ROCm AFAR 22.3.0
#
# IMPORTANT: Load environment before running:
#   module load LUMI/25.09 partition/L
#   module load rocm/6.3.4
#   module use /users/igorpasi/work/lumi-support/modulefiles
#   module load rocm-afar/22.3.0
#   module load buildtools

set -e

source setenv-clang-afar.sh

MPICH_SRC_DIR="/project/project_462000007/tzwinger/Elmer-clang-afar/mpich-4.1.3"
MPICH_BUILD_DIR="$MPICH_SRC_DIR/build"
MPICH_INSTALL_DIR="/project/project_462000007/tzwinger/Elmer-clang-afar/install/mpich-4.1.3"

# Check environment
if [ -z "$ROCM_PATH" ]; then
    echo "ERROR: ROCM_PATH not set!"
    echo "Please load ROCm modules first:"
    echo "  module load rocm/6.3.4"
    echo "  module use /users/igorpasi/work/lumi-support/modulefiles"
    echo "  module load rocm-afar/22.3.0"
    exit 1
fi

if ! command -v amdclang &> /dev/null; then
    echo "ERROR: amdclang compiler not found!"
    echo "Please load rocm-afar module:"
    echo "  module use /users/igorpasi/work/lumi-support/modulefiles"
    echo "  module load rocm-afar/22.3.0"
    exit 1
fi

echo "Environment check:"
echo "  ROCM_PATH: $ROCM_PATH"
echo "  CC: $(which amdclang)"
echo "  CXX: $(which amdclang++)"
echo "  FC: $(which amdflang)"
echo ""

echo "=== MPICH Clean Build with ROCm AFAR 22.3.0 Fixes ==="
echo

# Step 1: Clean previous build
echo "[1/6] Cleaning previous build..."
if [ -d "$MPICH_BUILD_DIR" ]; then
    echo "  Removing old build directory..."
    rm -rf "$MPICH_BUILD_DIR"
fi
mkdir -p "$MPICH_BUILD_DIR"
echo "  Done: Build directory cleaned"

# Step 2: Apply source fixes BEFORE configure
echo "[2/6] Applying source code fixes..."

# Fix HIP API - mpl_gpu_hip.c (all copies)
echo "  Fixing HIP API in mpl_gpu_hip.c files..."
MPL_GPU_HIP_FILES=$(find "$MPICH_SRC_DIR/src" -name "mpl_gpu_hip.c" -type f 2>/dev/null)
if [ -n "$MPL_GPU_HIP_FILES" ]; then
    while IFS= read -r file; do
        if grep -q "device_attr\.memoryType" "$file" 2>/dev/null; then
            [ ! -f "$file.backup" ] && cp "$file" "$file.backup"
            sed -i 's/device_attr\.memoryType/device_attr.type/g' "$file"
        fi
    done <<< "$MPL_GPU_HIP_FILES"
    echo "    Done: Fixed mpl_gpu_hip.c files"
else
    echo "    Warning: No mpl_gpu_hip.c files found"
fi

# Fix HIP API - yaksa
echo "  Fixing HIP API in yaksa module..."
YAKSA_HIP_FILE="$MPICH_SRC_DIR/modules/yaksa/src/backend/hip/pup/yaksuri_hipi_get_ptr_attr.c"
if [ -f "$YAKSA_HIP_FILE" ]; then
    if grep -q "\.memoryType" "$YAKSA_HIP_FILE" 2>/dev/null; then
        [ ! -f "$YAKSA_HIP_FILE.backup" ] && cp "$YAKSA_HIP_FILE" "$YAKSA_HIP_FILE.backup"
        sed -i 's/\.memoryType/.type/g' "$YAKSA_HIP_FILE"
        echo "    Done: Fixed yaksa HIP API"
    fi
else
    echo "    Warning: Yaksa file not found"
fi

# Fix SLURM API
echo "  Fixing SLURM API compatibility..."
SLURM_FILE="$MPICH_SRC_DIR/src/pm/hydra/lib/tools/bootstrap/external/slurm_query_node_list.c"
if [ -f "$SLURM_FILE" ]; then
    if grep -q "hostlist_t hostlist;" "$SLURM_FILE" 2>/dev/null; then
        [ ! -f "$SLURM_FILE.backup" ] && cp "$SLURM_FILE" "$SLURM_FILE.backup"
        sed -i 's/hostlist_t hostlist;/hostlist_t *hostlist;/g' "$SLURM_FILE"
        echo "    Done: Fixed SLURM API"
    fi
else
    echo "    Warning: SLURM file not found"
fi

echo "  Done: All source fixes applied"

# Step 3: Configure
echo "[3/6] Running configure..."
cd "$MPICH_BUILD_DIR"
echo "  Install prefix: $MPICH_INSTALL_DIR"
echo "  Compilers: amdclang, amdclang++, amdflang"
echo "  This may take several minutes..."
echo ""
../configure \
    CC=$(which amdclang) \
    CXX=$(which amdclang++) \
    FC=$(which amdflang) \
    F77=$(which amdflang) \
    --prefix="$MPICH_INSTALL_DIR" \
    --enable-fortran=all \
    --enable-cxx \
    --with-device=ch4:ofi \
    --with-libfabric=/opt/cray/libfabric/1.22.0 \
    --with-hip=$ROCM_PATH \
    --with-hip-sm='gfx90a' \
    2>&1 | tee configure.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo ""
    echo "  Done: Configure completed successfully"
else
    echo ""
    echo "  ERROR: Configure failed! Check $MPICH_BUILD_DIR/configure.log"
    exit 1
fi

# Step 4: Fix libtool
echo "[4/6] Patching libtool..."

# Fix: wl parameter for Cray wrappers
if grep -q 'wl=""' libtool; then
    echo "  Fixing wl parameter for Cray compiler wrappers..."
    sed -i 's#wl=""#wl="-Wl,"#g' libtool
    echo "    Done: wl parameter fixed"
else
    echo "    Done: wl parameter already correct"
fi

echo "  Done: Libtool patched"

# Step 5: Build
echo "[5/6] Building MPICH..."
echo "  Building with 32 parallel jobs..."
echo "  This will take 10-20 minutes..."
echo ""
make -j 32 2>&1 | tee build.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo ""
    echo "  Done: Build completed successfully!"
else
    echo ""
    echo "  ERROR: Build failed! Check $MPICH_BUILD_DIR/build.log"
    echo "    Last 50 lines of build log:"
    tail -50 build.log
    exit 1
fi

# Step 6: Verify build
echo "[6/6] Verifying build..."
if [ -f "lib/.libs/libmpi.so" ]; then
    echo "  Done: libmpi.so built successfully"
    ls -lh lib/.libs/libmpi.so* | head -3
else
    echo "  ERROR: libmpi.so not found!"
    exit 1
fi

echo
echo "=== Build Summary ==="
echo "Source directory: $MPICH_SRC_DIR"
echo "Build directory:  $MPICH_BUILD_DIR"
echo "Install prefix:   $MPICH_INSTALL_DIR"
echo "Libraries built:"
find lib/.libs -name "*.so" -type f | wc -l | xargs echo "  Shared libraries:"
echo
echo "To install:"
echo "  cd $MPICH_BUILD_DIR"
echo "  make install"
echo
echo "After installation, add to your environment:"
echo "  export PATH=$MPICH_INSTALL_DIR/bin:\$PATH"
echo "  export LD_LIBRARY_PATH=$MPICH_INSTALL_DIR/lib:\$LD_LIBRARY_PATH"
