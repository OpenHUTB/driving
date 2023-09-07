function keyInject(windowName,sendString,returnWindow)

% Send key strokes to a named Window. Alt, Ctrl, Shift, Enter and Tab are
% all supported, allowing you to fully navigate the menu of other programs
% from within Matlab. If you simply wish to type into another program (as
% opposed to navigating a menu), see my other submission "textInject".
% 
% Example:
% Send some text to Notepad, save it with a specified file name using
% Notepad's menu, then return focus to Matlab:
% keyInject('Untitled - Notepad','Here is some text I would like to save','Untitled - Notepad')
% keyInject('Untitled - Notepad','ALT__FA','Untitled - Notepad')
% keyInject('Save As','this is the file name i want.txt\r','Matlab R2012b')
% 
% Supported keystrokes:
% alphanumeric (a-z,0-9), L Alt ('ALT__'), L Ctrl ('CTRL__'), L Shift
% ('SHIFT__'), Tab ('\t'), Enter ('\r'), Dash ('-') and Period ('.'). For
% capital letters you can hold shift (see below).
%
% Holding down Alt, Ctrl or Shift keys:
% Replace the second underscore character with a '+' to hold the key down,
% or a '-' to release it. For example to select all text in a window and
% copy it to the clipboard: 'CTRL_+AC' (followed by 'CTRL_-' to release).
% See the screenshot on the file exchange for an example of how to this in 
% action (selects text in Matlab and copy-pastes it into Notepad).
% 
% Adding new keys: This must be done manually, but it's easy if you copy
% the approach I've laid out below. You will need a 'Virtual Key Code':
% http://www.kbdedit.com/manual/low_level_vk_list.html
% The hex values there need to be converted to decimal:
% http://www.kbdedit.com/manual/low_level_vk_list.html
% You don't need to recompile the mex files to add new keys.
% 
% Mex files: You must compile the included C files to use this utility.
% Don't worry, it's really easy! Type mex -setup to choose your compiler.
% Then put the C files on the Matlab path and type: 
% mex 'keyInject_setFocus.cc'
% mex 'keyInject_sendKey.cc'

tabPositions = strfind(sendString,'\t');
returnPositions = strfind(sendString,'\r');

sendString = upper(sendString);

spacePositions = strfind(sendString,' ');
dashPositions = strfind(sendString,'-');
periodPositions = strfind(sendString,'.');

altPositions = strfind(sendString,'ALT_');
ctrlPositions = strfind(sendString,'CTRL_');
shiftPositions = strfind(sendString,'SHIFT_');

numberOfKeyStrokes = length(sendString) - length(altPositions)*4 - length(ctrlPositions)*5 - length(shiftPositions)*6 - ...
    length(tabPositions) - length(returnPositions);

% Set focus to the desired window

keyInject_setFocus(windowName);
nextPos = 1;
    
for ii = 1:numberOfKeyStrokes
    
    pressRelease = 0; % default is to both press and release

    if find(altPositions == nextPos)

        if strcmp(sendString(nextPos+4),'+')            
            pressRelease = 1; % Press the key down, but don't release
        elseif strcmp(sendString(nextPos+4),'-')
            pressRelease = -1; % Release the key
        elseif ~strcmp(sendString(nextPos+4),'_')
            fprintf('Error - press or release Alt key?\n'); break
        end
        
        sendKey = 164; % L Alt
        nextPos = nextPos + 5;

    elseif find(ctrlPositions == nextPos)

        if strcmp(sendString(nextPos+5),'+')            
            pressRelease = 1; % Press the key down, but don't release
        elseif strcmp(sendString(nextPos+5),'-')
            pressRelease = -1; % Release the key
        elseif ~strcmp(sendString(nextPos+5),'_')
            fprintf('Error - press or release Ctrl key?\n'); break
        end
        
        sendKey = 162; % L Ctrl
        nextPos = nextPos + 6;

    elseif find(shiftPositions == nextPos)
        
        if strcmp(sendString(nextPos+6),'+')            
            pressRelease = 1; % Press the key down, but don't release
        elseif strcmp(sendString(nextPos+6),'-')
            pressRelease = -1; % Release the key
        elseif ~strcmp(sendString(nextPos+6),'_')
            fprintf('Error - press or release Shift key?\n'); break
        end        

        sendKey = 166; % L Shift
        nextPos = nextPos + 7;
        
    elseif find(dashPositions == nextPos)
        
        sendKey = 189; % '-_' key
        nextPos = nextPos + 1;
        
    elseif find(spacePositions == nextPos)
        
        sendKey = 32; % Space key
        nextPos = nextPos + 1;

    elseif find(tabPositions == nextPos)
        
        sendKey = 9; % Tab key
        nextPos = nextPos + 2;
        
    elseif find(returnPositions == nextPos)
        
        sendKey = 13; % Carriage return (not a newline)
        nextPos = nextPos + 2;     
        
    elseif find(periodPositions == nextPos)
        
        sendKey = 190;
        nextPos = nextPos + 1; % Period (full-stop)
        
    else

        sendKey = double(sendString(nextPos));
        nextPos = nextPos + 1;
        
    end

    keyInject_sendKey(windowName,sendKey,pressRelease);

end

pause(0.1)

keyInject_setFocus(returnWindow);