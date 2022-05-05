function [ uniqueFilt ] = spektrInherentFiltrationDisplay( InhArr )
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      Inhdisplay.m
%% Version number:   3
%% Revision number:  00
%% Revision date:    15-Jun-2015
%%
%% 2016 (C) Copyright by Jeffrey H. Siewerdsen.
%%          I-STAR Lab
%%          Johns Hopkins University
%%
%%  Usage: uniqueFilt = spektrInherentFiltrationDisplay( name_of_spektr_tube_used)
%%
%%  Inputs:
%%      tubeName - The name of the tube that is being used to generate the
%%                 spectrum within the GUI. This variable is a string.
%%
%%  Outputs:
%%      A unique list of the filtration elements contained within the tube 
%%      along with their thicknesses.
%%
%%  Description:
%%      This helper function will pass on the inherent filtration of the selected
%%      tube to the GUI to be displayed in listbox 8 and 9.
%%
%%  Notes:
%%
%%*************************************************************************
%% References: 
%%
%%*************************************************************************
%% Revision History
%%  3.000    2015 06 15     JP  Initial code
%%*************************************************************************


%INHDISPLAY obtains the tube settings and displays the element in listbox
%8 if the element is unique in the list and thickness in listbox 9 if the 
%thickness of the element is not 0 mm.
    
%     tubeFilters = tubeSettings(tubeName);
%     %Add the inherent filtration that is present in both the TASMICS
%     %and TASMIP spectra
     InhArr(size(InhArr, 1) + 1, :) = [13 1.6];

    %Sort the filters according to the atomic number to order the inherent
    %filtrations in descending order
    [~, index] = sort(InhArr(:,1));
    sortedFilters = InhArr(index, :);
    uniqueFilt = cell(size(sortedFilters));
    numUnique = 1;
    %Remove repeat filtration elements
    for i = 1:size(sortedFilters, 1) - 1
        %Found a duplicate
        if sortedFilters(i,1) == sortedFilters(i+1, 1)
            sortedFilters(i + 1, 2) = sortedFilters(i,2) + sortedFilters(i + 1, 2);
        else
            if sortedFilters(i,2) ~= 0
                uniqueFilt(numUnique, 1) = spektrZ2Element(sortedFilters(i,1));
                uniqueFilt{numUnique, 2} = num2str(sortedFilters(i,2));
                numUnique = numUnique + 1;
            end
        end
    end
    %Reduce the size of the array to fit only the number of elements in the
    %array.
    uniqueFilt(numUnique:size(uniqueFilt,1), :) = [];
    %If there is no inherent filtration in the tube, make sure that you
    %still add on the 1.6mm Al that is always present in a normalized
    %spectrum 
    if isempty(uniqueFilt)
        uniqueFilt(numUnique, 1) = spektrZ2Element(sortedFilters(size(sortedFilters, 1),1));
        uniqueFilt{numUnique, 2} = num2str(sortedFilters(size(sortedFilters, 1), 2));
    %Remove any elements that have 0 in either the atomic number column or
    %the thickness column
    elseif sortedFilters(size(sortedFilters, 1),2) ~= 0 && strcmp(uniqueFilt{size(uniqueFilt, 1), 1}, spektrZ2Element(sortedFilters(size(sortedFilters, 1),1))) ~= 1
         uniqueFilt(numUnique, 1) = spektrZ2Element(sortedFilters(size(sortedFilters, 1),1));
         uniqueFilt{numUnique, 2} = num2str(sortedFilters(size(sortedFilters, 1), 2));
    end
    
end