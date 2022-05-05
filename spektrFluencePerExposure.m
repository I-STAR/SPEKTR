function FE = spektrFluencePerExposure(q)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrFluencePerExposure.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    10-Apr-2006
%%
%% 2006 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: e = spektrFluencePerExposure(spektr(90)); 
%%
%% (photon fluence)/exposure = (5.43x10^5)/((u[E]/p)en*E)*normalized(q) [photons/mm^2mR]
%%
%%
%% Input Parameters: 'q' is an energy spectrum comprising a 150x1 matrix. This 
%%                   spectrum can be generated from the matlab function
%%                   spektr(kVp, [Al_thickness kV_ripple]). Each matrix
%%                    element represents the # of photons per energy bin (using 1 
%%                    keV bins, from 1-150 keV)
%%
%% Output Parameters: Fluence per Exposure [photons/mm^2mR]
%%
%%  Description:
%%      This function will generate the Fluence per Exposure [x-rays/mm^2/mR]
%%      given a spectrum q.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS

Column_FluencePerExposure = 3;

% Read in the appropriate spreadsheet for the fuence per unit of exposure (of air compound)

load('spektrFluencePerExposure.mat'); % 150x10 matrix
exposure_per_fluence = fluence_per_exposure(:,Column_FluencePerExposure); % 150x1 matrix

% Normalize q

qnorm = spektrNormalize(q);

% Integral
FE = sum( exposure_per_fluence.*qnorm );
