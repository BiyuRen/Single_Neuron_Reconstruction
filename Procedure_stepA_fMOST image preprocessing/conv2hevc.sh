#!/bin/bash

SIZE=30740*22005*12300
CUBE_SIZE=256*256*83
CUBES="/home/wangxf/data/242355/cubes"
OUTCUBES=$CUBES
MASK="242355mask.nrrd"

IFS='* ' read SIZE_x SIZE_y SIZE_z <<< $SIZE
IFS='* ' read CUBE_SIZE_x CUBE_SIZE_y CUBE_SIZE_z <<< $CUBE_SIZE
JOB_SPEC="$1"; shift;
IFS='/ ' read JOB_i JOB_n c <<< $JOB_SPEC

usage () {
        echo "$0 i/N"
}
if [ x"$JOB_i" = x ]; then usage; exit -1; fi
if [ x"$JOB_n" = x ]; then usage; exit -2; fi
if [ "$JOB_i" -lt 0 ]; then usage; exit -3; fi
if [ "$JOB_n" -le 0 ]; then usage; exit -4; fi
if [ "$JOB_i" -ge "$JOB_n" ]; then usage; exit -5; fi

z=`printf '%08d' $((JOB_i*CUBE_SIZE_z))`
zend=`printf '%08d' $SIZE_z`
while [ 1"$z" -lt 1"$zend" ]; do
        zz=`expr "1$z" - 100000000`
        zzz=`expr "1$z" + $CUBE_SIZE_z - 100000000`
        zzzz=`expr "1$z" + $CUBE_SIZE_z + $CUBE_SIZE_z - 100000000`
        znext=`printf '%08d' "$zzzz"`

        if [ "1$znext" -lt 1"$zend" ]; then
                fnext="$CUBES/ch00/z$znext/y00000000.x00000000.nrrd"
        else
                fnext="$CUBES/catalog"
        fi

        echo "Wait $z ($fnext)..."
        while [ ! -e "$fnext" ]; do
                sleep 1
        done

        echo "Convert $z..."
        if [ -e "$OUTCUBES/ch00hevc/z${z}.ok" ]; then
                echo "Skip $z."
        else
                ~/fnt-cube2h265 -m $MASK -x 0:$CUBE_SIZE_x:$SIZE_x -y 0:$CUBE_SIZE_y:$SIZE_y -z $zz:$CUBE_SIZE_z:$zzz -s $SIZE_x:$SIZE_y:$SIZE_z ~/fnt-scripts/TAppEncoderHighBitDepthStatic "$CUBES/ch00/z<08Z>/y<08Y>.x<08X>.nrrd" "$OUTCUBES/ch00hevc/z<08Z>/y<08Y>.x<08X>.hevc" 
                if [ $? -eq 0 ]; then
                        touch "$OUTCUBES/ch00hevc/z${z}.ok"
                        echo "Finished $z."
                else
                        echo "Unfinished $z."
                fi
        fi

        zz=`expr "1$z" + $((CUBE_SIZE_z*JOB_n)) - 100000000`
        z=`printf '%08d' $zz`
done