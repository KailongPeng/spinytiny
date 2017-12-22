function ClipImageSeriesLength(~,~,currentlength)

global gui_CaImageViewer

newserieslength = inputdlg('Show through image:', 'Image timecourse clipper', 1, {num2str(currentlength)});

newserieslength = str2num(newserieslength{1});

gui_CaImageViewer.imageserieslength = newserieslength;

gui_CaImageViewer.GCaMP_Image = gui_CaImageViewer.GCaMP_Image(1:newserieslength);

set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Value', 1);
set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Min', 1);
set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Max', newserieslength);
set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'SliderStep', [(1/(newserieslength-1)) (32/(newserieslength-1))]);  %%% The Slider Step values indicate the minor and major transitions, which should be represented by the desired transition as the numerator and the length of the series as the denominator
set(gui_CaImageViewer.figure.handles.Frame_EditableText, 'String', 1);
set(gui_CaImageViewer.figure.handles.SmoothingFactor_EditableText, 'String', '1');
