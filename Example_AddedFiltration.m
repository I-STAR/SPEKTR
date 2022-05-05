%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      Example_AddedFiltration.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    20-Sep-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: script
%%
%%  Inputs:
%%      none
%%
%%  Outputs:
%%      none
%%
%%  Description:
%%      The script shows a simple application of SPEKTR to model added
%%      filtration
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%*************************************************************************
%% Revision History
%%	1.000    2004 09 20     DJM Initial released version
%%*************************************************************************
%%

inherent_filtration = 2.5;      % [mm Al]
added_filtration = [ 
            [ spektrElement2Z('Cu'), 0.1] 
            [ spektrElement2Z('Al'), 2.0] 
        ];
kVp = 120;                      % [kVp]

Phi_tube = spektrSpectrum(kVp, inherent_filtration);
kV = [1:150]';

% Place additional filtration in beam (0.1mm Cu and 2mm Al)
Phi_added = spektrBeers(Phi_tube,added_filtration);

figure(1)
plot(kV,Phi_tube,'k-',kV,Phi_added,'r:')
xlabel('keV')
ylabel('Photon Output')
grid on
title('Spektr Predicted Spectrum with and without added filtration')
legend([num2str(kVp,'%.0f'),'kVp with ',num2str(inherent_filtration,'%.1f'),'mm Inherent filtration'],'Added Filtration: 2mm Al, 0.1mmCu')
