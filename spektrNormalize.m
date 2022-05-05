function qrel = spektrNormalize(q)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrNormalize.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: qrel = spektrNormalize(q)
%%
%%      qrel[E} = (q[E])/[Summation of q[E]]
%%
%%    where qrel[E] is the normalized spectra
%%       q[E] is the un-normalized spectra which is a 150x1 matrix, each matrix
%%       element representing the # of photons per energy bin (using 1 keV bins, from
%%       1-150 keV).
%%
%%  Inputs:
%%      q - un-normalized energy spectrum
%%
%%  Outputs:
%%      qrel - normalized energy spectrum
%%
%%  Description:
%%      This function will normalize the x-ray energy spectra.
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

% Normalize the x-ray energy spectra
qrel = q./sum(q);