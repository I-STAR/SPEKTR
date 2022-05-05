function rowNumber = spektrCompound2C(compound)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrCompound2C.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: rowNumber = spektrCompound2C(compound)
%%
%%  Inputs:
%%      compound - string containing one of the ACRP compounds
%%
%%  Outputs:
%%      rowNumber - integer index assigned to compound
%%
%%  Description:
%%      The function of this method is to return the row of a desired
%%      compound for the list of compound densities in density_compounds (XL
%%      file)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS

% Filename for matlab file containing the list of compounds
Filename_CompoundList='spektrCompoundList.m';
%%% ... in xls database for density of elements and compounds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Access periodic table spreadsheet from " periodic_table.m "
data = textread(Filename_CompoundList,'%s\r'); %abbrev. of the elements & atomic #'s are stored here
rowNumber = strmatch(compound,data,'exact');
