/**
 * Extra helper utilities
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module gogga.extras;

import gogga.core : GoggaLogger;

/** 
 * Mixes in a set of easy helper methods
 * for each log-level in `Level`, with
 * matching nams
 *
 * Params:
 *   gLogger = the `GoggaLogger` identifier
 */
public mixin template LoggingFuncs(alias gLogger)
if(__traits(isSame, typeof(gLogger), GoggaLogger))
{
    import std.meta : AliasSeq, aliasSeqOf;
    import std.traits : ParameterDefaults;
    import std.traits : EnumMembers;
    import dlog.basic : Level;

    /** 
     * Generatesd a function named after
     * the given log level and using
     * the log level provided with
     * the correct default (call-site
     * based) arguments containing
     * line information
     *
     * Params:
     *   gLogger = the logger identifier
     *   level = the log level
     */
    private mixin template MakeFuncFor(alias GoggaLogger gLogger, Level level)
    {
        import std.conv : to;
        import gogga.core : GoggaCompInfo;
        mixin(`
        public void `~to!(string)(level)~`(Text...)
        (
            Text segments,
            string c1 = __FILE_FULL_PATH__,
            string c2 = __FILE__,
            ulong c3 = __LINE__,
            string c4 = __MODULE__,
            string c5 = __FUNCTION__,
            string c6 = __PRETTY_FUNCTION__
        )
        {
            gLogger.doLog(segments, GoggaCompInfo(c1, c2, c3, c4, c5, c6), Level.`~to!(string)(level)~`);
        }
        `);
    }

    // Generate methods per each log level
    static foreach(level; EnumMembers!(Level))
    {
        mixin MakeFuncFor!(gLogger, level);
    }    
}

version(unittest)
{
    import gogga.extras;
    import std.stdio : writeln, stdout;
    import dlog.basic : Level, FileHandler;
}

/** 
 * Tests using the mixin for method
 * names
 */
unittest
{
    GoggaLogger gLogger = new GoggaLogger();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

    mixin LoggingFuncs!(gLogger);

    DEBUG("This is debug", 2.3, true, [2,2]);
    ERROR("This is error", 2.3, true, [2,2]);
    INFO("This is info", 2.3, true, [2,2]);
    WARN("This is warn", 2.3, true, [2,2]);

    writeln();
}