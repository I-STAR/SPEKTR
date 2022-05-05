function Z = spektrElement2Z(element)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrElement2Z.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: e = spektrElement2Z(element)
%%
%%  Inputs:
%%      element - Abbreviation for the element of interest  (string)
%%
%%  Outputs:
%%      Z - Atomic Number of an element of interest
%%
%%  Description:
%%      Returns the atomic number of an element given
%%      the abbreviated form of the element.  Abbreviations are case
%%      sensitive.  If the element abbreviation is not found Z=0 is
%%      returned.
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

% Filename for matlab file containing periodic table of element
% abbreviations
Filename_PeriodicTable='spektrPeriodicTable.m';

%  Extract the periodic_table.m file which contains the atomic number and
%  abbreviations for all the elements
data = textread(Filename_PeriodicTable,'%s\r'); %abbrev. of the elements & atomic #'s are stored here

Z = strmatch(element,data,'exact');