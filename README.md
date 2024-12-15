# Tools_and_Codes_for_Single_Neuron_Construction


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
### stepC-1-b_Soma filtering
1. Open and edit the run.bat file, modifying the two directories as needed, then save and double-click run.bat to execute it.
2. After a few seconds, a window will appear.
3. Use the mouse scroll wheel to change frames; the up arrow key increases the frame rate, while the down arrow key decreases it.
4. Press the "N" key to sequentially jump to frames with somas.
5. Press and hold the left mouse button to adjust the window width by dragging up and down, and adjust the window level by dragging left and right.
### stepC-1-c_Soma splitting
1. Place the FNT file containing all soma location information (e.g., Total somas.fnt) in the same directory.
2. Open and edit the split.bat file, setting folder=Total somas, then save and double-click split.bat to execute it.
3. Upon completion, a folder named Total somas will be created in the same directory, containing all the split individual soma FNT files (e.g., 001.fnt;002.fnt...) .
## Procedure_stepD_Image registration
### stepD-1-a_CH00PI 
1.Run the conv.bat
### stepD-2-ab_Obtain moving mask and fix mask
1.Run the moving_mask.py and the .fix_mask.py
### stepD-3-a_Registration
```
    bash antsRegistrationSyN.sh -d 3 -t s -n 20 -f ./fix.tif -m ./moving.tif -o ./result
```
* -d Specifies the dimension of the image data
* -t Specifies the type of transformation used for registration
* -n Specifies the number of threads used during the registration process
* -f The path to the fixed image
* -m The path to the moving image
* -o he prefix for the output results
### stepD-4-a_Neuron dataset registration
antsApplyTransformsToPoints -d 3 -i CSV.csv -o TCSV.csv -t [/result0GenericAffine.mat,1] -t /result1InverseWarp.nii.gz
* -d Dimension Parameter
* -i Input Point file
* -o Output Point file
* -t affine transformation file
* -t nonlinear transformation file


