function varargout = spektr(varargin)
%%**************************************************************************
%% System name:      SPEKTR
%% Module name:      spektr.m
%% Version number:   1
%% Revision number:  00
%% Revision date:    15-Mar-2004
%%
%% 2004 (C) Copyright by Jeffrey H. Siewerdsen.
%%          Princess Margaret Hospital
%%
%%  Usage: spektr
%%
%%  Inputs:
%%
%%  Outputs:
%%
%%  Description:
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

% SPEKTR M-file for spektr.fig
%      SPEKTR, by itself, creates a new SPEKTR or raises the existing
%      singleton*.
%
%      H = SPEKTR returns the handle to a new SPEKTR or the handle to
%      the existing singleton*.
%
%      SPEKTR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPEKTR.M with the given input arguments.
%
%      SPEKTR('Property','Value',...) creates a new SPEKTR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spektrOpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spektrOpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spektr

% Last Modified by GUIDE v2.5 07-Jul-2003 11:25:32
% 
global q
global comp_string
global comp_thickness
global element_list
global mu_compound
global filter_list
global filter_list_comp

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spektrOpeningFcn, ...
                   'gui_OutputFcn',  @spektrOutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before spektr is made visible.
function spektrOpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spektr (see VARARGIN)

% Choose default command line output for spektr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spektr wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Put the axis property "hold on" by default
hold on;

% --- Outputs from this function are returned to the command line.
function varargout = spektrOutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q % x-ray energy spectrum
global q0 % initial x-ray energy spectrum before added filtration
global filter_list
global filter_list_comp
global element_list
global mu_compound

% set the program state to busy
set(handles.edit14,'String','BUSY','ForegroundColor','red');

% refresh screen
drawnow;

% initialize the filter lists
filter_list = [];
filter_list_comp = [];

% X-Ray tube settings

% Extract kVp
kVp = str2double(get(handles.edit1,'string'));

% Extract kVRipple
kVRipple = str2double(get(handles.edit2,'string'));

% Extract mm Al
AlFilterThick = str2double(get(handles.edit3,'string'));

% Generate x-ray spectrum
q = spektrSpectrum(kVp,[AlFilterThick kVRipple]);

% Tube Select
hObject = findobj('Tag','popupmenu2');
val = get(hObject,'Value');
string_list = get(hObject,'String');
tube_select = (string_list{val}); % convert from cell array to string

% Find the tube selected, filter the beam accordingly
if strcmp(tube_select,'Boone/Fewell')==1
    q = spektrBeers(q,[13 0;74 0]);
end

if strcmp(tube_select,'Tube_01')==1
    q = spektrBeers(q,[13 0;74 -0.002]);
elseif strcmp(tube_select,'Tube_02')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_03')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_04')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_05')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_06')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_07')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_08')==1
    q = spektrBeers(q,[13 0;74 0]);
elseif strcmp(tube_select,'Tube_09')==1
    q = spektrBeers(q,[13 0;74 0]);
else
    ;
end

% set the program state to ready
set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

%color handling of plot
hObject = findobj('Tag','popupmenu1');
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = (string_list{val}); % convert from cell array to string
color = selected_string;

%Plot x-ray spectrum
plot(q,color);
xlabel('keV');
ylabel('Photon Output');
title('X-Ray Spectrum');
grid on;

% Store Initial spectrum for reset if desired
q0 = q;

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    hold on;
else
    % checkbox is not checked-take approriate action
    hold off;
end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% % --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenu1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenu1

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

exposure = spektrExposure(q);
set(handles.edit4,'String',num2str(exposure));

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

%Extract HVL scheme
hObject = findobj('Tag','popupmenu3');
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = (string_list{val}); % convert from cell array to string

%Extract which element to calculate HVL for
hObject2 = findobj('Tag','popupmenu4');
val2 = get(hObject2,'Value');
string_list2 = get(hObject2,'String');
selected_string2 = (string_list2{val2}); % convert from cell array to string
atomic_number = spektrElement2Z(selected_string2);

if strcmp(selected_string,'HVL1')==1
    h = spektrHVLn(q,1,atomic_number);
elseif strcmp(selected_string,'HVL2')==1
    h = spektrHVLn(q,2,atomic_number);        
elseif strcmp(selected_string,'HVL3')==1
    h = spektrHVLn(q,3,atomic_number);        
elseif strcmp(selected_string,'TVL')==1
    h = spektrHVLn(q,log(10)/log(2),atomic_number);
else
    ;
