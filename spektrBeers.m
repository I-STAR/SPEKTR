function f = spektrBeers(q,elem_filters);
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrBeers.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: f = spektrBeers(q, elem_filters)
%%
%%  Inputs:
%%      q - X-Ray Energy Spectrum (is a [150 x 1] matrix), generated 
%%          from the function spektr(..,..)
%%      elem_filters - [N x 2] matrix containing filters which are listed as (column 1) atomic number & (column
%%          2) filter thickness. 
%%
%%      ie. f = spektrBeers(q,[13 1; 92 4]);
%%      Filter: 1mm of Aluminum & 4mm of Uranium
%%
%%  Outputs:
%%      Filtered X-ray Energy Spectrum, which is a 150x1 matrix, each matrix
%%      element representing the # of photons per energy bin (using 1 keV bins, from
%%      1-150 keV)
%%
%%  Description:
%%      This function will filter the energy spectrum, q, given a number of
%%      filters & filter thicknesses 
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
%%	2.000    2006 04 19     DJM Removed XLSread and replaced with .MAT
%%*************************************************************************
%%
% Date: May 2003
% Revisions History: June 17, 2003 - addition of "  q=filtered;  " at the
%                                    end of the main for loop.
% By: Aaron Waese

% Where elem_filters will be a matrix [Nx2] which will indicate which filters will
% be used and their respective thicknesses. ie. [13 1;92 4]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS
% Energy Vector
EnergyVector = 1:150;

% Column Identifiers for XL database sheets
%%% ... in xls database of mu/rho for elements
%%%     AND for the xls database for mu/rho for compounds
XLColumn_LinearAttenuation = 9;
%%% ... in xls database for density of elements and compounds
XLColumn_Density = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the matrix of the filtered spectra
filtered = zeros(150,1); 

% Read in density of filter from density.xls
% This file consists of a 92x2 matrix with the following structure:(elements,densities)
% column 3 contains the censities in g/cm^3

load('spektrDensityElements.mat');

load('spektrMuRhoElements.mat'); % Let A be the temp matrix which has dim. 150x10

% Filter the unfiltered spectrum q, as many times as their are filters
for i=1:1:size(elem_filters,1),
    
% Read in attenuation coefficient data for the specified filter from
% murho_elements.mat
    
% In file 'murho_elements' there exists 92 sheets, each sheet contains elemental
% attenuation coefficients and attenuation coefficients (energy based).
% The structure of the data in the file is the following

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
% murho_elements.xls
    attenuation = A{elem_filters(i,1)}(EnergyVector,XLColumn_LinearAttenuation); % 150x1 matrix (contains mass attenuation coefficients)
    % take the 9th column of the spreadsheet A
        
% Convert interpolated data to attenuation via the following expression:
% attenuation = (attenuation/density)* density => [cm^2/g]*[g/cm^3]=[1/cm]
% The 0.1 accnts for converting the attenuation matrix to units of [1/mm]
        
    attenuation = density(elem_filters(i,1),XLColumn_Density)*attenuation*(0.1);
        
% Apply Beer's Law to the spectrum, given a filter type/thickness
        
    filtered = q.*exp(-attenuation*elem_filters(i,2));
    q = filtered;
end

% Return filtered spectrum [150x1] MATRIX
f = filtered;