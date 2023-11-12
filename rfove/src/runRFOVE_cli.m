function exitcode = runRFOVE_cli(areaUB, minAreaMaxAreaRatioUB, overlapUB, NeighborhoodSize, filesList)
addpath(genpath('MatlabCentral_IVC2020'));

close all;
clear all;
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

DataDirD{1} = 'Dataset_BBBC039//images//';
GTDirD{1} = 'Dataset_BBBC039//outlines//';
ResultsDirD{1} = 'RES_BBBC039//';

filesD{1} = [strcat(filesList, ' ')];

DATASET = 1;
DataDir = DataDirD{DATASET};
GTDir = GTDirD{DATASET};
ResultsDir = ResultsDirD{DATASET};

%RUN WHOLE DATASET
if exist('MFILE') == 0,
    files = filesD{DATASET};
    apo = 1;
    s = find(isspace(files)==1);
    data = cell(1,length(s));
    id = 1;
    j0 = 1;
else
    load(MFILE);
    j0 = j+1;
end
for j=j0:length(s),
    close all;
    eos = s(j);
    fname = files(apo:eos-1);
    fnameGT = fname;
    fnameGT(length(fnameGT)) = '1';
    apo = eos+1;
    imagePerRUN = j / length(s)
    fname
    
    [I] = imread(sprintf('%s%s.png',DataDir,fname));
    GT = imread(sprintf('%s%s.png',GTDir,fname));
    [ GT ] = correctGT( GT);
    
    [IClustTotal,totEll,INITSEG] = runMainAlgo(imgaussfilt(I,2),AICBIC_SELECTION,METHOD,METHODSEG,NeighborhoodSize,0.5,0);
    [REC, PR, F1, Overlap,BP,BDE,RECL,PRL,F1L,LGT] = getInitSegmentationStats(GT,INITSEG,IClustTotal);
    [Jaccard, MAD, Hausdorff, DiceFP,DiceFN,FP,FN,LGT] =getStats(GT,INITSEG,IClustTotal);
    imwrite(uint16(IClustTotal),sprintf('%s%s.tiff',ResultsDir,fname))
    
    close all;
    statsE{id} = totEll;
    Fnames{id} = fname;
    statsPan(id,1:9) = [REC, PR, F1, Overlap,BP,BDE,RECL,PRL,F1L];
    stats(id,1:7) = [Jaccard, MAD, Hausdorff, DiceFP,DiceFN,FP,FN];
    id = id+1;
    save(sprintf('%sAIC.mat', ResultsDir),'stats','statsE','statsPan','Fnames');
end

exitcode = 0;
