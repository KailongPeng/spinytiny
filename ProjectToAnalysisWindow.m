function ProjectToAnalysisWindow(~,~)

global gui_CaImageViewer

selectedaxes = findobj(gcf, 'XColor', [0 1 0]);     %%% Finds the selected axes based on the color set to 'XColor' in function HighLightAxis)

%%%% Project either 1 or multiple images to the CaImageViewer window. If a
%%%% single image is projected, the slider will be disabled. If multiple
%%%% are projected, the slider will move through them in order of date.

if length(selectedaxes)==1

    animal = regexp(gui_CaImageViewer.filename, '[A-Z]{2,3}[0-9]*', 'match');
    animal = animal{1};
    date = get(get(selectedaxes, 'Title'), 'String');
    gui_CaImageViewer.save_directory = ['Z:\People\Nathan\Data\', animal, '\', date, '\summed\'];

    im = get(get(selectedaxes, 'Children'), 'CData');

    PlaceImages(im, [], 'Slider')

    %%%% Transition out of normal calcium trace extraction
    gui_CaImageViewer.GCaMP_Image = [];
    set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Enable', 'off')

    %%%% Set up parameters in an accessible substructure within the main GUI
    gui_CaImageViewer.NewSpineAnalysis = 1;
    gui_CaImageViewer.NewSpineAnalysisInfo.CurrentDate = date;

    title = get(get(selectedaxes,'XLabel'), 'String');

    if ~isempty(title)
        groupingnum = regexp(title, '[0-9]*', 'match'); groupingnum = groupingnum{1};
        currentimagegrouping = str2num(groupingnum);
    end

    gui_CaImageViewer.NewSpineAnalysisInfo.CurrentImagingField = currentimagegrouping;

else
    
    animal = regexp(gui_CaImageViewer.filename, '[A-Z]{2,3}[0-9]*', 'match');
    animal = animal{1};
    selectedaxes = flipud(selectedaxes);
    for i = 1:length(selectedaxes)
        date(i,1:6) = get(get(selectedaxes(i), 'Title'), 'String');
    end
    [sorteddates, sort_index] = sortrows(date);
    
   
    gui_CaImageViewer.save_directory = ['Z:\People\Nathan\Data\', animal, '\', sorteddates(1,:), '\summed\'];
    
    for i = 1:length(selectedaxes)
        im{i} = get(get(selectedaxes(sort_index(i)), 'Children'), 'CData');
    end
    
    PlaceImages(im{1}, [], 'Slider')

    %%%% Replace slider function to cycle through sessions
    gui_CaImageViewer.GCaMP_Image = im;
    set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Enable', 'on')
        imageserieslength = length(selectedaxes);
        set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Value', 1);
        set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Min', 1);
        set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'Max', imageserieslength);
        set(gui_CaImageViewer.figure.handles.ImageSlider_Slider, 'SliderStep', [(1/(imageserieslength-1)) (32/(imageserieslength-1))]);  %%% The Slider Step values indicate the minor and major transitions, which should be represented by the desired transition as the numerator and the length of the series as the denominator

    %%%% Set up parameters in an accessible substructure within the main GUI
    gui_CaImageViewer.NewSpineAnalysis = 1;
    gui_CaImageViewer.NewSpineAnalysisInfo.CurrentDate = date(1,:);

    title = get(get(selectedaxes(1),'XLabel'), 'String');

    if ~isempty(title)
        groupingnum = regexp(title, '[0-9]*', 'match'); groupingnum = groupingnum{1};
        currentimagegrouping = str2num(groupingnum);
        gui_CaImageViewer.NewSpineAnalysisInfo.CurrentImagingField = currentimagegrouping;
    end
end

