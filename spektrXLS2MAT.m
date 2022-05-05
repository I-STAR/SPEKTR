%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrXLS2MAT.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2006 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: spektrXLS2MAT
%%
%%  Inputs: none
%%
%%  Outputs: .Mat files
%%
%%  Description:
%%      Converts Excel spreadsheets containing element and compound data to
%%      Matlab .MAT files to improve performance
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%	2.000    2006 04 19     DJM Utility to convert .XLS to .MAT
%%*************************************************************************
%%

AMU = xlsread('spektrAtomicMassElements.xls');
save('spektrAtomicMassElements.mat','AMU')

densityCompounds = xlsread('spektrDensityCompounds.xls');
save('spektrDensityCompounds.mat','densityCompounds')

density = xlsread('spektrDensityElements.xls');
save('spektrDensityElements.mat','density')

fluence_per_exposure = xlsread('spektrFluencePerExposure.xls');
save('spektrFluencePerExposure.mat','fluence_per_exposure')

muRhoCompounds = cell(20,1);
for C=1:20
    muRhoCompounds{C} = xlsread('spektrMuRhoCompounds.xls',['C=',num2str(C)]);
end
save('spektrMuRhoCompounds.mat','muRhoCompounds')

A = cell(92,1);
for Z=1:92
    A{Z} = xlsread('spektrMuRhoElements.xls',['Z=',num2str(Z)]);
end
save('spektrMuRhoElements.mat','A')

tasmip = xlsread('spektrTASMIP.xls');
save('spektrTASMIP.mat','tasmip')

