module gogga.test;

import gogga;

version(unittest)
{
    import std.stdio : writeln, stdout;
    import dlog.basic : Level, FileHandler;
}

unittest
{
    GoggaLogger gLogger = new GoggaLogger();
    gLogger.addHandler(new FileHandler(stdout));
    gLogger.setLevel(Level.DEBUG);

    mixin Lekker!(gLogger);

    DEBUG("fok", 2,2);
    ERROR("fok", 2,2);
    INFO("fok", 2,2);
    WARN("fok", 2,2);

    writeln();
}