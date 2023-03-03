/** 
 * The custom text transformer that implements the gogga-stylised
 * logging messages
 */
module gogga.transform;

import dlog;
import gogga.context;
import std.conv : to;

/** 
 * The gogga styles supported
 */
public enum GoggaMode
{
    TwoKTwenty3,
    SIMPLE,
    RUSTACEAN
}

/** 
 * The custom gogga text transformer
 */
public class GoggaTransform : MessageTransform
{
    /** 
     * Current style
     */
    private GoggaMode mode;

    /** 
     * Transforms the provided text
     *
     * Params:
     *   text = text to transform
     *   ctx = the context passed in
     * Returns: a string of transformed text
     */
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


        /** 
         * Simple mode is just: `[<LEVEL>] <message>`
         */
        if(mode == GoggaMode.SIMPLE)
        {
            finalOutput = cast(string)debugColor("["~to!(string)(level)~"] ", level);

            finalOutput ~= text~"\n";
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
         * Rustacean mode is: `[<LEVEL>] (<filePath>/<functionName>:<lineNumber>) <message>`
         */
        else
        {
            finalOutput = cast(string)debugColor(to!(string)(level)~"\t", level);
            finalOutput ~= cast(string)(colorSrc(context[1]~"/"~context[4]~":"~context[2]~"  "));
            finalOutput ~= text~"\n";
        }

        return finalOutput;
    }

    /** 
     * Set the gogga style
     *
     * Params:
     *   mode = the GoggaMode to use
     */
    public void setMode(GoggaMode mode)
    {
        this.mode = mode;
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