function s = spektrSpectrum(energy, varargin)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrSpectrum.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2006 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: f = spektrSpectrum(energy, elem_filters)
%%
%%  Inputs:
%%      Energy [kVp] btw. 1-150 kVp (required), Aluminum filter thickness 
%%                   within x-ray tube [mm] (optional), kV ripple [%] (optional)
%%
%% ie. q = spektrSpectrum(120); 
%% ie. q = spektrSpectrum(120,1); with aluminum filter thickness
%% ie. q = spektrSpectrum(120,[1 1]); with 1mm aluminum filter thickness & a 1% kV ripple
%%
%%  Outputs:
%%      X-ray Energy Spectrum, which is a 150x1 matrix, each matrix
%%          element representing the # of photons per energy bin (using 1 keV 
%%          bins, from 1-150 keV)
%
%%
%%  Description:
%% This function will generate an unfiltered x-ray spectra at the specified 
%% potential (of the generator), given an x-ray system is set to a constant 1 mAs.
%%
%% The input argument "energy" will have to be an integer, between 1-150 [keV].
%% Using the tungsten anode spectra model interpolating polynomials (tasmip) algorithm, 
%% coefficients a0, a1, a2, a3 were generated for 131 energy bins, from 1 to
%% 150 [keV]. This algorithm will be implemented when the MATLAB function
%% spectrum(energy, [Al_thickness kV_ripple]) is called.
%%
% This function will generate an unfiltered x-ray spectra at the specified 
% potential (of the generator), given an x-ray system is set to a constant 1 mAs.
%
% The input argument "energy" will have to be an integer, between 10-140 [keV].
% Using the tungsten anode spectra model interpolating polynomials (tasmip) algorithm, 
% coefficients a0, a1, a2, a3 were generated for 131 energy bins, from 10 to 140 [keV].
%
% These coefficients are stored in the following files tasmip.txt, tasmip.xls as a 
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
%%*************************************************************************
%%

% Check if the aluminum thickness, of the filter within the x-ray tube is
% provided and/or the ripple is provided.

    if isempty(varargin)==1 % Default setting
        q = spektrSpectrum_fcn(energy); % if no additional input argument is entered " do nothing ", return to calling function
    else
        y = varargin{:}; % store the variable input arguments in a matrix y which has dimensions [1xN]
        temp = y(1,1); % extract the filter thickness (that exists within the x-ray tube
        			        
        % check if the ripple is provided 
        % this conditional accnts for the case of a ripple and no finite
        % filter thickness
        
        if length(y)==2
            
            if y(1,2)==0
            % if a Al, filter thickness is entered with a 0% ripple, then filter the unfiltered spectrum, no ripple considered
                 q = spektrSpectrum_fcn(energy, temp); 
            else               
            % ripple can now be calculated
                d_ripple = 0.01*energy*y(1,2); % ripple size
                energy_ripple = energy - d_ripple; % minimum energy due to ripple
                temp_spectrum(150,1) = 0; % initialize a temporary x-ray spectra matrix [150x1]
                steps = 20; % constant -> constraint on for loop
           
                for i=1:1:steps,
                    t=(pi/steps)*i;
                    factor = abs(sin(t)); % typical kilovoltage waveform
                    energy_temp = energy_ripple + d_ripple*factor;
                   temp_spectrum = temp_spectrum + spektrSpectrum_fcn(energy_temp,temp);
                end
                        
                % if a Al, filter thickness is entered, then filter the unfiltered spectrum, ripple considered
                q = temp_spectrum*(1/steps); 
            end
            
        else
        % if a Al filter thickness is entered only, then filter the unfiltered spectrum, no ripple considered
            q = spektrSpectrum_fcn(energy, temp); 
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