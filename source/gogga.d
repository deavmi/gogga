module gogga;

import std.conv : to;
import std.stdio : write, stdout;

// TODO: Remove (just for testing)
import std.stdio : writeln;

import dlog;

public enum DebugType
{
    INFO,
    WARNING,
    ERROR
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();

    // gLogger.log("Bruh\n");
    gLogger.print("Bruh\n", DebugType.INFO);
    gLogger.enableDebug();
    gLogger.dbg("Bruh debug\n", DebugType.INFO);

    gLogger.disableDebug();
    gLogger.dbg("Bruh debug\n", DebugType.ERROR);
}

unittest
{   
    GoggaLogger gLogger = new GoggaLogger();
    alias debugTypes = __traits(allMembers, DebugType);
    static foreach(debugType; debugTypes)
    {
        gLogger.print("Hello world\n", mixin("DebugType."~debugType));
    }
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

    // public alias gprint = ginfo;
    // public alias gprintln = ginfoln;

    // public void ginfo(string message)
    // {
    //     log(message);
    // }

    // public void ginfoln(string message)
    // {
    //     ginfo(message~"\n");
    // }

    // TODO: Find out how to do a partial function using meta-programming in D
    // public alias error() = print()

    public void dbg(string message, DebugType debugType, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
    {
        if(debugEnabled)
        {
            print(message, debugType, c1, c2, c3, c4, c5, c6);
        }
    }

    public void print(string message, DebugType debugType, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
    {
        string[] contextExtras = [to!(string)(debugType)];
        log(message, c1, c2, c3, c4, c5, c6, contextExtras);
    }

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

    public override string transform(string text, string[] context)
    {
        /* Module information (and status debugColoring) */
		string moduleInfo = cast(string)debugColor("["~context[1]~"]", to!(DebugType)(context[6]));
		
        /* Function and line number info */
        string funcInfo = cast(string)(colorSrc("("~context[4]~":"~context[2]~")"));

        return moduleInfo~" "~funcInfo~" "~text;
    }
}

private byte[] debugColor(string text, DebugType debugType)
{
    /* The generated message */
    byte[] messageBytes;

    /* If INFO, set green */
    if(debugType == DebugType.INFO)
    {
        messageBytes = cast(byte[])[27, '[','3','2','m'];
    }
    /* If WARNING, set warning */
    else if(debugType == DebugType.WARNING)
    {
        messageBytes = cast(byte[])[27, '[','3','5','m']; /* TODO: FInd yllow */
    }
    /* If ERROR, set error */
    else if(debugType == DebugType.ERROR)
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