function s = spektrSpectrum(energy, varargin)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrSpectrum.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    15-Jun-2015
%%
%% 2015 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: f = spektrSpectrum(energy, [Al_Thickness kV_ripple], spectral_model, normalize)
%%
%%  Inputs:
%%      energy [kVp]- integer between 1-150 kVp (required)
%%      Al_Thickness - aluminum thickness (mm) (optional) 
%%      kV_ripple - kV ripple [%] (optional)
%%      spectral_model - either 'TASMICS' or 'TASMIP' as a string (optional, default is 'TASMICS'),
%%      normalize - 0 for no normalization, 1 for normalization (optional; default is 1)        
%%
%%      ie. q = spektrSpectrum(120);
%%          normalized TASMICS spectrum with 1.6 mm Al inherent filtration and scaled
%%          to match the tube output (mR/mAs) of TASMIP at 120 kV
%%      ie. q = spektrSpectrum(120, [0 0], 'TASMICS', 0);
%%          un-normalized TASMICS spectrum with 0 mm Al inherent filtration and 0% kV ripple
%%      ie. q = spektrSpectrum(120, [0 0], 'TASMIP', 0);
%%          TASMIP spectrum with 1.6 mm Al inherent filtration and 0% kV ripple.   
%%
%%  Outputs:
%%      X-ray Energy Spectrum, which is a 150x1 matrix, each matrix
%%          element representing the # of photons / mAs / mm^2 at 100 cm from the source
%%          for 1 keV energy bins (bins range from 1-150 keV)
%%
%%
%%  Description:
%%      This function will generate an x-ray spectra at the specified 
%%      potential (of the generator) using the specified spectral model ("TASMIP" or "TASMICS")
%%      given an x-ray system that is set to a constant 1 mAs.
%%      Normalization between TASMICS and TASIMP is achieved by scaling TASMICS to the tube output
%%      (mR/mAs) of TASMIP and matching the inherent filtration of the two models. This was done 
%%      to allow TASMICS to best match the TASMIP model. For more information on the normalization,
%%      see the Technical Note within the attached file.
%%  
% This function will generate an unfiltered x-ray spectra at the specified 
% potential (of the generator), given an x-ray system is set to a constant 1 mAs.
%
% The input argument "energy" will have to be an integer, between 10-140 [keV].
% Using the tungsten anode spectra model interpolating polynomials (tasmip) algorithm, 
% coefficients a0, a1, a2, a3 were generated for 131 energy bins, from 10 to 140 [keV].
%
% These coefficients are stored in the following files tasmip.txt, tasmip.mat as a 
% 4x150 matrix (where energy bins from 0-9 & 141-150kV were set to zero.
% Using the following expression the unfiltered x-ray spectra can be generated;
%
% q(E)= a0 + a1*(energy) + a2*(energy).^2 + a3*(energy).^3 
%
% Input Parameters: Energy [kVp] (required), Aluminum filter thickness within x-ray
%                   tube [mm] (optional)
%
% ie. q = spektrSpectrum(120); or q = spektrSpectrum(120,1);
%
% Output Parameters: X-ray Energy Spectrum, which is a 150x1 matrix, each matrix
%                    element representing the # of photons per energy bin (using 1 
%                    keV bins, from 1-150 keV)
%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  0.000    2003 05 01     AW  Initial code
%%	1.000    2004 03 15     DJM Released version
%%	2.000    2006 04 19     DJM Removed XLSread and replaced with .MAT
%%  3.000    2015 05 25     JGP Included TASMICS implementation
%%*************************************************************************
%%
m = matfile('spektrScaleFactors.mat');
dat = load('spektrTASMICSdata.mat');
normalizationFactor = m.factors;

% Generate unfiltered x-ray spectra q
if (energy<20);
    MICSspect = zeros(150,1);
else
    MICSspect = dat.spTASMICS(:,fix(energy-20)+1);
end

inherentTASMIPfilt = 1.6;
normalize = 1;
useTASMICS = 1;
if isempty(varargin) == 1
    
    q = normalizationFactor(energy) * spektrBeers(MICSspect, [13 inherentTASMIPfilt]);

elseif size(varargin, 2) == 3
    if varargin{3} == 0
        normalize = 0;
    end
    if strcmp(varargin{2}, 'TASMIP') == 1
        useTASMICS = 0;
    end
    
