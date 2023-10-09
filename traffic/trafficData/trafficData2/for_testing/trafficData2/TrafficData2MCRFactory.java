/*
 * MATLAB Compiler: 8.5 (R2022b)
 * Date: Sun Oct  8 16:33:22 2023
 * Arguments: 
 * "-B""macro_default""-W""java:trafficData2,TrafficData2""-T""link:lib""-d""D:\\新桌面\\trafficData\\trafficData2\\for_testing""class{TrafficData2:C:\\Users\\86130\\OneDrive\\文档\\MATLAB\\Examples\\R2022b\\driving\\AutomatedScenarioGenerationExample\\trafficData2.m}""-Z""Scenario 
 * Variant Generator for Automated Driving Toolbox"
 */

package trafficData2;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;
import java.io.Serializable;
/**
 * <i>INTERNAL USE ONLY</i>
 */
public class TrafficData2MCRFactory implements Serializable 
{
    /** Component's uuid */
    private static final String sComponentId = "trafficData2_bdfc4023-2b4b-413b-b619-49c23e90e1fd";
    
    /** Component name */
    private static final String sComponentName = "trafficData2";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(TrafficData2MCRFactory.class)
        );
    
    
    private TrafficData2MCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            TrafficData2MCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{9,13,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
