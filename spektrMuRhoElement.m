function attenuation = spektrMuRhoElement(element)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrMuRhoElement.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: f = spektrMuRhoElement(q, elem_filters)
%%
%%  Inputs:
%%      element - Atomic Number of filter to look up
%%
%%      ie. mu = spektrMuRhoElement(13);
%%      Aluminum
%%
%%  Outputs:
%%
%%  Description:
%%      This function will generate the linear attenuation coefficient (mu/rho) of the
%%      compound comprised of the elements listed in 'elements' (Nx2 matrix)
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
% Energy Vector
EnergyVector = 1:150;

% Column Identifiers for XL database sheets
%%% ... in xls database of mu/rho for elements
%%%     AND for the xls database for mu/rho for compounds
XLColumn_LinearAttenuation = 9;
%%% ... in xls database for density of elements and compounds
XLColumn_Density = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read in density of filter from density.xls
% This file consists of a 92x2 matrix with the following structure:(elements,densities)
% column 3 contains the censities in g/cm^3

load('spektrDensityElements.mat');

% Read in attenuation coefficient data for the specified filter from
% murho_elements.xls
       
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
load('spektrMuRhoElements.mat');

attenuation = A{element}(EnergyVector,XLColumn_LinearAttenuation); % 150x1 matrix (contains mass attenuation coefficients)
    % take the 9th column of the spreadsheet A
        
% Convert interpolated data to attenuation via the following expression:
% attenuation = (attenuation/density)* density => [cm^2/g]*[g/cm^3]=[1/cm]
% The 1/10 accnts for converting the attenuation matrix to units of [1/mm]
        
attenuation = density(element,XLColumn_Density)*attenuation/10;
