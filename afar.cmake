SET(CMAKE_Fortran_COMPILER "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/llvm/bin/amdflang"  CACHE STRING "")
SET(CMAKE_C_COMPILER  "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/llvm/bin/amdclang"  CACHE STRING "")
SET(CMAKE_CXX_COMPILER  "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/llvm/bin/amdclang++"  CACHE STRING "")
SET(CMAKE_CXX_FLAGS_DEBUG "-g -fPIC" CACHE STRING "")
SET(CMAKE_C_FLAGS_DEBUG "-g -fPIC" CACHE STRING "")
SET(CMAKE_Fortran_FLAGS_DEBUG "-g -fPIC -I$ENV{AMDFLANG_MPICH_DIR}/include -I$ENV{MPICH_DIR}/include   -L$ENV{ROCM_PATH}/llvm/lib ->
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-g -O2 -fPIC" CACHE STRING "")
SET(CMAKE_C_FLAGS_RELWITHDEBINFO "-g -O2 -fPIC" CACHE STRING "")
SET(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-g -O2 -fPIC -I$ENV{AMDFLANG_MPICH_DIR}/include -I$ENV{MPICH_DIR}/include   -L$ENV{ROCM_PAT>
SET(MPI_C_COMPILER "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install/bin/mpicc" CACHE STRING "")
SET(MPI_CXX_COMPILER "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install/bin/mpicxx" CACHE STRING "") 
SET(MPI_Fortran_COMPILER "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install/bin/mpif90" CACHE STRING "")
SET(CMAKE_PREFIX_PATH "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install" CACHE STRING "")
SET(MPI_mpicxx_LIBRARY "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install/lib-original/libmpicxx.so" CA>
SET(CMAKE_LIBRARY_PATH "/appl/local/csc/soft/eng/elmer/rocm-afar-8873-drop-22.2.0/mpich-3.4a2-install" CACHE STRING "")
