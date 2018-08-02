%params:
% path(1 || 2) : path of respective video
% startEpoch(1 || 2) : start epoch of the whole video (name of the file)
% startEpoch : the epoch that the scroll bar analysis will start at
% the duration in ms of the video portion being analyzed
function CompareVideos(gn, path1,startEpoch1, path2, startEpoch2, startEpoch, duration)
    barThreshold = 205;
    %scroll bar dims
    topY = 165;
    bottomY = 1028;
    x = 1909;
    height = bottomY - topY;
    button_heights = 25;
    screen_height = height + button_heights;%height of viewable space in document
    
    %initialize videos
    vid1 = VideoReader(path1);
    vid2 = VideoReader(path2);
    
    frameRatio = double(vid1.FrameRate) / double(vid2.FrameRate);
    
    %converting epoch and ms to frames
    startFrame1 = int32((startEpoch - startEpoch1)/1000 * vid1.FrameRate);
    startFrame2 = int32((startEpoch - startEpoch2)/1000 * vid2.FrameRate);
    frameDuration = int32((duration / 1000) * vid1.FrameRate);
    
    data = [];
    
    %loop through frames of video
    for(i=0:frameDuration)
        %Calculate offsets of documents due to scroll in P_01 then P_02
        frame1 = read(vid1,startFrame1+floor(double(i)*double(frameRatio)));
        grayframe1 = rgb2gray(frame1);
        bar1 = grayframe1(topY:bottomY,x:x);
        indices1 = find(bar1 < barThreshold);
        barSize1 = size(bar1(indices1));
        documentSize1 = screen_height / (barSize1(1) / height) ;
        try
            scrollOffset1 = indices1(1) / height; % this is a percentage offset
        catch
            continue
        end
        documentOffset1 = documentSize1 * scrollOffset1; % this is a pixel offset
        
        frame2 = read(vid2,startFrame2+i);
        grayframe2 = rgb2gray(frame2);
        bar2 = grayframe2(topY:bottomY,x:x);  
        indices2 = find(bar2 < barThreshold);
        barSize2 = size(bar2(indices2));
        documentSize2 = screen_height / (barSize2(1) / height) ;
        try
            scrollOffset2 = indices2(1) / height; % this is a percentage offset
        catch
            continue
        end
        documentOffset2 = documentSize2 * scrollOffset2; % this is a pixel offset

        %the difference of the scroll offsets for P_01 and P_02
        offset = documentOffset1 - documentOffset2;
        %the epoch at which this offset occurs
        epoch = (startEpoch + ((double(i) / vid1.FrameRate) * 1000));
        data = [data; [double(epoch), double(offset)]];
    end
    csvwrite('offsets_'+gn+'.csv',data);
% end

%'D:\MainStudyParticipants\G_02\P_02\G_02 P_02 Screen.mp4'
% 'D:\MainStudyParticipants\G_03\1530907527074.mp4'