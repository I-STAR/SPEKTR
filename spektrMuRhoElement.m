function [mu, rho] = spektrMuRhoElement(element)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrMuRhoElement.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    31-May-2016
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: mu = spektrMuRhoElement(element)
%%                      OR
%%         [mu rho] = spektrMuRhoElement(element)
%%
%%  Inputs:
%%      element - Atomic Number of filter to look up
%%      
%%      ie. mu = spektrMuRhoElement(13)
%%          -Returns a [150x1] of the linear attenuation coefficient for energies 1 - 150 keV for Aluminum in units of 1/mm.
%%
%%      ie. [mu rho] = spektrMuRhoElement(13)
%%          -Finds the linear attenuation coefficient ([150x1]) of Aluminum in 1/mm measured at energies
%%           corresponding to the average energy of each energy bin in a TASMICS spectrum.
%%
%%  Outputs:
%%
%%      mu - The linear attenuation coefficient ([150 x 1]) in 1/mm for the element corresponding to the 
%%               atomic number inputted for energy 1-150 keV in 1 keV bins. This attenuation coefficient data is 
%%               calculated at every half keV (1.5, 2.5, 3.5, 4.5 etc.). This improves the accuracy of filtration calculations
%%               as mu is now calculated at the average energy of each energy bin in a TASMICS spectra.
%%               
%%      rho - The density (g/cm^3) of the element corresponding to the atomic number inputted (scalar) 
%%
%%  Description:
%%      This function will generate the linear attenuation coefficient and density
%%      for the element listed in 'element' (scalar). 
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
%%  3.000    2016 05 28     JGP Output linear attenuation (mu) and density (rho)
%%*************************************************************************
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS
% Energy Vector
EnergyVector = 1:150;

%%% Xcel Column containing attenuation coefficients at every half keV to
%%% match the average energy within each energy bin.
XLColumn_LinearAttenuation = 9;
%%% ... in .mat file database for density of elements and compounds
XLColumn_Density = 2;
%%% Xcel Column containing attenuation coefficients at every half keV to
%%% match the average energy within each energy bin.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read in density of filter from density.mat
% This file consists of a 92x2 matrix with the following structure:(elements,densities)
% column 3 contains the censities in g/cm^3

load('spektrDensityElements.mat');

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
% H)column 8(attenuation/density) calculated at every half keV. Data taken NIST XCom database
% I)column 9(attentuation/density) bicubicly interpolated attenuation to 1 keV bins based on old NIST database
% J)column 10(attentuation/density)en

% Read in attenuation coefficient data for the specified filter from
% murho_elements.mat
load('spektrMuRhoElements.mat');

% Convert interpolated data to attenuation via the following expression:
% attenuation = (attenuation/density)* density * 0.1 => [cm^2/g]*[g/cm^3] * [cm / mm =[1/mm]
% The 1/10 accnts for converting the attenuation matrix to units of [1/mm]
        
%mu = attenuation * density(element,XLColumn_Density) * 0.1;
mu = A{element}(EnergyVector,XLColumn_LinearAttenuation) * density(element, XLColumn_Density) * 0.1;
rho = density(element,XLColumn_Density);
