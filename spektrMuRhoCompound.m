function [mu, rho] = spektrMuRhoCompound(compound)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrMuRhoCompound.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    5-May-2016
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage:  
%%          To find the linear attenuation of Gadolinium OxySulfide (Gd2O2S)
%%          mu = spektrMuRhoCompound([64 2;8 2; 16 1]);
%%                          OR
%%          You can also use Gadolinium Oxysulfide's index within
%%          spektrCompoundList.m. 
%%          [mu, rho] = spektrMuRhoCompound(10);
%%
%%
%% Input Parameters: 'compound' is a Nx2 matrix containing a list of atomic numbers
%%                    in the first column and its number of constituents in the second column. 
%%                                     OR
%%                    'compound' can be a scalar value containing the index of 
%%                    one of the compounds listed in spektrCompoundList.m.
%%
%% Output Parameters: If 'compound' is an [Nx2] matrix, then the mass attenuation
%%                    coefficients [150x1 matrix] for energies from 1-150 keV in 
%%                    intervals of 1 keV is returned.
%%                    If 'compound' is a scalar value, then the linear attenuation (1/mm) [150x1 matrix]
%%                    coefficients for 1 - 150 keV in intervals of 1 keV and the density (g/cm^3)
%%                    (scalar) is returned. 
%%
%%  Description:
%%  This function will generate the linear attenuation coefficient (1/mm) and the density
%%  of the compound comprised of the elements listed in 'elements' [Nx2 matrix]
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
%%  3.000    2016 05 30     JGP Accepts compound number and returns mu and rho.
%%*************************************************************************
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PARAMETERS
% Energy Vector
EnergyVector=1:150;
% Filename for .mat file containing mu/rho elements
% Filename for .mat file containing mu/rho elements
% Column Identifiers for .mat file database sheets
%%% ... in .mat file database of mu/rho for elements
%%%     AND for the .mat file database for mu/rho for compounds
matColumn_LinearAttenuation = 9;
matColumn_AMU = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the matrix, which will be the linear attenuation coefficients
% of the new compound
mu_new = zeros(150,1); 

% number of rows in the Nx2 matrix (input argument)
num_elements = size(compound,1);

% expression to calculate is the following:
%
% mu_comp = [Ma(murho_a)+Mb(murho_b)+...]/[Ma+Mb+...];     equation (1)

% Initialize Denominator of above expression
Total_Atomic_Mass=0;

if isscalar(compound)
    load('spektrMuRhoCompounds.mat'); %Load in the mu/rho of the compounds
    load('spektrDensityCompounds.mat'); %Load in the compound density
    muRho = muRhoCompound{compound}(:,matColumn_LinearAttenuation);
    density = densityCompounds(compound); %To convert g/cm^3 to g / mm^3.
    %The 0.1 is multiplied to convert the centimeters into millimeters
    mu = muRho * density * 0.1; % [cm^2/g] * [g/cm^3] * 0.1 The 0.1 converts 1/cm to 1/mm
    rho = density;
else
    load('spektrMuRhoElements');
    load('spektrAtomicMassElements');    

    for i=1:1:num_elements,

        % Read in attenuation coefficient data for the specified filter from
        % murho_elements.mat

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

        mu = A{compound(i,1)}(EnergyVector,matColumn_LinearAttenuation);

        % Read in attenuation coefficient data for the specified filter from
        % atomic_mass_elements.mat

        atomic_mass_element = AMU(compound(i,1),matColumn_AMU);

        % Calculate the atomic mass contribution of the specified element
        % denominator of equation (1)
        Total_Atomic_Mass = Total_Atomic_Mass + atomic_mass_element*compound(i,2);

        % Calculation numerator of equation (1)
        mu_new = mu_new + mu*atomic_mass_element*compound(i,2);
    end
    %Below is mu/Rho (cm^2/g). 1 cm^2 = 100 mm^2 So multiply by 1000 to
    %output mm^2. 
    mu = mu_new*(1/Total_Atomic_Mass) * 1000;
end
