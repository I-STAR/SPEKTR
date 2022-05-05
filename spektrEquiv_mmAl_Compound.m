function mmAl = spektrEquiv_mmAl_Compound(q0,mu,t)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrEquiv_mmAl_Compound.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    10-May-2006
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage:  mmAl = spektrEquiv_mmAl_Compound(filter_list)
%%
%%  Input Parameters: 
%%      q0 - x-ray energy spectrum with no added filtration (1-150keV)  
%%      mu - effective attenuation coefficient of compound [cm^-1]
%%      t - thickness of compound [mm]
%%
%%  Output Parameters: 
%%      mmAl - Aluminum Equivalent Thickness [mm]
%%
%%  Description:
%%      This function will generate the equivalent mmAl given a compound
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
%%  2.000    2006 04 10     MJD "speedy" spektr (pass in spectrum)
%%*************************************************************************
%%

% let q be the following spectrum
% v0 & v1: 
%qtemp = spektrSpectrum(100);
% v2:
qtemp = q0; % use unfiltered spectrum at specified kVp

% Filter the spectrum with the compound
q_filtered = q.*exp(-mu/10*t);

% exposure after the beam is hardened due to the filters
exposureFilters = spektrExposure(q_filtered);

% initial thickness of element 
thickness = 0;  
min = 0;
max = 250;

% calculate the thickness of Al, for which the exposure due to the filter
% Al equals to that of the exposure of another elemental filter

exposure = spektrExposure(q);

while( exposureFilters+accuracy<exposure )|( exposureFilters-accuracy>exposure ),
       
       
    %incrementing the thickness of the filter
    
    increment=(max-min)/2;
    
    if exposure<exposureFilters
        thickness = max-increment;
    elseif exposure>exposureFilters    
        thickness = min+increment;
    else exposure==exposureFilters
        break;
    end
          
    %   generate spectrum given a elemental filter of a specified thickness    
    qtemp2 = spektrBeers(qtemp,[13 thickness]);

    %   calculate the exposure of the spectrum
    exposure = spektrExposure(qtemp2);
    
    if exposure<exposureFilters
        if max>thickness
            max=thickness;
        end
    end
    
    if exposure>exposureFilters
        if min<thickness
            min=thickness;
        end
    end
            
end

% Return HVL
mmAl = thickness;