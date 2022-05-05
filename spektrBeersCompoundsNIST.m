function x = spektrBeersCompoundsNIST(q,comp_thickness);
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrBeersCompoundsNIST.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: x = spektrBeersCompoundsNist(q,compound_thickness)
%%
%% Input Parameters: 'q' is an X-Ray Energy Spectrum (is a [150 x 1] matrix), generated 
%%                   from the function spektr(..,..). 'comp_thickness' is a [N x 2] matrix 
%%                   comprising a list of compound name indices (number), refering to a 
%%                   compound database called murho_compounds.xls, and thickness (number) [mm]
%%
%%                   ie. b = spektrBeersCompoundsNIST(q,[spektrCompound2C('Fat') 1;spektrCompound2C('Bone') 5]);
%%                   Filter: 1mm of Fat & 5mm of Bone
%%
%%
%% Output Parameters: x - Filtered X-ray Energy Spectrum, which is a 150x1 matrix, each matrix
%%                    element representing the # of photons per energy bin (using 1 keV bins, from
%%                    1-150 keV)
%%
%%
%%  Description:
%%      This function will filter the energy spectrum, q, given a number of
%%      compound filters & filter thicknesses 
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  0.000    2003 05 01     AW  Initial code
%%	1.000    2004 03 15     DJM Initial released version
%%*************************************************************************
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS
% Column Identifiers for XL database sheets
%%% ... in xls database of mu/rho for elements
%%%     AND for the xls database for mu/rho for compounds
XLColumn_LinearAttenuation = 9;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the matrix of the filtered spectra
filtered= zeros(150,1); 

% Filter the unfiltered spectrum q, as many times as their are filters

loop_limit = size(comp_thickness,1);

% Read in density of filter from density_compounds.xls
% This file consists of a 20x1 matrix with a list of compound densities. [g/cm^3]

load('spektrDensityCompounds.mat');

load('spektrMuRhoCompounds.mat'); % Let A be the temp matrix which has dim. 150x10

for i = 1:1:loop_limit
       
% In file 'murho_compounds' there exists 20 sheets, each sheet contains
% linear attenuation coefficients and attenuation coefficients (energy based) 
% for the respective compounds. The structure of the data in the file is the following

% NIST DATA;
% A)column 1(energy) [MeV]
% B)column 2(attentuation/density)
% C)column 3(attentuation/density)en
% D)column 4(energy) [keV]
% E)column 5(attentuation/density)
% F)column 6(attentuation/density)en

% INTERPOLATED DATA;
% G)column 7 empty
% H)column 8(energy) [keV], 1 keV intervals, from 1-150 keV
% I)column 9(attentuation/density)
% J)column 10(attentuation/density)en

% Read in attenuation coefficient data for the specified filter from
% murho_compounds.xls
       
    attenuation = muRhoCompound{comp_thickness(i,1)}(:,XLColumn_LinearAttenuation); 
    % 150x1 matrix (contains mass attenuation coefficients)
    % take the 9th column of the spreadsheet A
        
% Convert interpolated data to attenuation via the following expression:
% attenuation = (attenuation/density)* density => [cm^2/g]*[g/cm^3]=[1/cm]
% The 0.1 accnts for converting the attenuation matrix to units of [1/mm]

    attenuation = densityCompounds(comp_thickness(i,1))*attenuation*(0.1);
        
% Apply Beer's Law to the spectrum, given a filter type/thickness
        
    filtered = q.*exp(-attenuation*comp_thickness(i,2));
    q = filtered;
end

% Return filtered spectrum [150x1]
x = filtered;