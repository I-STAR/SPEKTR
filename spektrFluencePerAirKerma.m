function [ fluPerAirKerma ] = spektrFluencePerAirKerma( q )
%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrFluencePerAirKerma.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: e = spektrFluencePerAirKerma(q)
%%
%%  Inputs:
%%      q - X-Ray Energy Spectrum (is a [150 x 1] matrix), generated from the 
%%          function spektrSpectrum(..,..).  Each matrix element represents 
%%          the # of photons / mAs / mm^2 in an one keV energy bin (from 1-150 keV)
%%      
%%
%%  Outputs:
%%      fluPerAirKerma = Fluence / Air Kerma (x-rays / mGy / mm^2)
%%
%%  Description:
%%      This function will generate the fluence per air kerma [x-rays / mGy / mm^2].
%%
%%      Let:
%%          u[E] = attenuation coefficient
%%          p = density
%%
%%      where (u[E]/p)en is the energy dependent mass energy absorption
%%          coefficient of air -> UNITS are [cm^2/g]
%%      where q[E] or q is the energy spectrum (x-ray)
%%      where 114.5 is the conversion from in air exposure to air kerma
%%
%%      Therefore;
%%
%%      (photon fluence)/exposure [photons/mm^2 / mR] = (5.43x10^5)/((u[E]/p)en*E) * 114.5
%%      
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  3.000    2016 05 30     JGP Initial creation
%%*************************************************************************
%%
fluPerExpo = spektrFluencePerExposure(q);
fluPerAirKerma = fluPerExpo * 114.5; 

end

