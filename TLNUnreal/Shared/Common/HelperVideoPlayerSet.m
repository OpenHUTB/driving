%HelperVideoPlayerSet manage multiple video displays
%  HelperVideoPlayerSet is a helper class to help organize displays

% Copyright 2020-2021 The MathWorks, Inc.

classdef HelperVideoPlayerSet
    
    properties (SetAccess='private', GetAccess='public')
        Players;
    end
    
    methods
        %------------------------------------------------------------------
        % Constructor
        %------------------------------------------------------------------
        function this = HelperVideoPlayerSet(images, titles)

            % Validate inputs
            validateattributes(images, {'cell'}, {'row'});
            
            if nargin == 2
                validateattributes(titles, {'cell'}, {'row'});
                if(numel(images) ~= numel(titles))
                   error('Number of images must equal to number of display titles'); 
                end
            else
                titles=cell(1,numel(images));
            end

            % Set up players            
            sz = get(0, 'ScreenSize');

            screenMargin = [50, 10]; % [left, top]
                        
            sizes = cellfun(@size, images,'UniformOutput',false);
            sizes = cell2mat(sizes);
            
            maxHeightInSet = max(sizes(1:3:end));
            offset = maxHeightInSet + (sz(4)-maxHeightInSet)/2; % middle of screen for tallest window
            
            % sz(4) can be fractional; hence, the round is on the entire 'location' vector
            location = round([screenMargin(1), sz(4)-screenMargin(2)-offset]);
            
            for i=1:numel(images)
                                
                this.Players{i} = ...
                    vision.DeployableVideoPlayer('Location', location,...
                    'Name', [num2str(i), ': ', titles{i}]);
                
                % Set up next location; for simplicity, go right
                location = location + [10 + size(images{i}, 2), 0];
            end
            
        end        
    end

    methods (Access='public')
        
        %------------------------------------------------------------------
        function update(this, cellImages)
            
            for i=1:numel(cellImages)
                this.Players{i}.step(cellImages{i});
            end
           
        end
        
        %------------------------------------------------------------------
        function out = isOpen(this, idx)
            
            out = this.Players{idx}.isOpen();            
        end
    end
end
