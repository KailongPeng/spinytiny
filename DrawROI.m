function DrawROI(hObject, eventdata, ROInum, Router)

program = get(gcf);

running = program.FileName;
% 
% if isempty(running)
%     running = 'CaImageViewer';
% end

if ~isempty(regexp(running, 'CaImageViewer'))
    global gui_CaImageViewer
    glovar = gui_CaImageViewer;
    axes1 = glovar.figure.handles.GreenGraph;
    axes2 = glovar.figure.handles.RedGraph;
    twochannels = glovar.figure.handles.TwoChannels_CheckBox;
    zoom = str2num(get(glovar.figure.handles.Zoom_EditableText, 'String'));
    if zoom > 10 
        radius = 30;
    else
        radius = 20;
    end
elseif ~isempty(regexp(running, 'FluorescenceSuite'));
    global gui_FluorescenceSuite
    glovar = gui_FluorescenceSuite;
    axes1 = glovar.figure.handles.Green_Axes;
    axes2 = glovar.figure.handles.Red_Axes;
    twochannels = [];
    radius = 15;
else
    global sideline
    global gui_CaImageViewer;
    glovar = gui_CaImageViewer;
    axes1 = gca;
    axes2 = [];
    twochannels = [];
    radius = 10;
end

if ~isnumeric(ROInum)
    ROInum = str2double(ROInum);
end

if strcmpi(Router, 'FineSelect')
    edgewidth = 2;
    textsize = 12;
    set(gcf, 'WindowButtonDownFcn', [])
else
    edgewidth = 1;
    textsize = 10;
end

cmap = glovar.CurrentCMap; 

if strcmpi(cmap, 'RGB')
    linecolor = 'g';
elseif strcmpi(cmap, 'Jet')
    linecolor = 'w';
elseif strcmpi(cmap, 'Hot')
    linecolor = 'r';
elseif strcmpi(cmap, 'Fire')
    linecolor = 'g'; %when this linecolor changed, the linecolor of zoomin window changed, ZL  comment
end

% Backgroundtoggle = get(glovar.figure.handles.BackgroundROI_ToggleButton, 'Value');
% StimSpinetoggle = get(glovar.figure.handles.SpineROI_ToggleButton, 'Value');
% Nearbytoggle = get(glovar.figure.handles.NearbySpine_ToggleButton, 'Value');

% waitforbuttonpress;
pointer_location1 = get(gca, 'CurrentPoint');

