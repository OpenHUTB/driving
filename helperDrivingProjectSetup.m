function helperDrivingProjectSetup(projectArchivedName, nvp)
% 从目录
% This is a wrapper function around projectDemoSetUp that helps in
% extracting all the required projects (main and reference) from the zip
% files by using the name of the main project's zip file name to a working
% directory. "workDir" can be used to specify a working directory. The
% project should be in toolbox/driving/drivingdemos directory.
%
% projectArchivedName: The zip file name of the main project.

% Example 1:
% helperDrivingProjectSetup('FVSFTestBench.zip');
% Example 2:
% helperDrivingProjectSetup("FVSFTestBench.zip", "workDir","C:\Users\home\MATLAB\work");
% 
% Note: If the project is already opened, 'helperDrivingProjectSetup' will
% not fetch the new files again.
% 
% This is a helper function and may be changed or removed without notice.

%   Copyright 2020-2021 The MathWorks, Inc.

arguments
    projectArchivedName;
    nvp.workDir char = '';
end

% Get current root project info
proj = matlab.project.rootProject;

% Get project name from "projectArchivedName" excluding .zip extension
[~,projectName,~] = fileparts(projectArchivedName);

% Extract and open the project if it is not already opened.
if(isempty(proj) || proj.Name ~= projectName)
    % Extract the main and reference projects using projectDemoSetUp
    % [projectFolderPath,~] = matlab.internal.project.example.projectDemoSetUp(fullfile(matlabroot,'toolbox','driving','drivingdemos',projectArchivedName),nvp.workDir,'');

    % change the path to project folder path.
    projectFolderPath = projectName;
    cd(projectFolderPath);

    % open project.
    openProject(projectName);
    
    % change the directory path to the "workDir".
    if(~isempty(nvp.workDir))
        cd(nvp.workDir);
    end
end

end