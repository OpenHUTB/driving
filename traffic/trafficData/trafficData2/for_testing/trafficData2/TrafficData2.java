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
import java.util.*;
import java.io.Serializable;

/**
 * The <code>TrafficData2</code> class provides a Java interface to MATLAB functions. 
 * The interface is compiled from the following files:
 * <pre>
 *  C:\\Users\\86130\\OneDrive\\文档\\MATLAB\\Examples\\R2022b\\driving\\AutomatedScenarioGenerationExample\\trafficData2.m
 * </pre>
 * The {@link #dispose} method <b>must</b> be called on a <code>TrafficData2</code> 
 * instance when it is no longer needed to ensure that native resources allocated by this 
 * class are properly freed.
 * @version 0.0
 */
public class TrafficData2 extends MWComponentInstance<TrafficData2> implements Serializable
{
    /**
     * Tracks all instances of this class to ensure their dispose method is
     * called on shutdown.
     */
    private static final Set<Disposable> sInstances = new HashSet<Disposable>();

    /**
     * Maintains information used in calling the <code>trafficData2</code> MATLAB 
     *function.
     */
    private static final MWFunctionSignature sTrafficData2Signature =
        new MWFunctionSignature(/* max outputs = */ 2,
                                /* has varargout = */ false,
                                /* function name = */ "trafficData2",
                                /* max inputs = */ 3,
                                /* has varargin = */ false);

    /**
     * Shared initialization implementation - private
     * @throws MWException An error has occurred during the function call.
     */
    private TrafficData2 (final MWMCR mcr) throws MWException
    {
        super(mcr);
        // add this to sInstances
        synchronized(TrafficData2.class) {
            sInstances.add(this);
        }
    }

    /**
     * Constructs a new instance of the <code>TrafficData2</code> class.
     * @throws MWException An error has occurred during the function call.
     */
    public TrafficData2() throws MWException
    {
        this(TrafficData2MCRFactory.newInstance());
    }
    
    private static MWComponentOptions getPathToComponentOptions(String path)
    {
        MWComponentOptions options = new MWComponentOptions(new MWCtfExtractLocation(path),
                                                            new MWCtfDirectorySource(path));
        return options;
    }
    
    /**
     * @deprecated Please use the constructor {@link #TrafficData2(MWComponentOptions componentOptions)}.
     * The <code>com.mathworks.toolbox.javabuilder.MWComponentOptions</code> class provides an API to set the
     * path to the component.
     * @param pathToComponent Path to component directory.
     * @throws MWException An error has occurred during the function call.
     */
    @Deprecated
    public TrafficData2(String pathToComponent) throws MWException
    {
        this(TrafficData2MCRFactory.newInstance(getPathToComponentOptions(pathToComponent)));
    }
    
    /**
     * Constructs a new instance of the <code>TrafficData2</code> class. Use this 
     * constructor to specify the options required to instantiate this component.  The 
     * options will be specific to the instance of this component being created.
     * @param componentOptions Options specific to the component.
     * @throws MWException An error has occurred during the function call.
     */
    public TrafficData2(MWComponentOptions componentOptions) throws MWException
    {
        this(TrafficData2MCRFactory.newInstance(componentOptions));
    }
    
    /** Frees native resources associated with this object */
    public void dispose()
    {
        try {
            super.dispose();
        } finally {
            synchronized(TrafficData2.class) {
                sInstances.remove(this);
            }
        }
    }
    
    /**
     * Calls dispose method for each outstanding instance of this class.
     */
    public static void disposeAllInstances()
    {
        synchronized(TrafficData2.class) {
            for (Disposable i : sInstances) i.dispose();
            sInstances.clear();
        }
    }

    /**
     * Provides the interface for calling the <code>trafficData2</code> MATLAB function 
     * where the first argument, an instance of List, receives the output of the MATLAB function and
     * the second argument, also an instance of List, provides the input to the MATLAB function.
     * <p>
     * Description as provided by the author of the MATLAB function:
     * </p>
     * <pre>
     * {@literal
	 * % 打开现有方案
	 * }
     * </pre>
     * @param lhs List in which to return outputs. Number of outputs (nargout) is
     * determined by allocated size of this List. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs List containing inputs. Number of inputs (nargin) is determined
     * by the allocated size of this List. Input arguments may be passed as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or
     * as arrays of any supported Java type. Arguments passed as Java types are
     * converted to MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void trafficData2(List lhs, List rhs) throws MWException
    {
        fMCR.invoke(lhs, rhs, sTrafficData2Signature);
    }

    /**
     * Provides the interface for calling the <code>trafficData2</code> MATLAB function 
     * where the first argument, an Object array, receives the output of the MATLAB function and
     * the second argument, also an Object array, provides the input to the MATLAB function.
     * <p>
     * Description as provided by the author of the MATLAB function:
     * </p>
     * <pre>
     * {@literal
	 * % 打开现有方案
	 * }
	 * </pre>
     * @param lhs array in which to return outputs. Number of outputs (nargout)
     * is determined by allocated size of this array. Outputs are returned as
     * sub-classes of <code>com.mathworks.toolbox.javabuilder.MWArray</code>.
     * Each output array should be freed by calling its <code>dispose()</code>
     * method.
     *
     * @param rhs array containing inputs. Number of inputs (nargin) is
     * determined by the allocated size of this array. Input arguments may be
     * passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     * @throws MWException An error has occurred during the function call.
     */
    public void trafficData2(Object[] lhs, Object[] rhs) throws MWException
    {
        fMCR.invoke(Arrays.asList(lhs), Arrays.asList(rhs), sTrafficData2Signature);
    }

    /**
     * Provides the standard interface for calling the <code>trafficData2</code> MATLAB function with 
     * 3 comma-separated input arguments.
     * Input arguments may be passed as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>, or as arrays of
     * any supported Java type. Arguments passed as Java types are converted to
     * MATLAB arrays according to default conversion rules.
     *
     * <p>
     * Description as provided by the author of the MATLAB function:
     * </p>
     * <pre>
     * {@literal
	 * % 打开现有方案
	 * }
     * </pre>
     * @param nargout Number of outputs to return.
     * @param rhs The inputs to the MATLAB function.
     * @return Array of length nargout containing the function outputs. Outputs
     * are returned as sub-classes of
     * <code>com.mathworks.toolbox.javabuilder.MWArray</code>. Each output array
     * should be freed by calling its <code>dispose()</code> method.
     * @throws MWException An error has occurred during the function call.
     */
    public Object[] trafficData2(int nargout, Object... rhs) throws MWException
    {
        Object[] lhs = new Object[nargout];
        fMCR.invoke(Arrays.asList(lhs), 
                    MWMCR.getRhsCompat(rhs, sTrafficData2Signature), 
                    sTrafficData2Signature);
        return lhs;
    }
}
