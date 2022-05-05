function h = spektrHVLn(q,n,atomic_number)

%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektrHVLn.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage:  h = spektrHVLn(q, n, atomic_number)   
%%
%%      eg. h = spektrHVLn(q, 1, 13)
%%      calculates the first HVL of Aluminum
%%
%%  Input Parameters: 
%%      q - x-ray energy spectrum (1-150keV)
%%      n - number of the half value layer to calculate
%       atomic_number - element comprising the filter of interest. 
%%
%%  Output Parameters: 
%%      h - thickness of n'th HVL (Half Value Layer) [mm]
%%
%%  Description:
%%      This function calculates the n'th HVL (Half Value Layer),
%%      which is the thickness required to attenuate the beam
%%      intensity by 1/2^n. 
%%
%%      This function accounts for the polyenergetic case.
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

%%% ... accuracy of search algorithm
accuracy = 0.001;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initial thickness of element 
thickness = 0;  
min = 0;
max = 1000;

% calculate the thickness in which the exposure to due varying spectrum is
% reduced to 1/2^n  of it's initial exposure

exposure = spektrExposure(q);
   
n_factor = 2^-n;

while( exposure>[n_factor*spektrExposure(q)+accuracy] )|( exposure<[n_factor*spektrExposure(q)-accuracy] ),

    %incrementing the thickness of the filter
    
    increment = (max-min)/2;
    
    if exposure<(n_factor*spektrExposure(q))
        thickness = max-increment;
    elseif exposure>(n_factor*spektrExposure(q))    
        thickness = min+increment;
    else exposure==(n_factor*spektrExposure(q))
        ;
    end
    
    %   generate spectrum given a elemental filter of a specified thickness    
    q_temp = spektrBeers(q,[atomic_number thickness]);

    %   calculate the exposure of the spectrum
    exposure = spektrExposure(q_temp);
       
    %setting the max/min bounds
    if exposure<(n_factor*spektrExposure(q))
        if max>thickness
            max = thickness;
        else
        ;
        end
    else exposure>(n_factor*spektrExposure(q))
        if min<thickness
            min = thickness;
        else
        ;
        end
    end
        
end

% Return HVL
h = thickness;