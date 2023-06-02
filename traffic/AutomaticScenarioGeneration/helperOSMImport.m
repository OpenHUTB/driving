function scenario = helperOSMImport(bbox)
% helperOSMImport imports road network of MCity test facility from
%   OpenStreetMap.
%   Using the specified bounding box coordinates, the function downloads
%   data from OpenStreetMap and returns a drivingScenario object, which
%   contains the road network of MCity test facility.
%
% Copyright 2022 The MathWorks, Inc.

% Sync the geometric bounding box coordinates origin with Mcity map origin
originLat = 42.299847;
originLon = -83.698854;

% Bounding box latitude and longitude limits
minLat =  bbox(1,1);
maxLat =  bbox(1,2);
minLon = bbox(2,1);
maxLon = bbox(2,2);

% Fetch the OpenStreetMap XML
url = ['https://api.openstreetmap.org/api/0.6/map?bbox=' ...
    num2str(minLon, '%.10f') ',' num2str(minLat, '%.10f') ',' ...
    num2str(maxLon, '%.10f') ',' num2str(maxLat, '%.10f')];
fileName = websave("drive_map.osm", url,weboptions("ContentType", "xml"));

% Create a driving scenario
importedScenario = drivingScenario;
% Import the OpenStreetMap Roadnetwork
roadNetwork(importedScenario, "OpenStreetMap", fileName);

% Transform centroid of Bounding box into local Cartesian Coordinates
[tX,tY,tZ] = latlon2local(originLat, originLon,...
    0, importedScenario.GeoReference);
% Transformatation matrix
tf = [tX,tY,tZ];

% Map the fetched scenario into a new scenario with Shifted RoadCenters as
% per the Bounding Box Centroid
scenario = drivingScenario;
roadInfo = variantgenerator.internal.getRoadInfoFromScenario(importedScenario);

% Preprocessing for MCity specific scenario
if(minLon < originLon || maxLon > originLon || ...
        minLon < originLat || maxLat > originLat)

    for index = 1 : size(roadInfo, 2)
        rn = roadInfo(index).RoadName;

        % Translateing Road Centers or map to desired origin
        roadCenters = roadInfo(index).RoadCenters - tf;

        % Changing Roundabout to single lane
        if(rn == "453870095" || rn == "453870101")
            ls = lanespec(1); % Single Lane
        else

            % Skipping "Access drive" road from Mcity map
            if(rn == "Access Drive")
                continue
            end
            % Same lane specificatation for OSM
            ls = roadInfo(index).LaneSpecification;
        end

        % Create roads with the Name and the Lane Specification
        road(scenario, roadCenters, "Lanes", ls , "Name", rn);
    end
end
scenario.VerticalAxis = "Y";
end