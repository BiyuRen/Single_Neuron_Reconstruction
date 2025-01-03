# Tools_and_Codes_for_Single_Neuron_Reonstruction


## Procedure_stepA_fMOST image preprocessing
### stepA-1 cut the fMOST image into cubes
1. Download FNT from http://bap.cebsit.ac.cn/FNT/fnt-0.99.114-ubuntu.zip and unzip the package.
2. Run the following command 
```
    fnt-slice2cube -i list.txt -r 0.325:0.325:1 -c 256:256:83 -d 62:62:20 -o cubes -j 48 -M -Y
```
* -i list.txt --input-list=FILE.
* -r 0.325:0.325:1 --resolution=XRES:YRES:ZRES.
* -c 256:256:83 --cube-size=WIDTH:HEIGHT:DEPTH
* -d 62:62:20 --downsample-factor=DSX:DSY:DSZ
* -o cubes --output-directory=DIR
* -j 48 --jobs[=N]
* -M --max-intensity
* -Y --yes Skip confirmation

### stepA-2 compress all the cubes
1. Create a mask of the brain.
2. Update conv2hevc.sh with the sample infomation.
3. Run the following command
```
    ./conv2hevc.sh 0/1
```

## Procedure_stepC_Single-neuron tracing
### stepC-1-b_Soma localization
1. Open and edit the run.bat file, modifying the two directories as needed, then save and double-click run.bat to execute it.
2. After a few seconds, a window will appear.
3. Use the mouse scroll wheel to change frames; the up arrow key increases the frame rate, while the down arrow key decreases it.
4. Press the "N" key to sequentially jump to frames with somas.
5. Press and hold the left mouse button to adjust the window width by dragging up and down, and adjust the window level by dragging left and right.
### stepC-1-c_Soma splitting
1. Place the FNT file containing all soma location information (e.g., total_somas.fnt) in the same directory.
2. Open and edit the split.bat file, setting folder=total_somas, then save and double-click split.bat to execute it.
3. Upon completion, a folder named total_somas will be created in the same directory, containing all the split individual soma FNT files (e.g., 001.fnt;002.fnt...) .
## Procedure_stepD_Quality control
### stepD-2-a_Lint
1. Collect all single-neuron tracing results of the same sample into a folder, which is named “merge”, and place it in the same path as lint.bat.
2. Double-click to run lint.bat and wait for the execution to complete.
3. After successful execution, open the file with the COLLISION.fnt extension in the lint folder using the FNT software. Locate the highlighted areas and analyze them. If there are tracing errors, you can make modifications to individual tracing files within the split folder.

## Procedure_stepE_Image registration
### stepE-1-a_CH00PI 
1. Run the conv.bat
### stepE-2-ab_Mask obtaining
1. Run the sample_mask.py and the template_mask.py
### stepE-3-a_Registration
```
    bash antsRegistrationSyN.sh -d 3 -t s -n 20 -f ./sample.tif -m ./template.tif -o ./result
```
* -d Specifies the dimension of the image data
* -t Specifies the type of transformation used for registration
* -n Specifies the number of threads used during the registration process
* -f The path to the sample image
* -m The path to the template image
* -o he prefix for the output results
## Procedure_stepF_Transformation
antsApplyTransformsToPoints -d 3 -i CSV.csv -o TCSV.csv -t [/result0GenericAffine.mat,1] -t /result1InverseWarp.nii.gz
* -d Dimension Parameter
* -i Input Point file
* -o Output Point file
* -t affine transformation file
* -t nonlinear transformation file