end

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);
set(handles.edit5,'String',num2str(h));

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu4


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;
exposure = spektrExposure(q)/4;
set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);
set(handles.edit6,'String',num2str(exposure));

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;
q = spektrNormalize(q);
set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

%color handling of plot
hObject = findobj('Tag','popupmenu1');
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = (string_list{val}); % convert from cell array to string
color = selected_string;

plot(q,color);
xlabel('keV');
ylabel('Photon Output');
title('X-Ray Spectrum');
grid on;

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add filter to filter list

global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

set(handles.edit14,'String','BUSY');
set(handles.edit14,'ForegroundColor','red');
drawnow;

%filter materials from listbox
hObject = findobj('Tag','listbox2');
val = get(hObject,'Value');
string_list = get(hObject,'String');
filter_to_add = strtok((string_list{val})); % convert from cell array to string

%filter materials from listbox
thickness = str2double(get(handles.edit7,'string'));

% Add filter materials to filter list
if size(filter_list,1) == 0
    filter_list(1,1) = spektrElement2Z(filter_to_add);
    filter_list(1,2) = thickness;
    row = 1;
else
    row = size(filter_list,1);
    row = row+1;
    filter_list(row,1) = spektrElement2Z(filter_to_add);
    filter_list(row,2) = thickness;
end

% Generate Element Filter List [Z thickness;.. ..;.. ..];

list = '';

for j=1:size(filter_list,1),
    temp = strcat('(Z=',num2str(filter_list(j,1)),')__',num2str(filter_list(j,2)),'mm');
    if j==1 
        list = temp;
    else
        list = strvcat(list,temp);
    end    
end

if size(filter_list_comp,1)==0
    ;
else
    % Generate Filter Compound List [C thickness;.. ..;.. ..]
    for i=1:size(filter_list_comp,1),
        temp = strcat('(C=',num2str(filter_list_comp(i,1)),')__',num2str(filter_list_comp(i,2)),'mm');
        list = strvcat(list,temp);
    end
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if generate_compound_exists==1
    if comp_thickness==0
        ;
    else
        temp = strcat('New.Comp','_',num2str(comp_thickness),'mm');
        list = strvcat(list,temp);
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% ADDED
set(handles.listbox3,'String',list);

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

    
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Remove filter from list

global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

%filter materials from listbox
val3 = get(handles.listbox3,'Value');
row_to_delete = val3;

if row_to_delete==0 | isempty(filter_list) | row_to_delete>size(filter_list,1)
    ;
else
    % Delete the filter of interest
    filter_list(row_to_delete,:) = [];
end

% Generate the listing of filters/thicknesses in the listbox3
list = [];

% Generate elemental filter list
for j=1:size(filter_list,1),
    temp = strcat('(Z=',num2str(filter_list(j,1)),')__',num2str(filter_list(j,2)),'mm');
    if j==1
        list = temp;
    else
        list = strvcat(list,temp);
    end    
end

% Generate compound filter list
if size(filter_list_comp,1)==0
    ;
else
    for i=1:size(filter_list_comp,1),
        temp = strcat('(C=',num2str(filter_list_comp(i,1)),')__',num2str(filter_list_comp(i,2)),'mm');
        list = strvcat(list,temp);
    end
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if generate_compound_exists==1
    if comp_thickness==0
        ;
    else
        temp = strcat('New.Comp','_',num2str(comp_thickness),'mm');
        list = strvcat(list,temp);
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADDED
%list = strvcat(list,' ');
set(handles.listbox3,'String',list);
selection = get(handles.listbox3,'Value');
if selection > size(list,1) & size(list,1)>0
    set(handles.listbox3,'Value',size(list,1))
end

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Added Filtration

global q % [x-ray spectra]
global q0 % [x-ray spectra]
global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

% Reset Spectrum to initial conditions
q = q0;

if size(q,1)==0
    h = msgbox('Must generate an x-ray spectrum to filter.');
else
    for i=1:size(filter_list,1),
        q = spektrBeers(q,[filter_list(i,1) filter_list(i,2)]);
    end

    for i=1:size(filter_list_comp,1),
        q = spektrBeersCompoundsNIST(q,[filter_list_comp(i,1) filter_list_comp(i,2)]);
    end
end

if generate_compound_exists==1
    q = q.*exp(-mu_compound/10*comp_thickness);
end

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

%color handling of plot
hObject = findobj('Tag','popupmenu1');
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = (string_list{val}); % convert from cell array to string
color = selected_string;

