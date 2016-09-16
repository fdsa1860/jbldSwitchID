function data = parseData(dataPath, dataFile)

[~,~,ext] = fileparts(dataFile);
if strcmp(ext,'.mat')
    load(fullfile(dataPath, dataFile));
%     data = im2double(mydata);
elseif strcmp(ext, '.mov') || strcmp(ext, '.avi') || strcmp(ext, '.mp4')
    count = 1;
    vid = VideoReader(fullfile(dataPath, dataFile));
    estNumFrame = ceil(vid.Duration * vid.FrameRate);
    Temp = zeros(vid.Height, vid.Width);
    Temp = imresize(Temp, 0.25);
    data = zeros(numel(Temp), estNumFrame);
    while hasFrame(vid)
        fr = readFrame(vid);
%         if count >= 50 && count <= 100
%             imagesc(fr); title(sprintf('Frame %d',count));
%             pause;
%         end
        imwrite(fr,fullfile('..','expData','images',sprintf('Img_%d.jpg',count)));
        fr = rgb2gray(fr);
        fr = imresize(fr, 0.25);
        vecFr = im2double(fr);
        data(:,count) = vecFr(:);
        count = count + 1;
    end
    
    if count <= estNumFrame
        data(:,count:end) = [];
    end
end

end