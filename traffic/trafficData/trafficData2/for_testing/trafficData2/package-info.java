/**
 * 
 * <p>
 * This package was created using MATLAB Compiler SDK. The classes included in this 
 * package are wrappers around MATLAB functions that were used to compile this 
 * package. These classes have public methods that provide access to the 
 * MATLAB functions used by MATLAB Compiler SDK during compilation.
 * </p>
 * <h3><b>IMPORTANT: </b>What you need to use this package successfully:</h3>
 * <h3>MATLAB Runtime</h3>
 *
 * <ul>
 * <li>MATLAB Runtime is the collection of platform specific native libraries required to execute MATLAB functions exported by the classes of this package.</li>
 * <li>It can be made available either by installing MATLAB, MATLAB Compiler and MATLAB Compiler SDK, or by running the MCRInstaller executable.</li>
 * <li>This package is compatible with MATLAB Runtime version 9.13 only.</li>
 * <li>Please contact the creator of this package for specific details about the MATLAB Runtime (such as the MATLAB version with which it originated, since the MATLAB Runtime version is tied to the MATLAB version).</li>
 * </ul> 
 *
 * <p>
 * <b>NOTE: </b>Creating the first instance of one of the classes from this package is more time
 * consuming than creating subsequent instances, since the native libraries from the MATLAB Runtime
 * must be loaded.
 * </p>
 * <h3>javabuilder.jar</h3> 
 *
 * <ul>
 * <li>Provides classes that act as the bridge between your application and the MATLAB Runtime</li>
 * <li>Located in the $MCR/toolbox/javabuilder/jar directory (where $MCR is the root of an installation of either MATLAB or MATLAB Runtime)</li>
 * <li>The <code>trafficData2</code> package will only work with the javabuilder.jar file included with MATLAB Runtime version 9.13</li>
 * </ul>
 *
 * <p>
 * <b>NOTE: </b><code>com.mathworks.toolbox.javabuilder.MWArray</code> is one of many data 
 * conversion classes provided in javabuilder.jar. MWArray is an abstract class representing a 
 * MATLAB array. Each MATLAB array type has a corresponding concrete class type in the 
 * MWArray class hierarchy. The public methods that represent MATLAB functions, for the classes 
 * in the <code>trafficData2</code> package, can take instances of these concrete classes as 
 * input. These methods can also take native Java primitive or array types as input. These native 
 * types are converted to the appropriate MWArray types. For instance, a Java primitive double is 
 * converted into an instance of MWNumericArray (a subclass of MWArray).
 * </p> 
 */
package trafficData2;
