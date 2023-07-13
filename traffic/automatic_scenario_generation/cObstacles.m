classdef cObstacles<cActor





    properties(Access=public,Hidden=true)
    end
    methods(Access=public,Hidden=true)
        function obj=cObstacles(actor,index)

            obj@cActor(actor,index);
            if(actor.Type=='Barrier')
                obj.Type=cObjectType('Barrier');
            else
                obj.Type=cObjectType('Unknown');
            end
        end
    end
end

