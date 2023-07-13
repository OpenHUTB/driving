classdef cTrafficLight<cActor




    properties(Access=private,Hidden=true)

        Timings;
    end
    methods(Access=public,Hidden=true)
        function obj=cTrafficLight(actor,index)

            obj@cActor(actor,index);
            if(actor.Type=='Barrier')
                obj.Type=cObjectType('Barrier');
            else
                obj.Type=cObjectType('Unknown');
            end
        end

    end
end

