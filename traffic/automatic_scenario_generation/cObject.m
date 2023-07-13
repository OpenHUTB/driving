classdef cObject<cActor





    properties(Access=public,Hidden=true)
    end
    methods(Access=public,Hidden=true)
        function obj=cObject(actor,index)

            obj@cActor(actor,index);
            if(actor.Type=='Pole')
                obj.Type=cObjectType('Pole');
            elseif(actor.Type=='Tree')
                obj.Type=cObjectType('Tree');
            elseif(actor.Type=='Building')
                obj.Type=cObjectType('Building');
            elseif(actor.Type=='GuardRails')
                obj.Type=cObjectType('GuardRails');
            elseif(actor.Type=='Signs')
                obj.Type=cObjectType('Signs');
            else
                obj.Type=cObjectType('Unknown');
            end
        end
    end
end

