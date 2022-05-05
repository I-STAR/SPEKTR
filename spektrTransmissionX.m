function [q_vs_X_matrix, Ntot, Etot]= spektrTransmissionX(q,atomic_number,filter_thickness)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrTransmissionX.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage:
%%        [Q N E] = spektrTransmissionX(spektrSpectrum(120,[2.5 0.1]),element,filter_geometry);
%%
%% Input Parameters: 'q' is an X-Ray Energy Spectrum (is a [150 x 1] matrix), generated 
%%                   from the function spektr(..,..). 'atomic_number' will
%%                   identify the element comprising the filter of interest.
%%                   'filter_thickness' will be a filter whose thickness varies as a
%%                   function of x (from 1-1024)
%%
%%
%% Output Parameters: Q:spectrum v.s. space [150xfilter_domain]
%%                    N:number of photons v.s.[150x1]
%%                    E:total energy [150x1]
%%
%%  Description:
%%       This function will filter the energy spectrum, q, given a 
%%       filters whose thickness varies as a function of x.
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

% Energy Vector
EnergyVector=1:150;
NumSpatialPoints = length(filter_thickness);    % number of points computed in x-domain (also number of beers calls)

ematrix = meshgrid(1:length(EnergyVector),1:NumSpatialPoints)';
q_vs_X_matrix = [];

%filter the spectrum for each slice of the filter
%hw = waitbar(0,'Applying Spatial Filter - Please Wait');
mu = spektrMuRhoElement(atomic_number);

for i=1:NumSpatialPoints,
%    B = spektrBeers(q,[atomic_number filter_thickness(i)]);
    B = q.*exp(-mu*filter_thickness(i));

    q_vs_X_matrix = [q_vs_X_matrix,B];
%    waitbar(i/NumSpatialPoints,hw);

end

Ntot = sum(q_vs_X_matrix,1);
Etot = sum(q_vs_X_matrix.*ematrix,1);

%close(hw)
