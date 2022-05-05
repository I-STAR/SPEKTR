function [ filtration ] = spektrTuner( spectrum, mAs, measurements, source2distance, addedFilt, measurementFlag, varargin )
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      exposureFunction.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    15-Jun-2015
%%
%% 2015 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: [ SoSD ] = spetkrTuner(spectrum, mAs, exposure, SDD, addedFilt, measurementFlag [13 estimAl; 74 estimW] )
%%
%%  Inputs:
%%      spectrum - [150 x 1] vector each element with units photons / mAs / mm^2 at 100 cm from the source in 1 keV energy bin for energy bins over 0 - 150 keV.
%%      mAs - [N x 1] vector containing unique mAs measurements at constant kVp.
%%
%%      exposure - [N x 1] vector containing exposure measurements where exposure measurement i
%%                  is measured at the i^th mAs measurement.
%%                  ie. if the mAs vector were [ 0.2; 0.5; 0.25] and the exposure vector were
%%                      [0.75; 1.25; 0.80], the 0.2 mR exposure correspond to 0.75 mAs.
%%      SDD - scalar value containing the distance (mm) from the source to the detector.
%%
%%      addedFilt - [M x 2] vector where the first column is the atomic number of the element to be
%%                  filtered and the second column is the thickness of the element to be filtered.
%%
%%      measurementFlag - accepts either "exposure" or "air kerma" as a string. This flag describes the
%%                        measurement type contained in the variable "measurements".
%%      
%%      varargin - [1x2] vector containing the estimated thickness of Aluminum in the first position and
%%                 the estimated thickness of Tungsten (scalar) in the second. 
%%
%%                 
%%
%%                   
%%      ie. filters = spektrTuner(60, [1.2; 2; 0.5], [2.46; 4.54; .56], 744.8, [13 2; 29 0.2]);
%%
%%  Outputs:
%%      [2 x 2] vector containing the (column 1) atomic number of Al and W and (column 2) their corresponding thicknesses to match the measured
%%      to the computed spectrum.
%%
%%  Description:
%%      This function will find the filtration necessary for the computer to produce a spectrum
%%      that matches the measured spectrum
%%      
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  3.000    2015 06 15     JGP Initial Creation
%%*************************************************************************
%%
display('Calculating Tuning Filtration....');
if size(varargin, 2) == 0
    estimAl = 0;
    estimW = 0;
    
elseif size(varargin, 2) == 1
    estimates = varargin{:};
    if size(estimates,1) == 2
        estim1 = estimates(1,:);
        estim2 = estimates(2,:);
        if estim1(1) == 13
            estimAl = estim1(1,2);
            estimW = estim2(1,2);
        else
            estimW = estim1(1,2);
            estimAl = estim2(1,2);
        end
    else
        estimAl = estimates(1);
        estimW = estimates(2);
    end
else
    estimAl = 0;
    estimW = 0;
end

[filters] = fminsearch(@(x) exposureFunction(x, spectrum, mAs, measurements, source2distance, addedFilt, measurementFlag), [estimAl estimW]);

[filtration] = [13 filters(1); 74 filters(2)];
end

function [ SoSD ] = exposureFunction( x, spectrum, mAs, measurements, source2detector, addedFilt, measurementFlag )
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      exposureFunction.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    15-Jun-2015
%%
%% 2015 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: [ SoSD ] = exposureFunction( x, kVp, mAs, exposure, source2detector, addedFilt, measurementFlag )
%%
%%  Inputs:
%%      x -  [1 x 2] vector containing the inherent filtration that is in the filter across all mAs.
%%           Since this function is supposed to be used with fminsearch, this variable is anonymously
%%           called by fminsearch and is thus minimized.
%%      kVp - Scalar value of the potential of the tube.
%%      mAs - [N x 1] vector containing unique mAs measurements at the same kVp.
%%      exposure - [N x 1] vector containing exposure measurements where each element in the
%%                  vector corresponds to a mAs value in the same position in the mAs vector.
%%                  ie. if the mAs vector were [ 0.2; 0.5; 0.25] and the exposure vector were
%%                      [0.75; 1.25; 0.80], the 0.2 mR exposure would be the exposure with 0.75 mAs.
%%      source2detector - scalar value containing the distance (mm) from the source to the detector.
%%      addedFilt - [M x 2] vector where the first column is the atomic number of the element to be
%%                  filtered and the second column is the thickness of the element to be filtered.
%%                   
%%      ie. SoSD = exposureFunction(x, 60, [1.2; 2; 0.5], [2.46; 4.54; .56], 744.8, [13 2; 29 0.2]);
%%
%%  Outputs:
%%      The mean normalized square error between the measured exposure values inputted by the user and the 
%%      exposure values corresponding to the spectrum created with filtration in x.
%%
%%  Description:
%%      This function will find the filtration necessary to minimize the difference between the computer's
%%      exposure values and the user's measured exposure values.
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  3.000    2015 06 15     JGP Initial Creation
%%*************************************************************************
%%

%exposureFunction is used by spektrTuner to minimize the difference between
%the spectrum produced by spektrTuner and the experimental spectrum from
%the x-ray tube.
%This is a private function that will be used by spektrTuner
if strcmp(measurementFlag, 'exposure')
    for i = 1:size(mAs, 1)
        q = spectrum;    
        q_corrected = spektrBeers(q, [13 x(1); 74 x(2)]);
        qfiltered = spektrBeers(q_corrected, addedFilt);
        expo_sim(i,1) = spektrExposure(qfiltered) * mAs(i,1)* (1000/source2detector)^2;
    end
elseif strcmp(measurementFlag, 'airkerma')
    for i = 1:size(mAs, 1)
        q = spectrum;    
        q_corrected = spektrBeers(q, [13 x(1); 74 x(2)]);
        qfiltered = spektrBeers(q_corrected, addedFilt);
        expo_sim(i,1) = spektrAirKerma(qfiltered) * mAs(i,1)* (1000/source2detector)^2;
    end
end
percDiff = (measurements - expo_sim) ./ (expo_sim);
SoSD = sum(percDiff.^2);
end