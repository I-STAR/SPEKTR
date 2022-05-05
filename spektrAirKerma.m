function [ AirKerma ] = spektrAirKerma( q )
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrExposure.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    May 28, 2016
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: e = spektrExposure(q)
%%
%%  Inputs:
%%      q - X-Ray Energy Spectrum (is a [150 x 1] matrix), generated from the 
%%          function spektrSpectrum(..,..).  Each matrix element represents 
%%          the # of photons / mAs / mm^2 in an one keV energy bin (from 1-150 keV)
%%      
%%  Outputs:
%%      Air Kerma = Air Kerma [mGy/mAs]
%%
%%  Description:
%%      This function will generate the Air Kerma for the inputted spectrum [mGy/mAs].
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  3.000    2016 05 28     JGP Initial Code
%%*************************************************************************
%%
% The 114.5 is to convert in air exposure (mR) into air kerma (mGy).
% 114.5 mR = 1 mGy

AirKerma = spektrExposure(q) / 114.5;

end

