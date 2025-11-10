local version = "devel_eedab4232"
help([==[

Description
===========
ELMER is an open-source multi-physics Finite Element code provided by CSC


More information
================
 - Homepage: http://www.elmerfem.org
]==])

whatis([==[Description: ELMER is an open-source	multi-physics Finite Element code provided by CSC.]==])


local root = "/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/elmer-install"
-- local dependencies = "/appl/local/csc/soft/eng/elmer/gcc-native-13.2/cray-mpich-8.1.29/elmerdependencies/"
local ourmpi = "/scratch/project_462000007/cristian/ELMER/ELMER_FLANG/mpich"



if not ( isloaded("LUMI/24.03") ) then
    load("LUMI/24.03")                                                                                                       
end

if not ( isloaded("partition/G") ) then
    load("partition/G")
end                  

if not ( isloaded("rocm/6.2.2") ) then                                                                                              
 load("rocm/6.2.2")                                                                                                                 
end     

if not ( isloaded("afar-8873-drop-22.2.0-alma") ) then
    load("afar-8873-drop-22.2.0-alma")
end




-- if not ( isloaded("Boost/1.83.0-cpeGNU-24.03") ) then
--  load("Boost/1.83.0-cpeGNU-24.03")
-- end 

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "share/elmersolver/lib"))
-- prepend_path("LD_LIBRARY_PATH", pathJoin(dependencies, "lib64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(ourmpi, "lib"))
-- prepend_path("LD_LIBRARY_PATH", pathJoin(dependencies, "rocALUTION_pbc/lib"))

prepend_path("PATH", pathJoin(root, "bin"))
-- prepend_path("PATH", pathJoin(dependencies, "bin"))
setenv("ELMER_HOME", root)
-- setenv("ELMER_DEP", dependencies)


if (mode() == "load") then

  LmodMessage("######################################")
  LmodMessage("# Elmer 9.0 (",version,")") 
  LmodMessage("#            environment loaded")
  LmodMessage("# ")
  LmodMessage("# EEEEE LL     MM   MM EEEEE RRRR")
  LmodMessage("# EE    LL     MMM MMM EE    RR  R")
  LmodMessage("# EEE   LL     MM M MM EEE   RRRR")
  LmodMessage("# EE    LL     MM   MM EE    R R")
  LmodMessage("# EEEEE LLLLLL MM   MM EEEEE R  R")
  LmodMessage("# ")
  LmodMessage("# date: 11-03-25 15:50 EET")
  LmodMessage("# this version includes")
  LmodMessage("# * Elmer/Ice")
  LmodMessage("# * Hypre")
  LmodMessage("# * Mumps")
  LmodMessage("# * rocALUTION (MPI,HIP)")
  LmodMessage("# * NetCDF (GridDataReader)")
  LmodMessage("# * MMG")
  LmodMessage("# * Zoltan")
  LmodMessage("# * Lua")
  LmodMessage("# * ScatteredDataInterpolator (CSA,NN)")  
  LmodMessage("#   ")
  LmodMessage("# OpenMP is enabled")
  LmodMessage("# In case of problems: zwinger@csc.fi")
  LmodMessage("######################################")


end



