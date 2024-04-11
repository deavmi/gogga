/**
 * Out-of-module tests
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module gogga.test;

version(unittest)
{
    import gogga;
    import gogga.extras;
    import std.stdio : writeln, stdout;
    import dlog.basic : Level, FileHandler;
}

private unittest
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