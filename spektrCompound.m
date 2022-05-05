function varargout = spektrCompound(varargin)
% COMPOUND M-file for spektrCompound.fig
%      COMPOUND, by itself, creates a new COMPOUND or raises the existing
%      singleton*.
%
%      H = COMPOUND returns the handle to a new COMPOUND or the handle to
%      the existing singleton*.
%
%      COMPOUND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPOUND.M with the given input arguments.
%
%      COMPOUND('Property','Value',...) creates a new COMPOUND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spketrCompoundOpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spektrCompoundOpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spektrCompound

% Last Modified by GUIDE v2.5 04-Jul-2003 13:08:13

global mu_compound
global element_list
global comp_string
global comp_thickness

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spektrCompoundOpeningFcn, ...
                   'gui_OutputFcn',  @spektrCompoundOutputFcn, ...
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

% --- Executes just before spektrCompound is made visible.
function spektrCompoundOpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spektrCompound (see VARARGIN)

% Choose default command line output for spektrCompound
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global element_list
global comp_string
global comp_thickness
element_list=[];

% UIWAIT makes spektrCompound wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = spektrCompoundOutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


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


% Add filter to filter list

global element_list
global comp_string
global comp_thickness

% set the program state to busy
set(handles.edit7,'String','BUSY');
set(handles.edit7,'ForegroundColor','red');

% refresh screen
drawnow;

%constituent element from listbox
hObject=findobj('Tag','listbox2');
val = get(hObject,'Value');
string_list = get(hObject,'String');
element_to_add = strtok((string_list{val})); % convert from cell array to string

%filter materials from listbox
numberElements_input = get(handles.edit1,'string');
numberElements = str2double(numberElements_input);

% Add filter materials to filter list
if size(element_list,1)==0
    element_list(1,1) = spektrElement2Z(element_to_add);
    element_list(1,2) = numberElements;
    row=1;
else
    row=size(element_list,1);
    row = row+1;
    element_list(row,1) = spektrElement2Z(element_to_add);
    element_list(row,2)=numberElements;
end

% Generate Element Filter List [Z number;.. ..;.. ..];

list='';
for j=1:size(element_list,1),
    temp=strcat('(Z=',num2str(element_list(j,1)),')  __',num2str(element_list(j,2)));
    if j==1
        list=temp;
    else
        list=strvcat(list,temp);
    end    
end

% ADDED
list=strvcat(list,' ');    
set(handles.listbox3,'String',list);

% set the program state to busy
set(handles.edit7,'String','READY');
set(handles.edit7,'ForegroundColor',[0 0.5 0]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove element

global element_list
global comp_string
global comp_thickness

% set the program state to busy
set(handles.edit7,'String','BUSY');
set(handles.edit7,'ForegroundColor','red');

% refresh screen
drawnow;

%filter materials from listbox
hObject=findobj('Tag','listbox3');
val3 = get(hObject,'Value');
row_to_delete=val3;

% Delete the filter of interest
element_list(row_to_delete,:) = [];

% Generate the listing of filters/thicknesses in the listbox3
list='';

% Generate elemental filter list
for j=1:size(element_list,1),
    temp=strcat('(Z=',num2str(element_list(j,1)),')__',num2str(element_list(j,2)));
    if j==1
        list=temp;
    else
        list=strvcat(list,temp);
    end    
end

% ADDED
list=strvcat(list,' ');    
set(handles.listbox3,'String',list);

% set the program state to busy
set(handles.edit7,'String','READY');
set(handles.edit7,'ForegroundColor',[0 0.5 0]);

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global element_list
global mu_compound
global comp_string
global comp_thickness

% set the program state to busy
set(handles.edit7,'String','BUSY');
set(handles.edit7,'ForegroundColor','red');

% refresh screen
drawnow;

%access density of compound from user
densityCompound_input=get(handles.edit2,'string');
density=str2double(densityCompound_input);

murho_compound = spektrMuRhoCompound(element_list);
mu_compound = murho_compound*density;

comp_string='';

for i=1:size(element_list,1),
    if element_list(i,2)==1
        temp=strcat(spektrZ2Element(element_list(i,1)));
    else
        temp=strcat(spektrZ2Element(element_list(i,1)),num2str(element_list(i,2)) );
    end
    comp_string=strcat(comp_string,temp);
end

set(handles.edit9,'string',comp_string);

% set the program state to busy
set(handles.edit7,'String','READY');
set(handles.edit7,'ForegroundColor',[0 0.5 0]);

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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%
%  * SAVE *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'LOAD X-RAY SPECTRA FROM FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit4,'String',strcat(pathname,filename));

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mu_compound
global comp_string
global comp_thickness

EnergyVector = [1:1:150]';
data_SAVE = [EnergyVector mu_compound];

% write data to file
file_SAVE=get(handles.edit4,'String');
fid=fopen(file_SAVE,'w');
for i=1:150,
    fprintf(fid,'%d   %d\r',data_SAVE(i,1),data_SAVE(i,2));
end

fclose(fid);


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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%
%  * SAVE *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'LOAD X-RAY SPECTRA FROM FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit8,'String',strcat(pathname,filename));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mu_compound
global comp_string
global comp_thickness

% imported data from file
data_LOAD(150:2)=0;

% write data to file
file_LOAD_name = get(handles.edit8,'String');
fid = fopen(file_LOAD_name,'r');

data_LOAD = fscanf(fid,'%f %f',[2 inf]);
data_LOAD = data_LOAD';
q = data_LOAD(1:150,2);

messageBox=msgbox('LOADING FILE REQUIREMENTS:                                                                                                        The file which is loaded must be a tab delimited ASCII text file.                  FILE FORMAT: 150x2 table of the following form:                                       [ monoenergies photon_output ; .. .. ; .. .. ]','SPEKTR 1.1');

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mu_compound
global comp_string
global comp_thickness

%color handling of plot
hObject=findobj('Tag','popupmenu1');
val = get(hObject,'Value');
string_list = get(hObject,'String');
selected_string = (string_list{val}); % convert from cell array to string
color=selected_string;

EnergyVector=1:150;
semilogy(EnergyVector,mu_compound,color);
grid on;
xlabel('Energy [keV]');
ylabel('mu [1/cm]');
title('Attenuation Coefficient');

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla;

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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mu_compound
global comp_string
global element_list
global comp_thickness

comp_thickness=str2double(get(handles.edit10,'string'));
close(spektrCompound);
spektr;


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


