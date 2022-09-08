#! /bin/bash

### Loop through years
for year in {2000..2020..1}; do
    echo ${year}

    ### Every ten years the filename changes?? Update filename prefix based on year
    if [ ${year} = 2000 ]; then
       MERRA_RAD='MERRA2_200.tavg1_2d_rad_Nx'
       MERRA_ASM='MERRA2_200.inst1_2d_asm_Nx'
    elif [[ ${year} = @(2001|2002|2003|2004|2005|2006|2007|2008|2009|2010) ]]; then
       MERRA_RAD='MERRA2_300.tavg1_2d_rad_Nx'
       MERRA_ASM='MERRA2_300.inst1_2d_asm_Nx'
    elif [[ ${year} = @(2011|2012|2013|2014|2015|2016|2017|2018|2019|2020) ]]; then
       MERRA_RAD='MERRA2_400.tavg1_2d_rad_Nx'
       MERRA_ASM='MERRA2_400.inst1_2d_asm_Nx'
    fi

    ### Loop through months
    for month in {01..12}; do
        ### Loop through days - obv. will fail sometimes because not all months
        ### have 31 days but it'll just fail and go to the next command
        for day in {01..31}; do
            ### Grab variable, select Australia, write to output directory
            cdo -L -b F64 -selvar,SWGDN -sellonlatbox,112,156,-8,-46 \
                /g/data/rr7/MERRA2/raw/M2T1NXRAD.5.12.4/${year}/${month}/${MERRA_RAD}.${year}${month}${day}.nc4 \
                SWGDN/SWGDN_${MERRA_RAD}.${year}${month}${day}.nc
            cdo -L -b F64 -selvar,DISPH,U2M,V2M,U10M,V10M,U50M,V50M \
                -sellonlatbox,112,156,-8,-46 \
                /g/data/ua8/MERRA2/1hr/M2I1NXASM.5.12.4/${year}/${month}/${MERRA_ATM}.${year}${month}${day}.nc4 \
                M2I1NXASM/M2I1NXASM_${MERRA_ATM}.${year}${month}${day}.nc
        done
    done
done