elseif size(varargin, 2) == 2
    if strcmp(varargin{2}, 'TASMIP') == 1
        useTASMICS = 0;
    end
end

if size(varargin, 2) > 0        
     
    alFiltAndRipple = varargin{1};   %This takes the Al thickness and the kV ripple, which should have been put in as a vector, and stores it in alFiltAndRipple as a vector.
    alFilt = alFiltAndRipple(1,1);   %Get Al filter thickness
    			        
    % check if the ripple is provided 
    % this conditional accnts for the case of a ripple and no finite
    % filter thickness

        if length(alFiltAndRipple)== 2   %If both the filter and the ripple are entered
            alFilt = alFiltAndRipple(1,1); 
            if alFiltAndRipple(1,2)== 0
                % if a Al filter thickness is entered with a 0% ripple, then filter the unfiltered spectrum, no ripple considered
                if useTASMICS == 0
                    q = spektrSpectrum_fcn(energy, alFilt);
                else
                    q = spektrBeers(MICSspect, [13 alFilt]);
                    if normalize == 1
                        q = spektrBeers(q, [13 inherentTASMIPfilt]);
                        q = normalizationFactor(energy) * q;
                    end
                end
            else               
            % ripple can now be calculated
                d_ripple = 0.01*energy*alFiltAndRipple(1,2); % ripple size
                energy_ripple = energy - d_ripple; % minimum energy due to ripple
                temp_spectrum(150,1) = 0; % initialize a temporary x-ray spectra matrix [150x1]
                steps = 20; % constant -> constraint on for loop
                if useTASMICS == 0 
                    for i=1:1:steps,
                        t=(pi/steps)*i;
                        factor = abs(sin(t)); % typical kilovoltage waveform
                        energy_temp = energy_ripple + d_ripple*factor;
                        temp_spectrum = temp_spectrum + spektrSpectrum_fcn(energy_temp, alFilt);
                    end
                    % if a Al, filter thickness is entered, then filter the unfiltered spectrum, ripple considered
                    q = temp_spectrum*(1/steps);    
                else
                    for i=1:1:steps,
                        t=(pi/steps)*i;
                        factor = abs(sin(t)); % typical kilovoltage waveform
                        energy_temp = energy_ripple + d_ripple*factor;
                        if (energy_temp<20);
                            q_temp = zeros(150,1);
                        else
                            q_temp = dat.spTASMICS(:,fix(energy_temp-20)+1);
                        end
                        temp_spectrum = temp_spectrum + spektrBeers(q_temp, [13 alFilt]);
                    end
                    q = temp_spectrum*(1/steps);     

                    if normalize == 1
                        q = spektrBeers(q, [13 inherentTASMIPfilt]);
                        q = normalizationFactor(energy) * q;
                    end
                end
            end
        else
            % if a Al filter thickness is entered only, then filter the unfiltered spectrum, no ripple considered
            if useTASMICS == 0
                q = spektrSpectrum_fcn(energy, alFilt);
            else
                q = spektrBeers(MICSspect, [13, alFilt]);
                if normalize == 1
                    q = spektrBeers(q, [13 1.6]);
                    q = normalizationFactor(energy) * q;
                end
            end
        end
end
    
% return unfiltered x-ray spectra
s = q;

return

function q = spektrSpectrum_fcn(energy,varargin)

% input coefficient matrix from excel in a matrix called "tasmip"
load('spektrTASMIP.mat');

%row 1: contains the photon fluence
q = zeros(150,1);

% Put in the respective energy bins from 10-140kV
% Generate unfiltered x-ray spectra q
for i=11:1:energy,
    q(i-1,1) = tasmip(i,1) + tasmip(i,2).*energy + tasmip(i,3).*(energy^2) + tasmip(i,4).*(energy^3);
end

% " varargin " is a variable input argument for aluminum filter thickness
% within the x-ray tube of the apparatus

% Check if the aluminum thickness, of the filter within the x-ray tube is
% provided

if isempty(varargin)==1 % Default setting
    ; % if no additional input argument is entered " do nothing "
else
    y = varargin{:}; % store the variable input arguments in a matrix y which has dimensions [1xN]
                     % extract the filter thickness (that exists within the x-ray tube
    q = spektrBeers(q,[spektrElement2Z('Al'), y(1,1)]); % if a Al, filter thickness is entered, then filter the unfiltered spectrum
end

return