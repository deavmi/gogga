module gogga.nu.core;

import dlog.nu.core;
import dlog.nu.basic;

import std.conv : to;

import dlog.utilities : flatten;
import std.array : join;

/** 
 * The gogga styles supported
 */
public enum GoggaMode
{
    /** 
     * TwoKTwenty3 is: `[<file>] (<module>:<lineNumber>) <message>`
     */
    TwoKTwenty3,

    /** 
     * Simple mode is just: `[<LEVEL>] <message>`
     */
    SIMPLE,

    /** 
     * Rustacean mode is: `[<LEVEL>] (<filePath>/<functionName>:<lineNumber>) <message>`
     */
    RUSTACEAN,

    /** 
     * Simple rustacean mode is: `[<LEVEL>] (<functionName>:<lineNumber>) <message>`
     */
    RUSTACEAN_SIMPLE
}

/**
 * Information obtained during compilation time (if any)
 */
private struct GoggaCompInfo
{
    /**
     * compile time usage file
     */
    public string fullFilePath;

    /** 
     * compile time usage file (relative)
     */
    public string file;

    /** 
     * compile time usage line number
     */
    public ulong line;

    /** 
     * compile time usage module
     */
    public string moduleName;

    /** 
     * compile time usage function
     */
    public string functionName;

    /**
     * compile time usage function (pretty)
     */
    public string prettyFunctionName;

    /** 
     * Constructs the compilation information with the provided
     * parameters
     *
     * Params:
     *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
     */
    this(string fullFilePath, string file, ulong line, string moduleName, string functionName, string prettyFunctionName)
    {
        this.fullFilePath = fullFilePath;
        this.file = file;
        this.line = line;
        this.moduleName = moduleName;
        this.functionName = functionName;
        this.prettyFunctionName = prettyFunctionName;
    }

    /** 
     * Flattens the known compile-time information into a string array
     *
     * Returns: a string[]
     */
    public string[] toArray()
    {
        return [fullFilePath, file, to!(string)(line), moduleName, functionName, prettyFunctionName];
    }
}

private class GoggaMessage : BasicMessage
{
    private GoggaCompInfo ctx;

    this(GoggaCompInfo context)
    {
        this.ctx = context;
    }

    public GoggaCompInfo getContext()
    {
        return this.ctx;
    }
}

private class GoggaTransform2 : Transform
{
    private GoggaMode mode;
    this()
    {
        // this.mode = mode;
    }

    public void setMode(GoggaMode mode)
    {
        this.mode = mode;
    }

    public Message transform(Message message)
    {
        // Only handle GoggaMessage(s)
        GoggaMessage goggaMesg = cast(GoggaMessage)message;
        if(goggaMesg is null)
        {
            return null;
        }

        /* The generated output string */
        string finalOutput;



        /* Extract the Level */
        Level level = goggaMesg.getLevel();

        /* Extract the text */
        string text = goggaMesg.getText();

        /* get the context data */
        string[] context = goggaMesg.getContext().toArray();


        /** 
         * Simple mode is just: `[<LEVEL>] <message>`
         */
        if(this.mode == GoggaMode.SIMPLE)
        {
            finalOutput = cast(string)debugColor("["~to!(string)(level)~"] ", level);

            finalOutput ~= text~"\n";
        }
        /** 
         * TwoKTwenty3 is: `[<file>] (<module>:<lineNumber>) <message>`
         */
        else if(this.mode == GoggaMode.TwoKTwenty3)
        {
            /* Module information (and status debugColoring) */
            string moduleInfo = cast(string)debugColor("["~context[1]~"]", level);
            
            /* Function and line number info */
            string funcInfo = cast(string)(colorSrc("("~context[4]~":"~context[2]~")"));

            finalOutput =  moduleInfo~" "~funcInfo~" "~text~"\n";
        }
        /** 
         * Rustacean mode is: `[<LEVEL>] (<filePath>/<functionName>:<lineNumber>) <message>`
         */
        else if(this.mode == GoggaMode.RUSTACEAN)
        {
            finalOutput = cast(string)debugColor(to!(string)(level)~"\t", level);
            finalOutput ~= cast(string)(colorSrc(context[1]~"/"~context[4]~":"~context[2]~"  "));
            finalOutput ~= text~"\n";
        }
        /** 
         * Simple rustacean mode is: `[<LEVEL>] (<functionName>:<lineNumber>) <message>`
         */
        else if(this.mode == GoggaMode.RUSTACEAN_SIMPLE)
        {
            finalOutput = cast(string)debugColor(to!(string)(level)~"\t", level);
            finalOutput ~= cast(string)(colorSrc(context[4]~":"~context[2]~"  "));
            finalOutput ~= text~"\n";
        }

        goggaMesg.setText(finalOutput);
        return message;
    }
}

