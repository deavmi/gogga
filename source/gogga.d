module gogga;

import std.conv : to;
import std.stdio : write, stdout;
import core.sync.mutex : Mutex;

public enum DebugType
{
    INFO,
    WARNING,
    ERROR
}

private __gshared Mutex writeMutex;

/* Initialize the module (only once, regardless of threads) */
shared static this()
{
    /* Initialize the mutex */
    writeMutex = new Mutex();
}

void gprint(messageT)(messageT message, DebugType debugType = DebugType.INFO)
{
    /* TODO: Remove mutex, oneshot write */

    /* Lock output */
    writeMutex.lock();

    /* If INFO, set green */
    if(debugType == DebugType.INFO)
    {
        stdout.rawWrite(cast(byte[])[27, '[','3','2','m']);
    }
    /* If WARNING, set warning */
    else if(debugType == DebugType.WARNING)
    {
        stdout.rawWrite(cast(byte[])[27, '[','3','5','m']); /* TODO: FInd yllow */
    }
    /* If ERROR, set error */
    else if(debugType == DebugType.ERROR)
    {
        stdout.rawWrite(cast(byte[])[27, '[','3','1','m']);
    }

    /* Write the message type */
    write("["~to!(string)(debugType)~"] ");

    /* Switch back color */
    stdout.rawWrite(cast(byte[])[27, '[', '3', '9', 'm']);

    /* Print the message */
    write(message);

    /* Unlock output */
    writeMutex.lock();
}

void gprintln(messageT)(messageT message, DebugType debugType = DebugType.INFO)
{
    /* Generate the string to print */
    string printStr = to!(string)(message)~"\n";

    /* Call `gprint` */
    gprint(printStr, debugType);
}