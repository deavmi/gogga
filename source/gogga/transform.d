module gogga.transform;

import dlog;
import gogga.context;
import std.conv : to;

// TODO: hehe easter egg TRADITIONAL, LIBERAL, UNHINGED
public enum GoggaMode
{
    TwoKTwenty3,
    SIMPLE,
    RUSTACEAN
}

public class GoggaTransform : MessageTransform
{
    private GoggaMode mode;

    public override string transform(string text, Context ctx)
    {
        /* The generated output string */
        string finalOutput;


        /* Get the GoggaContext */
        GoggaContext gCtx = cast(GoggaContext)ctx;

        /* Extract the line information */
        CompilationInfo compInfo = gCtx.getLineInfo();
        string[] context = compInfo.toArray();

        /* Extract the Level */
        Level level = gCtx.getLevel();

    
        // TODO: go for [<LEVEL>] (<filePath>/<functionName>:<lineNumber>) <message>

        /** 
         * Simple mode is just: `[<LEVEL>] <message>`
         */
        if(mode == GoggaMode.SIMPLE)
        {
            finalOutput = cast(string)debugColor("["~to!(string)(level)~"] "~text, level);
        }
        /** 
         * TwoKTwenty3 is: `[<file>] (<module>:<lineNumber>) <message>`
         */
        else if(mode == GoggaMode.TwoKTwenty3)
        {
            /* Module information (and status debugColoring) */
            string moduleInfo = cast(string)debugColor("["~context[1]~"]", level);
            
            /* Function and line number info */
            string funcInfo = cast(string)(colorSrc("("~context[4]~":"~context[2]~")"));

            finalOutput =  moduleInfo~" "~funcInfo~" "~text~"\n";
        }
        /** 
         * Rustacean mode
         */
        else
        {

        }

        return finalOutput;
    }

    public void setMode(GoggaMode mode)
    {
        this.mode = mode;
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

    /* Reset coloring */
    messageBytes ~= [27, '[', 'm'];

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