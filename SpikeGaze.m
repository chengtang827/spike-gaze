function varargout = SpikeGaze(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 24-Jul-2017 11:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('sessions.mat');
%give $sessions$
load('neuron_names.mat');
%give neurons

handles.sessions = sessions;
handles.neurons = neurons;
handles.sessionnr = 1;
handles.trialnr = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using untitled.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

plot3(handles);




% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --------------------------------------------------------------------
function uipanel1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in prev_button.
function prev_button_Callback(hObject, eventdata, handles)
% hObject    handle to prev_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if check_exist(handles.sessionnr, handles.trialnr-1, handles) == 0
    if check_exist(handles.sessionnr-1,1,handles) == 1
        %jump to the previous session
        handles.sessionnr = handles.sessionnr - 1;
        handles.trialnr = length(handles.sessions(handles.sessionnr).trials);
    end
else
    %simply decrement the trial number
    handles.trialnr = handles.trialnr - 1;
    
end
updateUI(hObject, handles);


% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if check_exist(handles.sessionnr, handles.trialnr+1, handles) == 0
    if check_exist(handles.sessionnr+1,1,handles) == 1
        %jump to the next session
        handles.sessionnr = handles.sessionnr + 1;
        handles.trialnr = 1;
    end
else
    %simply increment the trial number
    handles.trialnr = handles.trialnr + 1;
    
end
updateUI(hObject, handles);

function updateUI(hObject, handles)
guidata(hObject, handles);
set(handles.session_edit,'string',int2str(handles.sessionnr));
set(handles.trial_edit,'string',int2str(handles.trialnr));
plot3(handles);

function result = check_exist(sessionnr, trialnr, handles)
try
    handles.sessions(sessionnr).trials(trialnr);
    result = 1;
catch
    result = 0;
end


function plot3(handles)
%plot spike, gaze and pupil

sessionnr =  handles.sessionnr;
trialnr = handles.trialnr;
trial_spike = handles.sessions(sessionnr).trials(trialnr);
trial_gaze = handles.sessions(sessionnr).trials(trialnr);
neurons = handles.neurons;

%plot the events
%plot fixation on 3 figures
try
    fixation = trial_gaze.fixation_start;
    
    %on spike plot
    axes(handles.axes1);
    cla reset;
    title('Spike Raster Plot');
    xlabel('time/ms');
    ylabel('neuron index');
    line([fixation,fixation],[0,length(neurons)]);
    text(double(fixation),length(neurons),'fixation','rotation',45);
    hold on;
    
    %on the gaze plot
    axes(handles.axes2);
    cla reset;
    title('Gaze Position');
    gaze_height = double(max(max(trial_gaze.gazey(1,:)),max(trial_gaze.gazex(1,:))));
    line([fixation,fixation],[0,gaze_height]);
    text(double(fixation),gaze_height,'fixation','rotation',45);
    hold on;
    
    %on the pupil plot
    axes(handles.axes3);
    cla reset;
    title('Pupil Size');
    pupil_height = double(max(trial_gaze.pupil(1,:)));
    line([fixation,fixation],[0,pupil_height]);
    text(double(fixation),pupil_height,'fixation','rotation',45);
    hold on;
catch
end

%plot target on 3 figures
try
    target = trial_gaze.target.timestamp;
    
    %on spike plot
    axes(handles.axes1);
    line([target,target],[0,length(neurons)]);
    text(double(target),length(neurons),'target','rotation',45);
    hold on;
    
    %on the gaze plot
    axes(handles.axes2);
    line([target,target],[0,gaze_height]);
    text(double(target),gaze_height,'target','rotation',45);
    hold on;
    
    %on the pupil plot
    axes(handles.axes3);
    line([target,target],[0,pupil_height]);
    text(double(target),pupil_height,'target','rotation',45);
    hold on;
catch
end

%plot distractor on 3 figures
try
    distractor = trial_gaze.distractor.timestamp;
    
    %on spike plot
    axes(handles.axes1);
    line([distractor,distractor],[0,length(neurons)]);
    text(double(distractor),length(neurons),'distractor','rotation',45);
    hold on;
    
    %on the gaze plot
    axes(handles.axes2);
    line([distractor,distractor],[0,gaze_height]);
    text(double(distractor),gaze_height,'distractor','rotation',45);
    hold on;
    
    %on the pupil plot
    axes(handles.axes3);
    line([distractor,distractor],[0,pupil_height]);
    text(double(distractor),pupil_height,'distractor','rotation',45);
    hold on;
catch
end

%plot cue on 3 figures
try
    cue = trial_gaze.response_cue;
    
    %on spike plot
    axes(handles.axes1);
    line([cue,cue],[0,length(neurons)]);
    text(double(cue),length(neurons),'cue','rotation',45);
    hold on;
    
    %on the gaze plot
    axes(handles.axes2);
    line([cue,cue],[0,gaze_height]);
    text(double(cue),gaze_height,'cue','rotation',45);
    hold on;
    
    %on the pupil plot
    axes(handles.axes3);
    line([cue,cue],[0,pupil_height]);
    text(double(cue),pupil_height,'cue','rotation',45);
    hold on;
catch
end

%plot spike
axes(handles.axes1);
for i = 1:length(neurons)
    neuron_spike = trial_spike.(cell2mat(neurons(i)));
    scatter(neuron_spike,ones(length(neuron_spike),1).*i,'k','.');
    hold on;
end
hold off;

%plot gaze
axes(handles.axes2);
legend off;
legend on;
h(1) = plot(1:0.5:length(trial_gaze.gazex)/2+0.5,trial_gaze.gazex(1,:));
hold on;
h(2) = plot(1:0.5:length(trial_gaze.gazey)/2+0.5,trial_gaze.gazey(1,:));
legend(h,{'X','Y'},'Location','best');
hold off;

%plot pupil
axes(handles.axes3);
plot(1:0.5:length(trial_gaze.pupil)/2+0.5,trial_gaze.pupil(1,:));
hold off;



function session_edit_Callback(hObject, eventdata, handles)
% hObject    handle to session_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of session_edit as text
%        str2double(get(hObject,'String')) returns contents of session_edit as a double

sessionnr = str2double(get(hObject,'String'));
if check_exist(sessionnr, handles.trialnr, handles) == 1
    handles.sessionnr = sessionnr;
    updateUI(hObject, handles);
else
    fprintf("%s\n","Invalid input");
end

    


% --- Executes during object creation, after setting all properties.
function session_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trial_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trial_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_edit as text
%        str2double(get(hObject,'String')) returns contents of trial_edit as a double
trialnr = str2double(get(hObject,'String'));
if check_exist(handles.sessionnr, trialnr, handles) == 1
    handles.trialnr = trialnr;
    updateUI(hObject, handles);
else
    fprintf("%s\n","Invalid input");
end


% --- Executes during object creation, after setting all properties.
function trial_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
