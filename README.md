<p align="center">
<img src="branding/logo_banner.png" width=450>
</p>

<br>

<h3 align="center"><i><b>Simple VT100 colourised pretty-printing logger</i></b></h3>

---

<br>
<br

[![D](https://github.com/deavmi/gogga/actions/workflows/d.yml/badge.svg)](https://github.com/deavmi/gogga/actions/workflows/d.yml)
    
## Usage

The API is rather straight-forward, simply create a new logger and then you can use it as such:

```d
import gogga;

GoggaLogger gLogger = new GoggaLogger();

gLogger.info("This is an info message");
gLogger.warn("This is a warning message");
gLogger.error("This is an error message");
```

This should output something like the following:

![](example.png)

Various [styles](https://gogga.dpldocs.info/v3.1.2/gogga.core.GoggaMode.html) are supported which can be set using `mode(GoggaMode)`.

---

Or you can also [View the full API](https://gogga.dpldocs.info/v3.1.2/gogga.html).

### Debugger functions

For quick-and-dirty ease of use there is also a module called `gogga.mixins`. Once
this module is imported it will mixin a set of variadic-argument functions for you
of the form:

1. `DEBUG(...)`
2. `INFO(...)`
3. `WARN(...)`
4. `ERROR(...)`

These will become immediately available to you and a logger that is configured to
write out to standard output will be configured with the styling of `GoggaMode.SIMPLE`
and a logging level of `Level.INFO`.

As for build options there are the following available for configuration:

| Build option name     | Description |
|-----------------------|-------------|
| `DBG_VERBOSE_LOGGING` | When enabled the `GoggaMode.RUSTACEAN` will be used |
| `DBG_DEBUG_LOGGING`   | When enabled the logging level will be set to `Level.DEBUG` |


The `GoggaLogger` logger instance created is shared amongst the same thread _or_
in other words it is stored as part of thread-local storage (TLS). For more information
browse the source code of `source/gogga/mixins.d`.