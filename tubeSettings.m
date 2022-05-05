function [ elem_filters ] = tubeSettings( tube_select )
%% Library of tube settings for Spektr
%%
%% Purpose:
%% Allow users to specify inherent filtrations for different tubes that could 
%% be used from the Spektr GUI

% Find the tube selected, filter the beam accordingly

if strcmp(tube_select,'Boone/Fewell')== 1
    BooneFewell = [13 0; 74 0];
    filters = BooneFewell;

elseif strcmp(tube_select,'Tube_01')==1
    Tube01 = [13 2; 74 .005];
    filters = Tube01;

elseif strcmp(tube_select,'Tube_02')==1
    Tube02 = [13 .54; 74 .01];
    filters = Tube02;
    
elseif strcmp(tube_select,'Tube_03')==1
    Tube03 = [13 0; 74 0];
    filters = Tube03;
    
elseif strcmp(tube_select,'Tube_04')==1
    Tube04 = [13 0; 74 0];
    filters = Tube04;
    
elseif strcmp(tube_select,'Tube_05')==1
    Tube05 = [13 0; 74 0];
    filters= Tube05;
    
elseif strcmp(tube_select,'Tube_06')==1
    Tube06 = [13 0;74 0];
    filters = Tube06;
    
elseif strcmp(tube_select,'Tube_07')==1
    Tube07 = [13 0;74 0];
    filters = Tube07;
    
elseif strcmp(tube_select,'Tube_08')==1
    Tube08 = [13 0;74 0];   
    filters= Tube08;
    
elseif strcmp(tube_select,'Tube_09')==1
    Tube09 = [13 0;74 0];
    filters = Tube09;
    
else
    filters = [];
end
elem_filters = filters;
end

