# Author: SHIXIAOXUE
# Purpose: merge 19 manually labeled brain images with different gray values
import os
import numpy as np
import tifffile
import SimpleITK as sitk
filepath=r'../../resource/19 manually labeled brain images'
output=r'../../resource/result'

structureValue = [128,200,170,255,180,170,60,255,255,255,230,255,255,255,255,255,60,40,100]#gray values
count=0
for regions in os.listdir(filepath):
    brainpath=os.path.join(filepath,regions)
    print(brainpath)
    tif = tifffile.imread(brainpath)
    if count==0:
        sample = np.zeros_like(tif)
    sample[tif > 0] = structureValue[count]
    count+=1
x1 = sample[::2, ::2, ::2]# downsample to 20um

new_tif_dir =os.path.join(output,'moving.tif')
tifffile.imwrite(new_tif_dir,x1)





