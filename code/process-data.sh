#!/bin/bash

# process cosmo-clm output data with CDO operators
# Robert Wright
# 15.07.23

CDO=$(which cdo)
CDOFLGS="-L -O -f nc4"

for res in 1 05 02
do
    # DOESN'T WORK:
    # ADJUST REGION (REMOVE EDGES WITH ARTEFACTS)
    # cut seven (!) grid points on each side in lowest resolution
    # and adjust higher resolution cases accordingly
    # synthax: index of first lon/lat, index of last lon/lat
    #          index starts with 1
    #case $res in
        #1)
        # (56x46)
        #cdobox="-selindexbox,8,49,8,39"
        #;;
        
        #05)
        # points=8000 (100x80)
        #cdobox="-selindexbox,15,86,15,66"
        #;;
        
        #02)
        # points=64400 (280x230)
        #cdobox="-selindexbox,36,244,36,194"
        #;;
    #esac
    
    # cut edges of region based on longitude/latitude on regular grid
    cdobox="-sellonlatbox,-17,33,36,67"

    SIMPATH=/home/rw0064fu/models/weather/project/simulations/europe-${res}deg/ANALYSIS/MERGED
    OUTPATH=/home/rw0064fu/models/weather/project/output
    
    IFILE="${SIMPATH}/out1_sfc.nc"
    
    # field mean of total precipitation
    OFILE="${OUTPATH}/totprec_${res}deg_fldmean.nc"
    $CDO $CDOFLGS -fldmean -selname,tot_prec $cdobox $IFILE $OFILE
    
    # select region and variable from simulation output
    OFILE="${OUTPATH}/totprec_${res}deg.nc"
    $CDO $CDOFLGS -selname,tot_prec $cdobox $IFILE $OFILE
    
    # time mean of (daily) total precipitation of UNCROPPED regions
    OFILE="${OUTPATH}/totprec_${res}deg_nocrop_timmean.nc"
    $CDO $CDOFLGS -timmean -selname,tot_prec $IFILE $OFILE
    
    # time mean of (daily) total precipitation
    OFILE="${OUTPATH}/totprec_${res}deg_timmean.nc"
    $CDO $CDOFLGS -timmean -selname,tot_prec $cdobox $IFILE $OFILE
    
    # DOESN'T WORK:
    # meridional sum of (daily) total precipitation
    #OFILE="${OUTPATH}/totprec_${res}deg_zonsum.nc"
    #$CDO $CDOFLGS -mersum -selname,tot_prec $cdobox $IFILE $OFILE

done
