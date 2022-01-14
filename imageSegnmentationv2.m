function varargout = imageSegnmentationv2(varargin)
% IMAGESEGNMENTATIONV2 MATLAB code for imageSegnmentationv2.fig
%      IMAGESEGNMENTATIONV2, by itself, creates a new IMAGESEGNMENTATIONV2 or raises the existing
%      singleton*.
%
%      H = IMAGESEGNMENTATIONV2 returns the handle to a new IMAGESEGNMENTATIONV2 or the handle to
%      the existing singleton*.
%
%      IMAGESEGNMENTATIONV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGESEGNMENTATIONV2.M with the given input arguments.
%
%      IMAGESEGNMENTATIONV2('Property','Value',...) creates a new IMAGESEGNMENTATIONV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageSegnmentationv2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageSegnmentationv2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageSegnmentationv2

% Last Modified by GUIDE v2.5 23-Apr-2021 04:58:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageSegnmentationv2_OpeningFcn, ...
                   'gui_OutputFcn',  @imageSegnmentationv2_OutputFcn, ...
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

% --- Executes just before imageSegnmentationv2 is made visible.
function imageSegnmentationv2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageSegnmentationv2 (see VARARGIN)

global Seg
handles.output = hObject;
handles.Seg = 0;
handles.BW = 0;
handles.Sharp = 0;
guidata(hObject, handles);
% Update handles structure

% UIWAIT makes imageSegnmentationv2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = imageSegnmentationv2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in importImageButton.
function importImageButton_Callback(hObject, eventdata, handles)
global loadImage;
waitfor(msgbox('Please import an x-ray file of type jpg,jpeg or png any other type would end in failure.', 'Notification'));
[image, rawname] = uigetfile({'*.jpg';'*.png';'*.jpeg';'*.*'}, 'Choose an x-ray Image');
 if isequal(image, 0) % if user cancels then show canceled
    disp('This operation was canceled/aborted by the user');
    waitfor(msgbox('This operation was canceled by the user', 'Canceled'));
    return;
 else
    loadImage = imread(image);
    axes(handles.axes1);
    imshow(loadImage);
    myicon = imread('myicon.jpg');
    waitfor(msgbox('Image loaded Succesfully', 'Success', 'custom', myicon));
    title('X-ray sample');
    handles.loadImage = loadImage;
    guidata(hObject, handles);
 end    

% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.newvalT = 0;
handles.newvalB = 0;

imageSample=handles.loadImage;
axes(handles.axes2);
imshow(imageSample)
myicon = imread('myicon.jpg');
waitfor(msgbox('Image reset was Succesfull', 'Success', 'custom', myicon));
title('X-ray Reset');
handles.Seg = 0;
handles.BW = 0;
handles.Sharp = 0;

% --- Executes on button press in MeasureButton.
function MeasureButton_Callback(hObject, eventdata, handles)
line=imdistline();
msgbox('It''s being measured in Pixels');
dist = getDistance(line);

% --- Executes on button press in SegmentationButton1.
function SegmentationButton1_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationButton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segmentation
imageSample=handles.loadImage;
Segmentation = im2bw(imageSample,0.68);
axes(handles.axes2);
imshow(Segmentation)
title('X-ray Segmentantion');
handles.Segmentation = Segmentation;
handles.Seg = 1;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in SegmentationButton2.
function SegmentationButton2_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationButton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segmentation
imageSample=handles.loadImage;
Segmentation = imtophat(imageSample,strel('disk', 12));
axes(handles.axes2);
imshow(Segmentation)
title('X-ray Top-Hat Filter');
handles.Segmentation = Segmentation;
guidata(hObject, handles);

% --- Executes on button press in SegmentationButton3.
function SegmentationButton3_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationButton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segmentation
imageSample=handles.loadImage;
Segmentation = rgb2gray(imageSample);
Segmentation = edge(Segmentation, 'sobel');
axes(handles.axes2);
imshow(Segmentation);
title('X-ray Sobel Edge Detection');
handles.Segmentation = Segmentation;
guidata(hObject, handles);

% --- Executes on button press in SegmentationButton4.
function SegmentationButton4_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationButton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Segmentation
imageSample=handles.loadImage;
Segmentation = rgb2gray(imageSample);
Segmentation = edge(Segmentation, 'canny');
axes(handles.axes2);
imshow(Segmentation);
title('X-ray Canny Edge Detection');
handles.Segmentation = Segmentation;
guidata(hObject, handles);

% --- Executes on slider movement.
function threshold_slider_Callback(hObject, eventdata, handles)

global newvalT BW %declaring global variables
imageSample=handles.loadImage; %loading image
k = numel(size(imageSample))>=3; %Checking if image is 3 dimension or 2 dimension
if( k == 0)
    gray = imageSample;
else
    gray = rgb2gray(imageSample); %converting image into grayscale
end
maxlevel = graythresh(gray); %finding out the maximum threshold level in image
set(hObject, 'min', 0);
set(hObject, 'max', maxlevel);
val = get(hObject,'value');

newvalT = val;
BW = im2bw(gray, newvalT);
axes(handles.axes2);
imshow(BW)
title('Thresholding');
handles.newvalT = newvalT;
handles.BW = BW;
handles.BW = 1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function threshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Brightness_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Brightness_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global newvalB imageSharp;
imageSample = handles.loadImage;
val = get(hObject,'value');
if (val==0)
    newvalB = 0;
elseif (val > 0 && val < 1)
    newvalB = val * 100; %setting brightness level
elseif (val == 1)
    newvalB = 100;
end
imageSharp = imageSample + newvalB; %adding brightness in image
axes(handles.axes2);
imshow(imageSharp)
title('Brightness');
handles.newvalB = newvalB;
handles.imageSharp = imageSharp;
handles.Sharp = 1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Brightness_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Brightness_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in FractureDetectionButton.
function FractureDetectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to FractureDetectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frame = getframe(handles.axes2); %get frame from axes
im = frame2im(frame);%convert frame to image
if(handles.Seg == 1)
    SegementedIm = handles.Segmentation; %if segmentation took place then save image
    imwrite(im, 'segmented.jpg');
    handles.Seg = 0;
end
if (handles.Sharp == 1)
    SharpIm = handles.imageSharp; % if brightness took place then save image
    imwrite(im, 'sharped.jpg');
    handles.Sharp = 0;
end
if (handles.BW == 1)
    BinIm = handles.BW; %if binarization took place then save image
    imwrite(im, 'binarized.jpg');
    handles.BW = 1;
end

myicon = imread('myicon.jpg');
waitfor(msgbox('Image saving was Succesfull', 'Success', 'custom', myicon));
guidata(hObject, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
msgbox('Thanks for using this tool exiting...');
pause(1.5);
clc;
close();
close();
