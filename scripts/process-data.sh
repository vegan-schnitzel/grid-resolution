#!/bin/bash

# Process model output data with CDO operators
# Robert Wright
# 15.07.23

CDO=$(which cdo)
CDOFLGS="-L -O -f nc4"

for res in 02 05 1
do
    SIMPATH=/home/rw0064fu/models/weather/project/simulations/europe-${res}deg/ANALYSIS/MERGED
    OUTPATH=/home/rw0064fu/models/weather/project/output

    # field sum of total precipitation
    IFILE="${SIMPATH}/out1_sfc.nc"
    OFILE="${OUTPATH}/totprec_${res}deg_fldsum.nc"
    $CDO $CDOFLGS -fldsum -selname,tot_prec $IFILE $OFILE
    
    # time sum of (daily) total precipitation
    OFILE="${OUTPATH}/totprec_${res}deg_timsum.nc"
    $CDO $CDOFLGS -timsum -selname,tot_prec $IFILE $OFILE
    
    # meridional sum of (daily) total precipitation
    OFILE="${OUTPATH}/totprec_${res}deg_zonsum.nc"
    $CDO $CDOFLGS -mersum -selname,tot_prec $IFILE $OFILE
done