% Use the following to allow single-click selection of ROIs
point = pointer_location1(1,1:2);
Fl_ROI(1) = point(1)-radius/2; Fl_ROI(2) = point(2)-radius/2;
Fl_ROI(3) = radius; Fl_ROI(4) = radius;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if strcmpi(Router, 'FineSelect') && ROInum ~=0      %%% When fine-tuning the ROI around a spine, you want the "DragROI" button down function
    axes(axes1)
    glovar.ROI(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', linecolor, 'Curvature', [1 1], 'Tag', ['ROI', num2str(ROInum)], 'ButtonDownFcn', {@DragROI, ROInum, 'ZoomWindow'}, 'Linewidth', edgewidth);
    rectangle('Position', Fl_ROI, 'EdgeColor', 'w', 'Curvature', [0 0], 'Tag', 'ROI confine','Linewidth', 1, 'LineStyle', ':');
    uistack(glovar.ROI(ROInum+1), 'top');
    glovar.ROItext(ROInum+1) = text(Fl_ROI(1)-2, Fl_ROI(2)-2, num2str(ROInum), 'color', 'white', 'Tag', ['ROI', num2str(ROInum), ' Text'], 'ButtonDownFcn', @DeleteROI, 'FontSize', textsize);
    
    if twochannels == 1;
        axes(axes2)
        glovar.ROIred(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', 'red', 'Curvature', [1 1], 'Tag', ['ROIred', num2str(ROInum)],'ButtonDownFcn', {@DragROI, ROInum, 'ZoomWindow'});
        glovar.ROIredtext(ROInum+1) = text(Fl_ROI(1), Fl_ROI(2), num2str(ROInum), 'color', 'white', 'Tag', ['ROIred', num2str(ROInum), ' Text'],'ButtonDownFcn', 'Ca_deleteROI');
    else
    end
elseif ~strcmpi(Router, 'FineSelect') && ROInum ==0 %%% When drawing the background ROI (ROI 0), you also want to be able to change the size, so also use "DragROI"
    axes(axes1)
    delete(findobj('Tag', 'ROI confine'));
    delete(findobj('Tag', 'ROI0'));
    delete(findobj('Tag', 'ROI0 Text'));
    glovar.ROI(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', linecolor, 'Curvature', [1 1], 'Tag', ['ROI', num2str(ROInum)], 'ButtonDownFcn', {@DragROI, ROInum, 'ZoomWindow'}, 'Linewidth', edgewidth);
    glovar.ROItext(ROInum+1) = text(Fl_ROI(1)-2, Fl_ROI(2)-2, num2str(ROInum), 'color', 'white', 'Tag', ['ROI', num2str(ROInum), ' Text'], 'ButtonDownFcn', @DeleteROI, 'FontSize', textsize);
    
    if twochannels == 1;
        axes(axes2)
        glovar.ROIred(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', 'red', 'Curvature', [1 1], 'Tag', ['ROIred', num2str(ROInum)],'ButtonDownFcn', {@DragROI, ROInum});
        glovar.ROIredtext(ROInum+1) = text(Fl_ROI(1)-2, Fl_ROI(2)-2, num2str(ROInum), 'color', 'white', 'Tag', ['ROIred', num2str(ROInum), ' Text'],'ButtonDownFcn', 'Ca_deleteROI');
    else
    end
else                    %%% When drawing the final ROI on the image, there is no longer a need to move it, and in fact it is problematic, so exclude the button down function 
    axes(axes1)
    glovar.ROI(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', linecolor, 'Curvature', [0 0], 'Tag', ['ROI', num2str(ROInum)], 'Linewidth', edgewidth);
    glovar.ROItext(ROInum+1) = text(Fl_ROI(1)-2, Fl_ROI(2)-2, num2str(ROInum), 'color', 'white', 'Tag', ['ROI', num2str(ROInum), ' Text'], 'ButtonDownFcn', 'DeleteROI', 'FontSize', textsize);
    
    if twochannels == 1;
        axes(axes2)
        glovar.ROIred(ROInum+1) = rectangle('Position', Fl_ROI, 'EdgeColor', 'red', 'Curvature', [1 1], 'Tag', ['ROIred', num2str(ROInum)]);
        glovar.ROIredtext(ROInum+1) = text(Fl_ROI(1)-2, Fl_ROI(2)-2, num2str(ROInum), 'color', 'white', 'Tag', ['ROIred', num2str(ROInum), ' Text'],'ButtonDownFcn', 'DeleteROI');
    else
    end
end

%%%%%%%%%
% Create temporary window for automatic zoom into ROI area
%%%%%%%%%

if strcmpi(Router, 'Background')
    set(glovar.figure.handles.BackgroundROI_ToggleButton, 'Value', 0)
elseif strcmpi(Router, 'Spine')
    set(glovar.figure.handles.SpineROI_ToggleButton, 'Value', 0)
    
    r = round([Fl_ROI(2), Fl_ROI(2), Fl_ROI(2)+Fl_ROI(4), Fl_ROI(2)+Fl_ROI(4)]); %%% ROI y values, to be used as row index for sub-image
    c = round([Fl_ROI(1), Fl_ROI(1)+Fl_ROI(3), Fl_ROI(1)+Fl_ROI(3), Fl_ROI(1)]);
    frame = str2num(get(gui_CaImageViewer.figure.handles.Frame_EditableText, 'String'));
    
    if ~glovar.NewSpineAnalysis
        im = gui_CaImageViewer.GCaMP_Image;
        im = cat(3, im{:});
        immax = max(im, [], 3);
    else
        immax = gui_CaImageViewer.ch1image;
    end
    
    if r(1)<0
        r(1) = 1;
    elseif r(1)>length(immax)
        r(1) = length(immax);
    end
    if r(3)<0
        r(3) = 1;
    elseif r(3)>length(immax)
        r(3) = length(immax);
    end
    if c(1)<0
        c(1) = 1;
    elseif c(1)>length(immax)
        c(1) = length(immax);
    end
    if c(2) <0
        c(2) = 1;
    elseif c(2)>length(immax)
        c(2) = length(immax);
    end
    
    
    figure('Name', 'Auto zoom window', 'WindowButtonDownFcn', {@DrawROI, ROInum, 'FineSelect'}, 'NumberTitle', 'off'); imagesc(immax(r(1):r(3), c(1):c(2))); colormap(cmap)
    title(['Fine outline of ROI ', num2str(ROInum)])
    set(gca, 'XTick', [], 'YTick', [])
    
    glovar.Spine_Number = ROInum;
    
    global sideline
    
elseif strcmpi(Router, 'Nearby')
    set(glovar.figure.handles.NearbySpine_ToggleButton, 'Value', 0)
elseif strcmpi(Router, 'FineSelect')
    
end


if ~isempty(regexp(running, 'CaImageViewer'))
    gui_CaImageViewer = glovar;
    set(gui_CaImageViewer.figure.handles.output, 'WindowButtonDownFcn', []);
elseif ~isempty(regexp(running, 'FluorescenceSuite'));
    gui_FluorescenceSuite = glovar;
    set(gui_FluorescenceSuite.figure.handles.output, 'WindowButtonDownFcn', []);
end

% waitforbuttonpress

% if ~strcmpi(Router, 'FineSelect')
%     for i = 1:ROInum+1
%         set(gui_CaImageViewer.ROI(i), 'ButtonDownFcn', {@DragROI, i-1})
%     end
% end


