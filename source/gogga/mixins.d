/**
 * Build-argument customizable mixin
 * that provides, whicever module
 * imports it, with var-arg logging
 * functions `DEBUG(...)`, `INFO(...)`,
 * `WARN(...)` and `ERROR(...)`.
 *
 * Authors: Tristan Brice Velloza Kildaire
 */
module gogga.mixins;

import gogga;
import gogga.extras;
import dlog.basic : Level, FileHandler;
import std.stdio : stdout;

/**
 * The logger instance
 * shared amongst a single
 * thread (TLS)
 */
private GoggaLogger logger;

/**
 * Initializes a logger instance
 * per thread (TLS)
 */
static this()
{
    logger = new GoggaLogger();

    GoggaMode mode;
    
    version(DBG_VERBOSE_LOGGING)
    {
        mode = GoggaMode.RUSTACEAN;
    }
    else
    {
        mode = GoggaMode.SIMPLE;
    }

    logger.mode(mode);

    Level level;

    version(DBG_DEBUG_LOGGING)
    {
        level = Level.DEBUG;
    }
    else
    {
        level = Level.INFO;
    }

    logger.setLevel(level);
    logger.addHandler(new FileHandler(stdout));
}

// Bring in helper methods
mixin LoggingFuncs!(logger);