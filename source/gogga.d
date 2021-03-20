module gogga;

import std.conv : to;
import std.stdio : write, stdout;

public enum DebugType
{
    INFO,
    WARNING,
    ERROR
}

byte[] generateMessage(string message, DebugType debugType)
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

    /* Write the message type */
    messageBytes ~= "["~to!(string)(debugType)~"] ";

    /* Switch back color */
    messageBytes ~= cast(byte[])[27, '[', '3', '9', 'm'];

    return messageBytes;
}

void gprint(messageT)(messageT message, DebugType debugType = DebugType.INFO)
{
    /* Generate the message */
    byte[] messageBytes = generateMessage(message, debugType);

    /* Print the message */
    write(cast(string)messageBytes);
}

void gprintln(messageT)(messageT message, DebugType debugType = DebugType.INFO)
{
    /* Generate the string to print */
    string printStr = to!(string)(message)~"\n";

    /* Call `gprint` */
    gprint(printStr, debugType);
}