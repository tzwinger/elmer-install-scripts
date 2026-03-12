whatis("Name: mpich-clangnew")
whatis("Version: 4.1.3")
whatis("Category: library")
whatis("URL: https://www.mpich.org/static//downloads/4.1.3/mpich-4.1.3.tar.gz")

local base = "/project/project_462000007/tzwinger/Elmer-clang-afar/install/mpich-4.1.3"


prepend_path("LD_LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(base, "lib"))
prepend_path("C_INCLUDE_PATH", pathJoin(base, "include"))
prepend_path("CPLUS_INCLUDE_PATH", pathJoin(base, "include"))
prepend_path("CPATH", pathJoin(base, "include"))
prepend_path("PATH", pathJoin(base, "bin"))
prepend_path("INCLUDE", pathJoin(base, "include"))
prepend_path("MANPATH", pathJoin(base, "share", "man"))
--prepend_path("MODULEPATH",pathJoin(mbase, "Compiler", compiler))
