function mmAl = spektrEquiv_mmAl(q0,filter_list)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrEquiv_mmAl.m
%% Version number:   2
%% Revision number:  00
%% Revision date:    10-May-2006
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage:  mmAl = spektrEquiv_mmAl(q0,filter_list)
%%
%%  Input Parameters: 
%%      q0 - x-ray energy spectrum with no added filtration (1-150keV)  
%%      filter_list -  Nx2 matrix with the following form
%%                    [atomic_number thickness; .. .. ; .. ..];
%%
%%  Output Parameters: 
%%      mmAl - Aluminum Equivalent Thickness [mm]
%%
%%  Description:
%%      This function will generate the equivalent mmAl given a list of filters
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
% Parameters
accuracy=0.01;

% let q be the following spectrum
% v0 & v1: 
%q = spektrSpectrum(100);
% v2: 
q = q0; % use unfiltered spectrum at specified kVp

% filter the spectrum accordingly
for i=1:size(filter_list,1),
    qa = spektrBeers(q,[filter_list(i,1) filter_list(i,2)]);
    q = qa;
end

% exposure after the beam is hardened due to the filters
exposureFilters = spektrExposure(q);

% initial thickness of element 
thickness = 0;  
min = 0;
max = 250;

% calculate the thickness of Al, for which the exposure due to the filter
% Al equals to that of the exposure of another elemental filter

% v0 & v1: 
%qtemp = spektrSpectrum(100);
% v2:
qtemp = q0; % use unfiltered spectrum at specified kVp
exp = spektrExposure(qtemp);

while( exposureFilters+accuracy<exp )|( exposureFilters-accuracy>exp ),
       
    %incrementing the thickness of the filter
    
    increment = (max-min)/2;
    
    if exp<exposureFilters
        thickness = max-increment;
    elseif exp>exposureFilters    
        thickness = min+increment;
    else exp==exposureFilters
        break;
    end
          
    %   generate spectrum given a elemental filter of a specified thickness    
    qtemp2 = spektrBeers(qtemp,[13 thickness]);

    %   calculate the exposure of the spectrum
    exp = spektrExposure(qtemp2);
    
    if exp<exposureFilters
        if max>thickness
            max=thickness;
        end
    end
    
    if exp>exposureFilters
        if min<thickness
            min = thickness;
        end
    end
            
end

% Return HVL
mmAl = thickness;