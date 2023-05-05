function varagout = helperSLCreateUtilityStruct(obj)

%helperSLCreateUtilityStruct create struct from object.

if isa(obj, 'vehicleDimensions')
    
    vehicleDimsStruct            = struct;
    vehicleDimsStruct            = helperSLMatchStructFields(vehicleDimsStruct, obj);
    vehicleDimsStruct.WorldUnits = uint8(vehicleDimsStruct.WorldUnits);
    varagout{1}                  = vehicleDimsStruct;
    
elseif isa(obj, 'vehicleCostmap')
    
    costmapStruct                   = struct;
    costmapStruct                   = helperSLMatchStructFields(costmapStruct, obj);
    costmapStruct                   = rmfield(costmapStruct, 'CollisionChecker');
    costmapStruct.InflationRadius   = obj.CollisionChecker.InflationRadius;
    costmapStruct.Costs             = getCosts(obj);
    
    vehicleDimsStruct               = struct;
    vehicleDimsStruct               = helperSLMatchStructFields(vehicleDimsStruct, obj.CollisionChecker.VehicleDimensions);
    vehicleDimsStruct.WorldUnits    = uint8(vehicleDimsStruct.WorldUnits);
    varagout{1}                     = vehicleDimsStruct;
    varagout{2}                     = costmapStruct;
    
else
    error('Invalid obj data type.');
end


