function [data]=batch_read(pth,varargin)
addpath(genpath('C:\Program Files\DoseOptics\C-Dose Research\src\application\matlab'));
% pth=Input the Cdose directory. 
% Returns a structure with all the Image acquistions and important meta
% information about the images.
% If two cameras were used simultaneously, the function will return both of
% the images in different struct variables (Image_1 and Image_2). 

% Input 2: Specify if you want to sum or average the image stack or
% just want to leave it alone. 




% 'Sum'= The image stack is summed across the third dimension.
% 'Mean'=The iamge stack is averaged across the third dimension.
% 'None'= Leave the stack as it is. This will take up a lot of memory
%  Note that this function is only going to check folders in directory you
%  specified. If you have other folders in your directory this function
%  does have a check for that but it's not too robust. Do check your struct
%  if you any folders you want to remove.





% Updated Ramish Ashraf 2/22/2020
nargs=length(varargin);
total=nargs+nargin;


if total<2
    
    error('Not enough inputs. Please specify if you want to sum/average or the leave the stack as it is.');
end
validnames = {'Sum', 'Mean', 'None'};
flag=0;
%% Reading in Data
tic;

folders = dir(pth);
folders=folders(~ismember({folders.name},{'.','..','.git'}));  % Removing useless entries (. and .. fil;  % Removing useless entries (. and .. file);
folders=folders(~cellfun(@(x) x==0, {folders.isdir}));   % Ignoring files i.e isdir=1 only for folders (only keeping Folders)

dum=[];
% Removing Empty Folders ( i.e acquisitions that are deleted but the folder is still there although it is empty)
k=0;
for i=1:numel(folders)         % Need to vectorize this later.
    if(numel(dir(fullfile(pth,folders(i).name)))<=2)
        k=k+1;
        dum(k)=i;
    end
    
end

if dum~=0
    disp('empty folder(s) found. Deleting them');
    folders(dum(1,:))=[];
end

if dum==0
    disp('no empty folder found');
end

indx=0;
for i=1:numel(folders)
    if startsWith(folders(i).name,'2')  % Checking if folder is a cdose acquistion ( should start with the year i.e 2020) % need to put in a more robust solution for this
        indx=indx+1;
        data(indx).path=fullfile(pth,folders(i).name);
        settings=ini2struct(fullfile(pth,folders(i).name,'settings.ini')); % Reading settings file to get the Acquisition name
        data(indx).Name=settings.general.description;
        X = [' Reading ',   data(indx).Name];
        disp(X);
        data(indx).Exposure=settings.general.exposuretime;
        data(indx).AnalogGain=settings.general.analoggain;
        temp=read_dovi(fullfile(pth,folders(i).name,'meas_s0_cam0.dovi')); % Reading in Image File
        data(indx).NumFrames=size(temp,3); 
        data(indx).TimeStamp=load(fullfile(pth,folders(i).name,'time_s0_cam0.txt'));

        
        % Checks if two cameras were used and saves the two acquistions in
        % structs Image_1 and Image_2
        if isfile(fullfile(pth,folders(i).name,'meas_s0_cam1.dovi'))
            flag=1;
            temp2=read_dovi(fullfile(pth,folders(i).name,'meas_s0_cam1.dovi'));   
            data(indx).NumFrames_2=size(temp2,3); 
            data(indx).TimeStamp_2=load(fullfile(pth,folders(i).name,'time_s0_cam1.txt'));

        end
        
        
        
        if strcmp(varargin{1},validnames{1})       %sum
            
            data(indx).Image_1=sum(temp,3);
            if flag==1
                data(indx).Image_2=sum(temp2,3);
            end
        end
        if strcmp(varargin{1},validnames{2})  %mean
            
            data(indx).Image_1=mean(temp,3);
            if flag==1
                data(indx).Image_2=mean(temp2,3);
            end
        end
        
        if strcmp(varargin{1},validnames{3})  %none
            
            data(indx).Image_1=temp;
            if flag==1
                data(indx).Image_2=temp2;
            end
        end
        
    end
 X = [num2str(num2str(100*i/numel(folders))),'% done'];
    disp(X)
end
toc;
X=['All ', num2str(size(data,2)),' files read '];
disp(X)

end

