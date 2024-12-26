#!bin/bash
antsApplyTransformsToPoints -d 3 -i CSV.csv -o TCSV.csv -t [/result0GenericAffine.mat,1] -t /result1InverseWarp.nii.gz

