module gogga.core;

import dlog;
import dlog.utilities : flatten;
import std.array : join;

import gogga.transform;
import gogga.context;

version(unittest)
{
	import std.stdio : writeln;
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();

	// Test the normal modes
    gLogger.info("This is an info message");
    gLogger.warn("This is a warning message");
    gLogger.error("This is an error message");

	// We shouldn't see anything as debug is off
	gLogger.dbg("This is a debug which is hidden", 1);

	// Now enable debugging and you should see it
	gLogger.enableDebug();
	gLogger.dbg("This is a VISIBLE debug", true);

    // Make space between unit tests
	writeln();
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();
	gLogger.mode(GoggaMode.TwoKTwenty3);

    // Test the normal modes
    gLogger.info("This is an info message");
    gLogger.warn("This is a warning message");
    gLogger.error("This is an error message");

	// We shouldn't see anything as debug is off
	gLogger.dbg("This is a debug which is hidden", 1);

	// Now enable debugging and you should see it
	gLogger.enableDebug();
	gLogger.dbg("This is a VISIBLE debug", true);

    // Make space between unit tests
	writeln();
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();
	gLogger.mode(GoggaMode.SIMPLE);

    // Test the normal modes
    gLogger.info("This is an info message");
    gLogger.warn("This is a warning message");
    gLogger.error("This is an error message");

	// We shouldn't see anything as debug is off
	gLogger.dbg("This is a debug which is hidden", 1);

	// Now enable debugging and you should see it
	gLogger.enableDebug();
	gLogger.dbg("This is a VISIBLE debug", true);

    // Make space between unit tests
	writeln();
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();
	gLogger.mode(GoggaMode.RUSTACEAN);

    // Test the normal modes
    gLogger.info("This is an info message");
    gLogger.warn("This is a warning message");
    gLogger.error("This is an error message");

	// We shouldn't see anything as debug is off
	gLogger.dbg("This is a debug which is hidden", 1);

	// Now enable debugging and you should see it
	gLogger.enableDebug();
	gLogger.dbg("This is a VISIBLE debug", true);

    // Make space between unit tests
	writeln();
}

public class GoggaLogger : Logger
{
	// The Gogga transformer
    private GoggaTransform gTransform = new GoggaTransform();

	// Whether debug is enabled
    private bool debugEnabled = false;

    this()
    {
        super(gTransform);
    }
    
    public override void logImpl(string text)
    {
        import std.stdio : write;
        write(text);
    }

	public void mode(GoggaMode mode)
	{
		gTransform.setMode(mode);
	}

    /** 
	 * Logs using the default context an arbitrary amount of arguments
	 * specifically setting the context's level to ERROR
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
	 */
	public final void error(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Use the context `GoggaContext` */
		GoggaContext defaultContext = new GoggaContext();

		/* Build up the line information */
		CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

		/* Set the line information in the context */
		defaultContext.setLineInfo(compilationInfo);

		/* Set the level to ERROR */
		defaultContext.setLevel(Level.ERROR);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, multiArgJoiner);

		/* Call the log */
		logc(defaultContext, messageOut, c1, c2, c3, c4, c5, c6);
	}

	/** 
	 * Logs using the default context an arbitrary amount of arguments
	 * specifically setting the context's level to INFO
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
	 */
	public final void info(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Use the context `GoggaContext` */
		GoggaContext defaultContext = new GoggaContext();

		/* Build up the line information */
		CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

		/* Set the line information in the context */
		defaultContext.setLineInfo(compilationInfo);

		/* Set the level to INFO */
		defaultContext.setLevel(Level.INFO);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, multiArgJoiner);

		/* Call the log */
		logc(defaultContext, messageOut, c1, c2, c3, c4, c5, c6);
	}

	/** 
	 * Logs using the default context an arbitrary amount of arguments
	 * specifically setting the context's level to WARN
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
	 */
	public final void warn(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Use the context `GoggaContext` */
		GoggaContext defaultContext = new GoggaContext();

		/* Build up the line information */
		CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

		/* Set the line information in the context */
		defaultContext.setLineInfo(compilationInfo);

		/* Set the level to WARN */
		defaultContext.setLevel(Level.WARN);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, multiArgJoiner);

		/* Call the log */
		logc(defaultContext, messageOut, c1, c2, c3, c4, c5, c6);
	}

	/** 
	 * Logs using the default context an arbitrary amount of arguments
	 * specifically setting the context's level to DEBUG
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
	 */
	public final void debug_(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Only debug if debugging is enabled */
		if(debugEnabled)
		{
			/* Use the context `GoggaContext` */
			GoggaContext defaultContext = new GoggaContext();

			/* Build up the line information */
			CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

			/* Set the line information in the context */
			defaultContext.setLineInfo(compilationInfo);

			/* Set the level to DEBUG */
			defaultContext.setLevel(Level.DEBUG);

			/**
			* Grab at compile-time all arguments and generate runtime code to add them to `components`
			*/		
			string[] components = flatten(segments);

			/* Join all `components` into a single string */
			string messageOut = join(components, multiArgJoiner);

			/* Call the log */
			logc(defaultContext, messageOut, c1, c2, c3, c4, c5, c6);
		}
	}

	/* You can also call using `dbg` */
	public alias dbg = debug_;

    // Any calls to debugPrint will actually occur
    public void enableDebug()
    {
        this.debugEnabled = true;
    }

    // Any calls to debugPrint will not occur
    public void disableDebug()
    {
        this.debugEnabled = false;
    }
}