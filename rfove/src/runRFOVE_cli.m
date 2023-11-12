function exitcode = runRFOVE_cli(areaUB, minAreaMaxAreaRatioUB, overlapUB, NeighborhoodSize, inputFile, outputFile)
addpath(genpath('MatlabCentral_IVC2020'));

%IMPLEMENTATION RFOVE method [1]
% [1] C. Panagiotakis and A.A. Argyros, "Region-based Fitting of Overlapping Ellipses and its 
% Application to Cells Segmentation", Image and Vision Computing, Elsevier, vol. 93, pp. 103810, 2020.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Method Selection
%Set METHOD = 0 to only test the Segmentation Stage, 
%Set METHOD = 1 to run DEFA method, 
%Set METHOD = 2 to run AEFA method, 
%else you run EMAR method  
%Set METHODSEG = 0  to run ICPR 2010 method
%Set METHODSEG = 1  to run OTSU method
%Set METHODSEG = 2 to run Adaptive Thresh method, [2]
%Set METHODSEG = 3 to run Adaptive Thresh+extra method LADA+ [2], 
%Set METHODSEG = 4 to run ICIP 2018 method [2],
%[2] C. Panagiotakis and A. Argyros, Cell Segmentation via Region-based Ellipse Fitting, IEEE International Conference on Image Processing, 2018.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% SET PARAMETERS (selected for Dataset NIH3T3)

METHOD = 1; 
METHODSEG = 4;
global Constraints
Constraints = [areaUB minAreaMaxAreaRatioUB overlapUB]; 
%Constraints(1) = areaLim ( < 250)
%Constraints(2) = min area / max area ratio e.g. < 0.1 
%Constraints(3) = max overlaping > 0.2

AICBIC_SELECTION = 1; %Set AICBIC_SELECTION = 1, to use AIC is selected else BIC is used

set(0,'DefaultFigureColormap',jet);

[I] = imread(inputFile);

[IClustTotal,totEll,INITSEG] = runMainAlgo(imgaussfilt(I,2),AICBIC_SELECTION,METHOD,METHODSEG,NeighborhoodSize,0.5,0);
imwrite(uint16(IClustTotal), outputFile)
 
close all;
exitcode = 0;
