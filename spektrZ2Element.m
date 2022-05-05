function element = spektrZ2Element(Z)
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
%%  Usage: element = spektrZ2Element(Z)
%%
%%  Inputs:
%%      Z - Atomic Number of an element of interest
%%
%%  Outputs:
%%      element - Abbreviation for the element of interest  (string)
%%
%%  Description:
%%      The function of this method is to return the atomic number of an element given
%%      the abbreviated form of the element.
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

% z = atomic number

% Access periodic table spreadsheet from " periodic_table.m "
data = textread(Filename_PeriodicTable,'%s\r'); %abbrev. of the elements & atomic #'s are stored here

% Extract element abbreviation, given atomic number(z)
if Z>=1 & Z<=length(data)
    element = data(Z,1);
else
    element = '';
end