%Plot x-ray spectrum
plot(q,color);
xlabel('keV');
ylabel('Photon Output');
title('X-Ray Spectrum');
grid on;


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
% contents = get(hObject,'String');
% selection = get(hObject,'Value');
% last_selection = size(contents,1);
% if selection > last_selection
%     set(hObject,'Value',last_selection)
% end

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

EnergyVector = [1:1:150]';
data_SAVE = [EnergyVector q];

% write data to file
file_SAVE = get(handles.edit8,'String');
fid = fopen(file_SAVE,'wt');
for i=1:150,
    fprintf(fid,'%d   %d\n',data_SAVE(i,1),data_SAVE(i,2));
end

fclose(fid);
% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load in spectral data
% format to read in is the following [EnergyVector   q; ...]

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

% imported data from file
data_LOAD(150:2)=0;

% write data to file
file_LOAD_name = get(handles.edit9,'String');
fid = fopen(file_LOAD_name,'r');

data_LOAD = fscanf(fid,'%f %f',[2 inf]);
data_LOAD = data_LOAD';
q = data_LOAD(1:150,2);

messageBox = msgbox('LOADING FILE REQUIREMENTS:                                                                                                        The file which is loaded must be a tab delimited ASCII text file.                  FILE FORMAT: 150x2 table of the following form:                                       [ monoenergies photon_output ; .. .. ; .. .. ]','SPEKTR 1.1');

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

cla;

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

FPE = round(spektrFluencePerExposure(q));
set(handles.edit10,'String',num2str(FPE));

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Equivalent mm Al

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

% change program state to busy
set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

% v2: generate unfiltered spectrum at specified kVp, and pass as input
% to equivalent filtration functions (previously only for 100 kVp)

% Extract kVp
kVp = str2double(get(handles.edit1,'string'));

% Extract kVRipple
kVRipple = str2double(get(handles.edit2,'string'));

% Extract mm Al
AlFilterThick = str2double(get(handles.edit3,'string'));

% Generate x-ray spectrum
qUnfiltered = spektrSpectrum(kVp,[AlFilterThick kVRipple]);

value = 0;
value2 = 0;
value3 = 0;

% find the equiv mm Al of elements
if size(filter_list,1)==0
    ;
else
    value = spektrEquiv_mmAl(qUnfiltered,filter_list);
end

% find the equiv mm Al of compounds
if size(filter_list_comp,1)==0
    ;
else
    % v2: correct bug in v0&v1 by using a new function for NIST compounds
    value2 = spektrEquiv_mmAl_CompoundsNIST(qUnfiltered,filter_list_comp);
end

% find the equiv mm Al of generated compounds
if generate_compound_exists==1
    value3 = spektrEquiv_mmAl_Compound(qUnfiltered,mu_compound,comp_thickness);
else
    ;
end

% sum all mm Al contributions
value = value+value2+value3;

% set the mm Al field value
set(handles.edit11,'String',num2str(value));

% change program state to ready
set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%
%  * Load *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'LOAD X-RAY SPECTRA FROM FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit9,'String',strcat(pathname,filename));


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%
%  * Save *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'SAVE X-RAY SPECTRA TO FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit8,'String',strcat(pathname,filename));


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a
%        double


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add compound filter to filter list

global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

%filter materials from listbox
hObject = findobj('Tag','listbox4');
val = get(hObject,'Value');
string_list = get(hObject,'String');
filter_to_add = strtok((string_list{val})); % convert from cell array to string

%filter materials from listbox
thickness = str2double(get(handles.edit15,'string'));

% Add filter materials to filter_list_comp
if size(filter_list_comp,1)==0
    filter_list_comp(1,1) = spektrCompound2C(filter_to_add);
    filter_list_comp(1,2) = thickness;
    row = 1;
else
    row = size(filter_list_comp,1);
    row = row+1;
    filter_list_comp(row,1) = spektrCompound2C(filter_to_add);
    filter_list_comp(row,2) = thickness;
end

list = [];

% Generate Filter List [Z thickness;.. ..;.. ..];

if size(filter_list,1)==0
    condition = 1;
else
    % For elemental filters
    for j=1:size(filter_list,1),
        temp = strcat('(Z=',num2str(filter_list(j,1)),')__',num2str(filter_list(j,2)),'mm');
        if j==1
            list = temp;
        else
            list = strvcat(list,temp);
        end    
    end
    condition= 0;
end

