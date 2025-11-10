## Get Compiler
Get the binaries from amd repository:
```
https://repo.radeon.com/rocm/misc/flang/rocm-afar-8873-drop-22.2.0-alma.tar.bz2
```
```
tar -xvjf  rocm-afar-8873-drop-22.2.0-alma.tar.bz2
```

## Compiler Usage
```
ml LUMI/24.03 partition/G buildtools/24.03
module use /scratch/project_462000007/cristian/ELMER/ELMER_FLANG/modules
module load rocm/6.2.2
module load afar-8873-drop-22.2.0-alma
```

## First Install MPICH

```
wget https://www.mpich.org/static/downloads/3.4a2/mpich-3.4a2.tar.gz
tar -xvf mpich-3.4a2.tar.gz
```

or

```
cd mpich-3.4.a2
cd build
../configure CC=$(which amdclang) CXX=$(which amdclang++) FC=$(which amdflang) F77=$(which amdflang)  --prefix="/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/new_flang_comp/mpich-3.4a2-install"     --enable-fortran=all     --enable-cxx     --with-device=ch4:ofi     --with-libfabric=/opt/cray/libfabric/1.15.2.0     --with-hip=$ROCM_PATH --with-hip-sm='gfx90a' |& tee log.configure.txt

sed -i 's#wl=""#wl="-Wl,#g' libtool
```

Then 

```
make -j 
make  install
```

If all works make symbolic links to the system mpich libraries:
```
cd /scratch/project_462000007/cristian/ELMER/ELMER_FLANG/ELMER_MONDAY/
export wd=$PWD
mv $wd/mpich-3.4a2-install/lib $wd/mpich-3.4a2-install/lib-original
ln -s $CRAY_MPICH_DIR/lib $wd/mpich-3.4a2-install/lib
```

## Install ELMER with MPI, without ROCALUTION

```
export AMDFLANMG_MPICH_DIR=/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/cva_dump/rocm-afar-8873-drop-22.2.0/
export MPICH_DIR=/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/ELMER_MONDAY/mpich-3.4a2-install
```
```
git clone https://github.com/ElmerCSC/elmerfem.git  --recursive 
```
Cmake for ELMER:
```
cmake -C /scratch/project_462000007/cristian/ELMER/ELMER_FLANG/ELMER_MONDAY/afar.cmake  ../elmerfem/ -DCMAKE_INSTALL_PREFIX=/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/ELMER_MONDAY/elmer-install -DWITH_LUA=ON -DWITH_OpenMP=ON -Wno-dev -DWITH_MPI=ON -DBLAS_LIBRARIES="-L ${CRAY_LIBSCI_PREFIX}/lib -lsci_cray"      -DLAPACK_LIBRARIES="-L ${CRAY_LIBSCI_PREFIX}/lib -lsci_cray"
```
```
make -j 
make install
```
## Test Elmer