public class GoggaLogger2 : BasicLogger
{
    private GoggaTransform2 gogTrans;

    /** 
	 * Whether debug prints are enabled or not
	 */
    private bool debugEnabled = false;

    this()
    {
        super();
        this.gogTrans = new GoggaTransform2();
        addTransform(this.gogTrans);
    }

    public void mode(GoggaMode mode)
    {
        this.gogTrans.setMode(mode);
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
	public void error(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Build up the line information */
		GoggaCompInfo compilationInfo = GoggaCompInfo(c1, c2, c3, c4, c5, c6);


        GoggaMessage message = new GoggaMessage(compilationInfo);

        message.setLevel(Level.ERROR);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, " ");

        message.setText(messageOut);

		log(message);
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
	public void info(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Build up the line information */
		GoggaCompInfo compilationInfo = GoggaCompInfo(c1, c2, c3, c4, c5, c6);


        GoggaMessage message = new GoggaMessage(compilationInfo);

        message.setLevel(Level.INFO);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, " ");

        message.setText(messageOut);

		log(message);
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
	public void warn(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Build up the line information */
		GoggaCompInfo compilationInfo = GoggaCompInfo(c1, c2, c3, c4, c5, c6);


        GoggaMessage message = new GoggaMessage(compilationInfo);

        message.setLevel(Level.WARNING);

		/**
		 * Grab at compile-time all arguments and generate runtime code to add them to `components`
		 */		
		string[] components = flatten(segments);

		/* Join all `components` into a single string */
		string messageOut = join(components, " ");

        message.setText(messageOut);

		log(message);
	}

	/** 
	 * Logs using the default context an arbitrary amount of arguments
	 * specifically setting the context's level to DEBUG and will
	 * only print if debugging is enabled
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
	public void debug_(TextType...)(TextType segments,
									string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Only debug if debugging is enabled */
		if(debugEnabled)
		{
			/* Build up the line information */
            GoggaCompInfo compilationInfo = GoggaCompInfo(c1, c2, c3, c4, c5, c6);


            GoggaMessage message = new GoggaMessage(compilationInfo);

            message.setLevel(Level.DEBUG);

            /**
            * Grab at compile-time all arguments and generate runtime code to add them to `components`
            */		
            string[] components = flatten(segments);

            /* Join all `components` into a single string */
            string messageOut = join(components, " ");

            message.setText(messageOut);

            log(message);
		}
	}

    /** 
	 * Alias for debug_
	 */
	public alias dbg = debug_;

	/** 
	 * Enables debug prints
	 */
    public void enableDebug()
    {
        this.debugEnabled = true;
	}

	/** 
	 * Disables debug prints
	 */
    public void disableDebug()
    {
        this.debugEnabled = false;
    }
}

/** 
 * Colorise the text provided accoridng to the level and then
 * reset the colors at the end
 *
 * Params:
 *   text = the text to colorise
 *   level = the color to use
 * Returns: the byte sequence of characters and controls
 */
private byte[] debugColor(string text, Level level)
{
    /* The generated message */
    byte[] messageBytes;

    /* If INFO, set green */
    if(level == Level.INFO)
    {
        messageBytes = cast(byte[])[27, '[','3','2','m'];
    }
    /* If WARN, set yellow */
    else if(level == Level.WARNING)
    {
        messageBytes = cast(byte[])[27, '[','3','1', ';', '9', '3', 'm'];
    }
    /* If ERROR, set red */
    else if(level == Level.ERROR)
    {
        messageBytes = cast(byte[])[27, '[','3','1','m'];
    }
    /* If DEBUG, set pink */
    else
    {
        messageBytes = cast(byte[])[27, '[','3','5','m'];
    }

    /* Add the message */
    messageBytes ~= cast(byte[])text;

    /* Switch back debugColor */
    messageBytes ~= cast(byte[])[27, '[', '3', '9', 'm'];

    /* Reset coloring */
    messageBytes ~= [27, '[', 'm'];

    return messageBytes;
}

/** 
 * Colors the provided text in a gray fashion and then
 * resets back to normal
 *
 * Params:
 *   text = the text to gray color
 * Returns: the byte sequence of characters and controls
 */
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
    GoggaLogger2 logger = new GoggaLogger2();
}

version(unittest)
{
	import std.stdio : writeln, stdout;
}

unittest
{
    GoggaLogger2 gLogger = new GoggaLogger2();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

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
    GoggaLogger2 gLogger = new GoggaLogger2();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

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
    GoggaLogger2 gLogger = new GoggaLogger2();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

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
    GoggaLogger2 gLogger = new GoggaLogger2();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

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

unittest
{
    GoggaLogger2 gLogger = new GoggaLogger2();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

	gLogger.mode(GoggaMode.RUSTACEAN_SIMPLE);

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