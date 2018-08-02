
function OverlapRecovery()
    filename = 'input.csv'
    M = csvread(filename)
    disp(size(M,1))
    for (i=1:size(M,1))
        disp('working...')
        groupNum = M(i,1)
        groupName = 'G_'+string(groupNum)
        if (groupNum < 10)
           groupName = 'G_0'+string(groupNum)
        end
        disp(groupName)
        vid1Start = M(i,2)
        vid2Start = M(i,3)
        task1 = M(i,4)
        task1Dur = M(i,5)
        task2 = M(i,6)
        task2Dur = M(i,7)
        task3 = M(i,8)
        task3Dur = M(i,9)
        
        path1 = 'D:\MainStudyParticipants\'+groupName+'\P_01\'+string(vid1Start)+'.mp4'
        path2 = 'D:\MainStudyParticipants\'+groupName+'\P_02\'+string(vid2Start)+'.mp4'
        %task one vids
        CompareVideos(groupName, path1, vid1Start, path2, vid2Start,task1,task1Dur)
        %task two vids
        CompareVideos(groupName, path1, vid1Start, path2, vid2Start,task2,task2Dur)
        %task three vids
        CompareVideos(groupName, path1, vid1Start, path2, vid2Start,task3,task3Dur)
        disp('done with group: '+groupName)
    end
end