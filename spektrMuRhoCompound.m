function c = spektrMuRhoCompound(elements)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrMuRhoCompound.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    19-Apr-2006
%%
%% 2006 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage:  c = spektrMuRhoCompound([6 1;1 1]);
%%
%%
% Input Parameters: 'elements' is a Nx2 matrix. Column 1 lists the
%                    elements, where Column 2 lists the respective number of 
%                    each element in the compound.
%
% 1 Adipose Tissue (ICRU-44)	Fat	
% 2 Air, Dry (Near Sea Level)	Air	
% 3 Blood, Whole (ICRU-44)	Blood	
% 4 Bone, Cortical (ICRU-44)	Bone	
% 5 Brain, White/Gray Matter (ICRU-44)	Brain	
% 6 Breast Tissue (ICRU-44)	Breast	
% 7 Cadmium Telluride	CdTe	
% 8 Cesium Iodide	CsI	
% 9 Eye Lens	EyeLens	
% 10 Gadolinium Oxysulfide	Gd2O2S	
% 11 Gallium Arsenide	GaAs	
% 12 Lung Tissue (ICRU-44)	Lung	
% 13 Mercuric Iodide	HgI2	
% 14 Muscle, Skeletal (ICRU-44)	Muscle	
% 15 Polyethylene	Polyethylene	
% 16 Polymethyl Methacrylate	PMMA	
% 17 Polystyrene	Polystyrene	
% 18 Polytetrafluoroethylene, "Teflon"	Teflon	
% 19 Soft Tissue (ICRU-44)	SoftTissue	
% 20 Water	Water	
%%
% Output Parameters: Linear Attenuation coefficients [150x1 matrix] for
%                    energy from 1-150 keV in intervals of 1 keV.
%%
%%  Description:
% This function will generate the linear attenuation coefficient (mu/rho) of the
% compound comprised of the elements listed in 'elements' (Nx2 matrix)
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
% Energy Vector
EnergyVector=1:150;
% Filename for xls file containing mu/rho elements
% Filename for xls file containing mu/rho elements
% Column Identifiers for XL database sheets
%%% ... in xls database of mu/rho for elements
%%%     AND for the xls database for mu/rho for compounds
XLColumn_LinearAttenuation = 9;
XLColumn_AMU = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the matrix, which will be the linear attenuation coefficients
% of the new compound
mu_new = zeros(150,1); 

% number of rows in the Nx2 matrix (input argument)
num_elements = size(elements,1);

% expression to calculate is the following:
%
% mu_comp = [Ma(murho_a)+Mb(murho_b)+...]/[Ma+Mb+...];     equation (1)

% Initialize Denominator of above expression
Total_Atomic_Mass=0;

load('spektrMuRhoElements');
load('spektrAtomicMassElements');

for i=1:1:num_elements,
    
    % Read in attenuation coefficient data for the specified filter from
    % murho_elements.xls
       
    % In file 'murho_elements' there exists 92 sheets, each sheet contains elemental
    % attenuation coefficients and attenuation coefficients (energy based).
    % The structure of the data in the file is the following

    % NIST DATA;
    % A)column 1(energy) [MeV]
    % B)column 2(attentuation/density)
    % C)column 3(attentuation/density)en
    % D)column 4(energy) [keV]
    % E)column 5(attentuation/density)
    % F)column 6(attentuation/density)en

    % INTERPOLATED DATA;
    % G)column 7 empty
    % H)column 8(energy) [keV], 1 keV intervals, from 1-150 keV
    % I)column 9(attentuation/density)
    % J)column 10(attentuation/density)en

    mu = A{elements(i,1)}(EnergyVector,XLColumn_LinearAttenuation);
            
    % Read in attenuation coefficient data for the specified filter from
    % atomic_mass_elements.xls
   
    atomic_mass_element = AMU(elements(i,1),XLColumn_AMU);
    
    % Calculate the atomic mass contribution of the specified element
    % denominator of equation (1)
    Total_Atomic_Mass = Total_Atomic_Mass + atomic_mass_element*elements(i,2);
    
    % Calculation numerator of equation (1)
    mu_new = mu_new + mu*atomic_mass_element*elements(i,2);
end

% Solve equation (1) above and return
c = mu_new*(1/Total_Atomic_Mass);
