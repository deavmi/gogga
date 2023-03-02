module gogga.transform;

import dlog;
import gogga.context;

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