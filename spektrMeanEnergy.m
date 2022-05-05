function meanEnergy = spektrMeanEnergy(q)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrMeanEnergy.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: meanEnergy = spektrMeanEnergy(q)
%%
%% Input Parameters: 'q' is an X-Ray Energy Spectrum (is a [150 x 1] matrix), generated 
%%                   from the function spektrSpectrum(..,..). 
%%
%%                   ie. h = spektrMeanEnergy(spektrSpectrum(100));
%%
%% Output Parameters: Mean Energy [keV]
%%
%%  Description:
%%      The function returns the mean energy of the x-ray spectra
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

q = q(:);

meanEnergy = ([1:150]*q)/sum(q);