% For compound filters
for j=1:size(filter_list_comp,1),
    temp = strcat('(C=',num2str(filter_list_comp(j,1)),')__',num2str(filter_list_comp(j,2)),'mm');
    if condition==1 & j==1
        list = temp;
    else
        list = strvcat(list,temp);
    end    
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if generate_compound_exists==1;
    if comp_thickness==0
        ;
    else
        temp = strcat('New.Comp','_',num2str(comp_thickness),'mm');
        list = strvcat(list,temp);
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADDED
%list = strvcat(list,' ');    
set(handles.listbox3,'String',list);

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Remove filter from list

global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

%filter materials from listbox
hObject = findobj('Tag','listbox3');
val3 = get(hObject,'Value');

% find the length of the element list
filter_list_length = size(filter_list,1);

% find the length of the compound list
filter_list_comp_length = size(filter_list_comp,1);

% find the index of the compound in the compound list
difference = filter_list_length-val3;

% delete the compound of interest

if difference<0 & ~isempty(filter_list_comp)
    row_to_delete = abs(difference);
    % Delete the filter of interest
    filter_list_comp(row_to_delete,:) = [];
else
    ;
end

% Generate the listing of filters/thicknesses in the listbox3
list = [];

if size(filter_list,1)==0
    condition = 1;
else
    % Generate elemental filter list
    for j=1:size(filter_list,1),
        temp = strcat('(Z=',num2str(filter_list(j,1)),')__',num2str(filter_list(j,2)),'mm');
        if j==1
            list = temp;
        else
            list = strvcat(list,temp);
        end    
    end
    condition = 0;
end

% Generate compound filter list

for i=1:size(filter_list_comp,1),
    temp = strcat('(C=',num2str(filter_list_comp(i,1)),')__',num2str(filter_list_comp(i,2)),'mm');
    if condition==1 & i==1
        list = temp;
    else
        list = strvcat(list,temp);
    end    
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if generate_compound_exists==1;
    if comp_thickness==0
        ;
    else
        temp = strcat('New.Comp','_',num2str(comp_thickness),'mm');
        list = strvcat(list,temp);
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADDED
%list = strvcat(list,' ');    
set(handles.listbox3,'String',list);
selection = get(handles.listbox3,'Value');
if selection > size(list,1) & size(list,1)>0
    set(handles.listbox3,'Value',size(list,1))
end
set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

meanEnergy = spektrMeanEnergy(q);
set(handles.edit16,'String',num2str(meanEnergy));

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound

close(spektr);
spektrCompound;

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global filter_list
global filter_list_comp
global element_list
global mu_compound


close(spektr);
spektrTransmission;


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CLEAR LIST

% Remove filter from list

global q
global q0 % initial x-ray energy spectrum before added filtration
global filter_list
global filter_list_comp
global element_list
global mu_compound
global comp_string
global comp_thickness

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

% Delete the ENTIRE filter list of interest
filter_list_comp = [];
filter_list = [] ;
element_list = [];
comp_thickness = 0;
comp_string = '';

% Generate the listing of filters/thicknesses in the listbox3
list = [];

% Reset Initial Spectrum
q = q0;

% ADDED
set(handles.listbox3,'String',list);
set(handles.listbox3,'Value',1);

% Clear generated compound window name
set(handles.edit17,'String',list);

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q
global element_list
global mu_compound
global comp_string
global comp_thickness
global generate_compound_exists

generate_compound_exists = 1;

set(handles.edit14,'String','BUSY','ForegroundColor','red');
drawnow;

if comp_thickness == 0
        set(handles.edit17,'String','');
else
    temp = strcat('New.Comp_',num2str(comp_thickness),'mm');
    set(handles.edit17,'String',comp_string);
    set(handles.listbox3,'String',temp);
end

set(handles.edit14,'String','READY','ForegroundColor',[0 0.5 0]);

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global q
% global filter_list
% global filter_list_comp
% global element_list
% global mu_compound
% 
% set(handles.edit14,'String','BUSY');
% set(handles.edit14,'ForegroundColor','red');
% drawnow;
% 
% EnergyVector=[1:1:150]';
% data_SAVE=[EnergyVector q];
% 
% % write data to file
% file_SAVE='workspace_q';
% fid=fopen(file_SAVE,'w');
% for i=1:150,
%     fprintf(fid,'%d   %d\r',data_SAVE(i,1),data_SAVE(i,2));
% end
% fclose(fid);
% 
% load('workspace_q');
% 
% set(handles.edit14,'String','READY');
% set(handles.edit14,'ForegroundColor',[0 0.5 0]);