#!/bin/tcsh

echo "Setting environment variables for CCPP-SCM on Cheyenne with icc/ifort"

set called=($_)

if ( "$called" != "") then  ### called by source
    set MYSCRIPT=`readlink -f -n $called[2]`
else                        ### called by direct execution of the script
    set MYSCRIPT=`readlink -f -n '$0'`
endif
set MYDIR=`dirname $MYSCRIPT`
set MYDIR=`cd $MYDIR && pwd -P`

setenv SCM_ROOT $MYDIR/../..

#start with a "clean" environment; activate and deactivate ncar_pylib in order to successfully deactivate previously activated environment without errors
module load ncarenv/1.3
conda deactivate
module purge

#load the modules in order to compile the CCPP SCM
echo "Loading intel and netcdf modules..."
module load ncarenv/1.3
module load intel/2022.1
module load mpt/2.25
module load ncarcompilers/0.5.0

echo "Setting up NCEPLIBS"
module use /glade/work/epicufsrt/GMTB/tools/intel/2022.1/hpc-stack-v1.2.0_6eb6/modulefiles/stack
module load hpc/1.2.0
module load hpc-intel/2022.1
module load hpc-mpt/2.25
setenv bacio_ROOT /glade/work/epicufsrt/GMTB/tools/intel/2022.1/hpc-stack-v1.2.0_6eb6/intel-2022.1/bacio/2.4.1
setenv sp_ROOT /glade/work/epicufsrt/GMTB/tools/intel/2022.1/hpc-stack-v1.2.0_6eb6/intel-2022.1/sp/2.3.3
setenv w3nco_ROOT /glade/work/epicufsrt/GMTB/tools/intel/2022.1/hpc-stack-v1.2.0_6eb6/intel-2022.1/w3nco/2.4.1

echo "Setting CC/CXX/FC environment variables"
setenv CC icc
setenv CXX icpc
setenv FC ifort

echo "Loading cmake"
module load cmake/3.22.0
setenv CMAKE_C_COMPILER icc
setenv CMAKE_CXX_COMPILER icpc
setenv CMAKE_Fortran_COMPILER ifort
setenv CMAKE_Platform cheyenne.intel

echo "Setting up python environment for running and plotting."
module load conda/latest