function e = spektrExposure(q)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrExposure.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2006 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: e = spektrExposure(q)
%%
%%  Inputs:
%%      q - X-Ray Energy Spectrum (is a [150 x 1] matrix), generated from the 
%%          function spektrSpectrum(..,..).  Each matrix element represents 
%%          the # of photons per energy bin (using 1 keV bins, from 1-150 keV)
%%
%%  Outputs:
%%      e = Exposure [mR/mAs]
%%
%%  Description:
%%      This function will generate the exposure [mR/mAs].
%%
%%      Let:
%%          u[E] = attenuation coefficient
%%          p = density
%%
%%      where (u[E]/p)en is the energy dependent mass energy absorption
%%          coefficient of air -> UNITS are [cm^2/g]
%%      where q[E] or q is the energy spectrum (x-ray)
%%
%%      Therefore;
%%
%%      (photon fluence)/exposure = (5.43x10^5)/((u[E]/p)en*E) [photons/mm^2mR]
%%
%%      Total Exposure = Sum(from 0 -> Emax) (u[E]/p)en*E)*q[E]/(5.43*10^5) [mR/mAs]
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

load('spektrFluencePerExposure.mat'); % 150x10 matrix
exposure_per_fluence = fluence_per_exposure(:,4); % 150x1 matrix - column 4

% Therefore;
% (photon fluence)/exposure = (5.43x10^5)/((u[E]/p)en*E) [photons/mm^2mR]

% Total Exposure = Sum(from 0 -> Emax) (u[E]/p)en*E)*q[E]/(5.43*10^5) [mR/mAs]

% (1) Calculate the exposure in air
exposure_air = exposure_per_fluence.*q;

% (2) Integrate/Sum: Perform a summation of the entire matrix -> which will give the exposure
e = sum(exposure_air);