function varargout = spektrTransmission(varargin)
% TRANSMISSION M-file for spektrTransmission.fig
%      TRANSMISSION, by itself, creates a new TRANSMISSION or raises the existing
%      singleton*.
%
%      H = spektrTRANSMISSION returns the handle to a new spektrTRANSMISSION or the handle to
%      the existing singleton*.
%
%      TRANSMISSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in spektrTRANSMISSION.M with the given input arguments.
%
%      TRANSMISSION('Property','Value',...) creates a new TRANSMISSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transmission_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transmission_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help transmission

% Last Modified by GUIDE v2.5 04-Jul-2003 09:53:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spektrTransmissionOpeningFcn, ...
                   'gui_OutputFcn',  @spektrTransmissionOutputFcn, ...
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


% --- Executes just before transmission is made visible.
function spektrTransmissionOpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transmission (see VARARGIN)

% Choose default command line output for transmission
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes transmission wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spektrTransmissionOutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x
global f
global q
global qspace
global n
global e

% set the program state to busy
set(handles.edit5,'String','BUSY');
set(handles.edit5,'ForegroundColor','red');

% refresh screen
drawnow;

hObject=findobj('Tag','popupmenu1');
val = get(hObject,'Value');
string_list = get(hObject,'String');
plotting_method = (string_list{val}); % convert from cell array to string

if strcmp(plotting_method,'Q(space)')==1
    imagesc(qspace);
    xlabel('Dimension (x)');
    ylabel('Energy [keV]');
    title('Spatially Varying X-Ray Spectra');
    colorbar;
elseif strcmp (plotting_method,'Ntot')==1
    plot(x,n);
    grid on;
    xlabel('Dimension (x)');
    ylabel('Total # of Photons');
    title('Total # of Photons of Filtered Beam');
elseif strcmp (plotting_method,'Etot')==1
    plot(x,e);
    grid on;
    xlabel('Dimension (x)');
    ylabel('Total Energy');
    title('Total Energy of Filtered Beam');
elseif strcmp (plotting_method,'Surf(q(space))')==1
    surf(qspace);
    title('Spatially Varying X-Ray Spectra');
    xlabel('Dimension (x)');
else
    plot(x,f);
    grid on;
    xlabel('Dimension (x)');
    ylabel('Filter Thickness [mm]');
    title('Filter Geometry');
end

% set the program state to busy
set(handles.edit5,'String','READY');
set(handles.edit5,'ForegroundColor',[0 0.5 0]);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla;

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

global x
global f
global q
global qspace
global n
global e
global spectra

% set the program state to busy
set(handles.edit5,'String','BUSY');
set(handles.edit5,'ForegroundColor','red');

% refresh screen
drawnow;

start_in=get(handles.edit1,'string');
start=str2double(start_in);

interval_in=get(handles.edit2,'string');
interval=str2double(interval_in);

finish_in=get(handles.edit3,'string');
finish=str2double(finish_in);

expression=get(handles.edit4,'string');

%filter materials from popupmenu
hObject=findobj('Tag','popupmenu2');
val = get(hObject,'Value');
string_list = get(hObject,'String');
filter_to_add = strtok((string_list{val})); % convert from cell array to string
atomic_number = spektrElement2Z(filter_to_add);

x = (start:interval:finish);
f = eval(expression);

[qspace n e] = spektrTransmissionX(q,atomic_number,f);

for j=1:size(qspace,2),
    qspace(1:150,j) = spektrNormalize(qspace(1:150,j));
end

imagesc(qspace);
xlabel('Dimension (x)');
ylabel('Energy [keV]');
title('Spatially Varying X-Ray Spectra');
colorbar;

% set the program state to ready
set(handles.edit5,'String','READY');
set(handles.edit5,'ForegroundColor',[0 0.5 0]);

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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%
%  * Load *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'LOAD X-RAY SPECTRA FROM FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit7,'String',strcat(pathname,filename));

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q

% set the program state to ready
set(handles.edit5,'String','BUSY');
set(handles.edit5,'ForegroundColor','red');

% REFRESH SCREEN

drawnow;

% imported data from file
data_LOAD(150:2)=0;

% write data to file
file_LOAD_name=get(handles.edit7,'String');
fid=fopen(file_LOAD_name,'r');

data_LOAD=fscanf(fid,'%f %f',[2 inf]);
data_LOAD=data_LOAD';
q=data_LOAD(1:150,2);

messageBox=msgbox('LOADING FILE REQUIREMENTS:                                                                                                        The file which is loaded must be a tab delimited ASCII text file.                  FILE FORMAT: 150x2 table of the following form:                                       [ monoenergies photon_output ; .. .. ; .. .. ]','SPEKTR 1.1');

% set the program state to ready
set(handles.edit5,'String','READY');
set(handles.edit5,'ForegroundColor',[ 0 0.5 0]);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global q

close(spektrTransmission);
spektr;


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
%  * Save *  %
%%%%%%%%%%%%%%

[filename, pathname] = uigetfile('*.*', 'SAVE X-RAY SPECTRA TO FILE');

%%% Set INFO in EditText objects in LOAD frame
set(handles.edit8,'String',strcat(pathname,filename));

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x % DIMENSION X
global f % FILTER GEOMETRY
global q % X-RAY SPECTRA
global qspace % X-RAY SPECTRA(SPACE)
global n % NUMBER OF PHOTONS
global e % TOTAL ENERGY

% set the program state to ready
set(handles.edit5,'String','BUSY');
set(handles.edit5,'ForegroundColor','red');

% refresh screen
drawnow;

data_SAVE_qspace=qspace;
data_SAVE_n = [x' n'];
data_SAVE_e = [x' e'];

% write data to file
file_SAVE=get(handles.edit8,'String');

file_SAVE_qspace=strcat(file_SAVE,'_qspace.txt');
file_SAVE_n=strcat(file_SAVE,'_n.txt');
file_SAVE_e=strcat(file_SAVE,'_e.txt');

fid_qspace=fopen(file_SAVE_qspace,'w');
fid_n=fopen(file_SAVE_n,'w');
fid_e=fopen(file_SAVE_e,'w');

for i=1:150
    for j=1:size(f,2),
        if j==size(f,2)
            fprintf(fid_qspace,'%d\r',data_SAVE_qspace(i,j));
        else
            fprintf(fid_qspace,'%d   ',data_SAVE_qspace(i,j));
        end
    end
end

for i=1:size(f,2),
    fprintf(fid_n,'%d   %d\r',data_SAVE_n(i,1),data_SAVE_n(i,2));
end

for i=1:size(f,2),
    fprintf(fid_e,'%d   %d\r',data_SAVE_e(i,1),data_SAVE_e(i,2));
end

fclose(fid_qspace);
fclose(fid_n);
fclose(fid_e);

% set the program state to ready
set(handles.edit5,'String','READY');
set(handles.edit5,'ForegroundColor',[0 0.5 0]);