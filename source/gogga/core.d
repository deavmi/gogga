module gogga.core;

import std.conv : to;
import std.stdio : write, stdout;

// TODO: Remove (just for testing)
import std.stdio : writeln;

import dlog;
import dlog.utilities : flatten;
import std.array : join;



unittest
{
    GoggaLogger gLogger = new GoggaLogger();

    // TODO: Somehow re-enable this please
    // gLogger.log("Bruh\n");
    gLogger.info("This is an info message");
    gLogger.warn("This is a warning message");
    gLogger.error("This is an error message");

    // TODO: Add debug stuff
}

public final class GoggaContext : Context
{
    // TODO: Put more advanced stuff here
}

public class GoggaLogger : Logger
{
    private GoggaTransform gTransform = new GoggaTransform();

    this()
    {
        super(gTransform);
    }
    
    public override void logImpl(string text)
    {
        import std.stdio : write;
        write(text);
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

	/* You can also call using `dbg` */
	public alias dbg = debug_;

    private bool debugEnabled = false;

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

public class GoggaTransform : MessageTransform
{
    private bool isSourceMode = false;

    public override string transform(string text, Context ctx)
    {
        /* Get the GoggaContext */
        GoggaContext gCtx = cast(GoggaContext)ctx;

        /* Extract the line information */
        CompilationInfo compInfo = gCtx.getLineInfo();
        string[] context = compInfo.toArray();

        /* Module information (and status debugColoring) */
		string moduleInfo = cast(string)debugColor("["~context[1]~"]", gCtx.getLevel());
		
        /* Function and line number info */
        string funcInfo = cast(string)(colorSrc("("~context[4]~":"~context[2]~")"));

        return moduleInfo~" "~funcInfo~" "~text~"\n";
    }
}

private byte[] debugColor(string text, Level level)
{
    /* The generated message */
    byte[] messageBytes;

    /* If INFO, set green */
    if(level == Level.INFO)
    {
        messageBytes = cast(byte[])[27, '[','3','2','m'];
    }
    /* If WARNING, set warning */
    else if(level == Level.WARN)
    {
        messageBytes = cast(byte[])[27, '[','3','5','m']; /* TODO: FInd yllow */
    }
    /* If ERROR, set error */
    else if(level == Level.ERROR)
    {
        messageBytes = cast(byte[])[27, '[','3','1','m'];
    }

    /* Add the message */
    messageBytes ~= cast(byte[])text;

    /* Switch back debugColor */
    messageBytes ~= cast(byte[])[27, '[', '3', '9', 'm'];

    return messageBytes;
}

private byte[] colorSrc(string text)
{
    /* The generated message */
    byte[] messageBytes;

    /* Reset coloring */
    messageBytes ~= [27, '[', 'm'];

    /* Color gray */
    messageBytes ~= [27, '[', '3', '9', ';', '2', 'm'];

    /* Append the message */
    messageBytes ~= text;

    /* Reset coloring */
    messageBytes ~= [27, '[', 'm'];

    return messageBytes;
}

unittest
{   
    // alias debugTypes = __traits(allMembers, DebugType);
    // static foreach(debugType; debugTypes)
    // {
    //     gprintln("Hello world", mixin("DebugType."~debugType));
    // }
}