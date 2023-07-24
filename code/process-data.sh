#!/bin/bash

# process cosmo-clm output & era5 reanalysis data with CDO operators
# Robert Wright
# 15.07.23

CDO=$(which cdo)
CDOFLGS="-L -O -f nc4"

OUTPATH=/home/rw0064fu/models/weather/project/output

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
    
    # cut edges of region based on longitude/latitude on regular grid (!)
    cdobox="-sellonlatbox,-17,33,36,67"

    SIMPATH=/home/rw0064fu/models/weather/project/simulations/europe-${res}deg/ANALYSIS/MERGED
    
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
    
    # field mean of large-scale precipitation (gsp)
    # add large-scale rainfall and large-scale snowfall
    OFILE="${OUTPATH}/gsp_totprec_${res}deg_fldmean.nc"
    $CDO $CDOFLGS -fldmean -expr,"gsp=rain_gsp+snow_gsp;" $cdobox $IFILE $OFILE
    # field mean of convective precipitation (con)
    OFILE="${OUTPATH}/con_totprec_${res}deg_fldmean.nc"
    $CDO $CDOFLGS -fldmean -expr,"con=rain_con+snow_con;" $cdobox $IFILE $OFILE
    
    # large-scale precipitation (gsp)
    OFILE="${OUTPATH}/gsp_totprec_${res}deg.nc"
    $CDO $CDOFLGS -expr,"gsp=rain_gsp+snow_gsp;" $cdobox $IFILE $OFILE
    # convective precipitation (con)
    OFILE="${OUTPATH}/con_totprec_${res}deg.nc"
    $CDO $CDOFLGS -expr,"con=rain_con+snow_con;" $cdobox $IFILE $OFILE
    
done
exit

# prepare era5 reanalysis data (to be used as reference)

# total precipitation (1hr output) ---------------------
IFILE="/daten/reana/arch/reanalysis/reanalysis/FUB/IFS/ERA5-FC/1hr/atmos/nocftp/r1i1p1/nocftp_1hr-era5_reanalysis_era5-fc_r1i1p1_19900101-19900131.nc"
ROTGRID="${OUTPATH}/grid-rot-02deg.txt"

# daily precipitation sum & select region
OFILE="${OUTPATH}/era5_nocftp.nc"
$CDO $CDOFLGS -daysum $cdobox -remapbil,$ROTGRID $IFILE $OFILE
# field mean of daily precipitation sum
OFILE="${OUTPATH}/era5_nocftp_fldmean.nc"
$CDO $CDOFLGS -fldmean -daysum $cdobox -remapbil,$ROTGRID $IFILE $OFILE
# time mean of daily precipitation sum
OFILE="${OUTPATH}/era5_nocftp_timmean.nc"
$CDO $CDOFLGS -timmean -daysum $cdobox -remapbil,$ROTGRID $IFILE $OFILE

# large-scale & convective precipitation ---------------
# field mean of daily large-scale precipitation sum
IFILE="/daten/reana/arch/reanalysis/reanalysis/FUB/IFS/ERA5-FC/1hr/atmos/nocflsp/r1i1p1/nocflsp_1hr-era5_reanalysis_era5-fc_r1i1p1_19900101-19900131.nc"
OFILE="${OUTPATH}/era5_nocflsp_fldmean.nc"
$CDO $CDOFLGS -fldmean -daysum $cdobox -remapbil,$ROTGRID $IFILE $OFILE
# field mean of daily convective precipitation sum
IFILE="/daten/reana/arch/reanalysis/reanalysis/FUB/IFS/ERA5-FC/1hr/atmos/prc/r1i1p1/prc_1hr-era5_reanalysis_era5-fc_r1i1p1_19900101-19900131.nc"
OFILE="${OUTPATH}/era5_prc_fldmean.nc"
$CDO $CDOFLGS -fldmean -daysum $cdobox -remapbil,$ROTGRID $IFILE $OFILE



