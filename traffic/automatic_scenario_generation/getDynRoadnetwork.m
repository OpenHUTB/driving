function data=getDynRoadnetwork(scenarioName,blkHandle)







    modelH=[];
    try
        modelH=bdroot(blkHandle);
    catch E
    end
    try
        scenario=evalinGlobalScope(modelH,scenarioName);
    catch E


    end
    scenarioData=cScenario(scenario);
    data=scenarioData.RNStruct;
end
